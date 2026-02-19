import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../../main.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../data/repositories/calorie_planning_repository.dart';
import '../../providers/food_providers.dart';
import 'cut_progress_screen.dart';
import 'manual_food_log_screen.dart';

import '../widgets/supplement_alcohol_sheets.dart';
import '../widgets/edit_food_log_dialog.dart';
import '../widgets/edit_alcohol_log_dialog.dart';

class NutritionHomeScreen extends ConsumerStatefulWidget {
  const NutritionHomeScreen({super.key});

  @override
  ConsumerState<NutritionHomeScreen> createState() =>
      _NutritionHomeScreenState();
}

class _NutritionHomeScreenState extends ConsumerState<NutritionHomeScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _isPlanningMode = false; // Planning mode toggle

  // Target totals (all logged food)
  double _totalCalories = 0;
  double _totalProtein = 0;
  double _totalCarbs = 0;
  double _totalFat = 0;

  // Actual totals (only eaten food)
  double _actualCalories = 0;
  double _actualProtein = 0;
  double _actualCarbs = 0;
  double _actualFat = 0;

  List<TypedResult> _dailyLogs = [];
  List<SupplementLogWithDetails> _supplementLogs = [];
  List<AlcoholLog> _alcoholLogs = [];
  DailyDeficitSummary? _dailyDeficit;
  WeeklyDeficitSummary? _weeklyDeficit;
  PlanDeficitSummary? _activePlanDeficit;
  double? _currentBmr;

  @override
  void initState() {
    super.initState();
    _loadDailyLogs();
  }

  Future<void> _loadDailyLogs() async {
    final db = ref.read(databaseProvider);
    final planningRepo = ref.read(caloriePlanningRepositoryProvider);
    final start = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    final end = start.add(const Duration(days: 1));

    final query = db.select(db.foodLogs).join([
      innerJoin(db.foods, db.foods.id.equalsExp(db.foodLogs.foodId)),
    ])..where(db.foodLogs.logDate.isBetweenValues(start, end));

    final results = await query.get();

    // Target totals (all food)
    double cal = 0, prot = 0, carb = 0, fat = 0;
    // Actual totals (only eaten food)
    double aCal = 0, aProt = 0, aCarb = 0, aFat = 0;

    for (var row in results) {
      final log = row.readTable(db.foodLogs);
      final food = row.readTable(db.foods);
      final ratio = log.servings;

      // Add to target totals (all food)
      cal += food.calories * ratio;
      prot += food.protein * ratio;
      carb += food.carbs * ratio;
      fat += food.fat * ratio;

      // Add to actual totals only if eaten
      if (log.isEaten) {
        aCal += food.calories * ratio;
        aProt += food.protein * ratio;
        aCarb += food.carbs * ratio;
        aFat += food.fat * ratio;
      }
    }

    // Load Supplement Logs
    final suppQuery = db.select(db.supplementLogs).join([
      innerJoin(
        db.supplements,
        db.supplements.id.equalsExp(db.supplementLogs.supplementId),
      ),
    ])..where(db.supplementLogs.logDate.isBetweenValues(start, end));

    final suppResults = await suppQuery.get();
    final suppList = suppResults
        .map(
          (row) => SupplementLogWithDetails(
            log: row.readTable(db.supplementLogs),
            supplement: row.readTable(db.supplements),
          ),
        )
        .toList();

    // Load Alcohol Logs
    final alcoholResults = await (db.select(
      db.alcoholLogs,
    )..where((a) => a.logDate.isBetweenValues(start, end))).get();

    // Add alcohol macros to totals
    for (var alcohol in alcoholResults) {
      cal += alcohol.calories;
      prot += alcohol.protein;
      carb += alcohol.carbs;
      fat += alcohol.fat;

      // Add to actual totals only if eaten (drank)
      if (alcohol.isEaten) {
        aCal += alcohol.calories;
        aProt += alcohol.protein;
        aCarb += alcohol.carbs;
        aFat += alcohol.fat;
      }
    }

    final dailyDeficit = await planningRepo.getDailyDeficit(_selectedDate);
    final weeklyDeficit = await planningRepo.getWeeklyDeficit(_selectedDate);
    final activePlanDeficit = await planningRepo.getActivePlanSummary(
      referenceDate: _selectedDate,
    );
    final currentBmr = await planningRepo.getCurrentBmr();

    if (mounted) {
      setState(() {
        _dailyLogs = results;
        _supplementLogs = suppList;
        _alcoholLogs = alcoholResults;
        _totalCalories = cal;
        _totalProtein = prot;
        _totalCarbs = carb;
        _totalFat = fat;
        _actualCalories = aCal;
        _actualProtein = aProt;
        _actualCarbs = aCarb;
        _actualFat = aFat;
        _dailyDeficit = dailyDeficit;
        _weeklyDeficit = weeklyDeficit;
        _activePlanDeficit = activePlanDeficit;
        _currentBmr = currentBmr;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nutrition',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(_selectedDate),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Planning Mode Toggle
                    IconButton(
                      onPressed: () =>
                          setState(() => _isPlanningMode = !_isPlanningMode),
                      icon: Icon(
                        _isPlanningMode
                            ? Icons.checklist_rounded
                            : Icons.checklist_rtl_rounded,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: _isPlanningMode
                            ? AppTheme.nutritionColor
                            : AppTheme.surfaceLight,
                        foregroundColor: _isPlanningMode ? Colors.white : null,
                      ),
                      tooltip: _isPlanningMode
                          ? 'Exit Planning Mode'
                          : 'Enter Planning Mode',
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_month_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.surfaceLight,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _showBarcodeScannerPlaceholder(context),
                      icon: const Icon(Icons.qr_code_scanner_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.accent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 24),

            // Macro Ring Chart - Split view in planning mode
            _isPlanningMode
                ? Row(
                    children: [
                      // Target (Planned)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.card,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Target',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppTheme.textMuted),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 100,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    PieChart(
                                      PieChartData(
                                        sectionsSpace: 2,
                                        centerSpaceRadius: 30,
                                        sections: [
                                          PieChartSectionData(
                                            value: _totalProtein > 0
                                                ? _totalProtein
                                                : 1,
                                            color: AppTheme.proteinColor,
                                            radius: 15,
                                            showTitle: false,
                                          ),
                                          PieChartSectionData(
                                            value: _totalCarbs > 0
                                                ? _totalCarbs
                                                : 1,
                                            color: AppTheme.carbsColor,
                                            radius: 15,
                                            showTitle: false,
                                          ),
                                          PieChartSectionData(
                                            value: _totalFat > 0
                                                ? _totalFat
                                                : 1,
                                            color: AppTheme.fatColor,
                                            radius: 15,
                                            showTitle: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${_totalCalories.toInt()}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${_totalProtein.toInt()}p • ${_totalCarbs.toInt()}c • ${_totalFat.toInt()}f',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Actual (Eaten)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.nutritionColor.withValues(
                                alpha: 0.3,
                              ),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Actual',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppTheme.nutritionColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 100,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    PieChart(
                                      PieChartData(
                                        sectionsSpace: 2,
                                        centerSpaceRadius: 30,
                                        sections: [
                                          PieChartSectionData(
                                            value: _actualProtein > 0
                                                ? _actualProtein
                                                : 1,
                                            color: AppTheme.proteinColor,
                                            radius: 15,
                                            showTitle: false,
                                          ),
                                          PieChartSectionData(
                                            value: _actualCarbs > 0
                                                ? _actualCarbs
                                                : 1,
                                            color: AppTheme.carbsColor,
                                            radius: 15,
                                            showTitle: false,
                                          ),
                                          PieChartSectionData(
                                            value: _actualFat > 0
                                                ? _actualFat
                                                : 1,
                                            color: AppTheme.fatColor,
                                            radius: 15,
                                            showTitle: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${_actualCalories.toInt()}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.nutritionColor,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${_actualProtein.toInt()}p • ${_actualCarbs.toInt()}c • ${_actualFat.toInt()}f',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppTheme.nutritionColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 100.ms, duration: 400.ms)
                : Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              PieChart(
                                PieChartData(
                                  sectionsSpace: 4,
                                  centerSpaceRadius: 60,
                                  sections: [
                                    PieChartSectionData(
                                      value: _totalProtein > 0
                                          ? _totalProtein
                                          : 1,
                                      color: AppTheme.proteinColor,
                                      radius: 30,
                                      showTitle: false,
                                    ),
                                    PieChartSectionData(
                                      value: _totalCarbs > 0 ? _totalCarbs : 1,
                                      color: AppTheme.carbsColor,
                                      radius: 30,
                                      showTitle: false,
                                    ),
                                    PieChartSectionData(
                                      value: _totalFat > 0 ? _totalFat : 1,
                                      color: AppTheme.fatColor,
                                      radius: 30,
                                      showTitle: false,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${_totalCalories.toInt()}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    'kcal',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMacroLabel(
                              'Protein',
                              _totalProtein,
                              'g',
                              AppTheme.proteinColor,
                            ),
                            _buildMacroLabel(
                              'Carbs',
                              _totalCarbs,
                              'g',
                              AppTheme.carbsColor,
                            ),
                            _buildMacroLabel(
                              'Fat',
                              _totalFat,
                              'g',
                              AppTheme.fatColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

            const SizedBox(height: 24),
            _buildDeficitTrackingCard().animate().fadeIn(
              delay: 120.ms,
              duration: 400.ms,
            ),
            const SizedBox(height: 24),

            // Quick Add Buttons
            Row(
              children: [
                Expanded(
                  child: _buildQuickAddButton(
                    context,
                    Icons.restaurant_rounded,
                    'Add Food',
                    AppTheme.nutritionGradient,
                    () => _showAddFoodSheet(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickAddButton(
                    context,
                    Icons.medication_rounded,
                    'Supplements',
                    LinearGradient(
                      colors: [Colors.purple.shade400, Colors.purple.shade600],
                    ),
                    () => _showSupplementsSheet(context),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildQuickAddButton(
                    context,
                    Icons.local_bar_rounded,
                    'Alcohol',
                    LinearGradient(
                      colors: [Colors.amber.shade400, Colors.orange.shade600],
                    ),
                    () => _showAlcoholSheet(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickAddButton(
                    context,
                    Icons.history_rounded,
                    'Recent',
                    LinearGradient(
                      colors: [Colors.grey.shade600, Colors.grey.shade800],
                    ),
                    () {},
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

            const SizedBox(height: 24),

            // Today's Log
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Log',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (_dailyLogs.isNotEmpty)
                  // Small summary text? Or nothing.
                  const SizedBox.shrink(),
              ],
            ).animate().fadeIn(delay: 250.ms),

            const SizedBox(height: 12),

            (_dailyLogs.isEmpty &&
                    _supplementLogs.isEmpty &&
                    _alcoholLogs.isEmpty)
                ? _buildEmptyLogState()
                : Column(
                    children: [
                      if (_dailyLogs.isNotEmpty) _buildFoodList(),
                      if (_supplementLogs.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildSupplementList(),
                      ],
                      if (_alcoholLogs.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildAlcoholList(),
                      ],
                    ],
                  ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodList() {
    final db = ref.read(databaseProvider);
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _dailyLogs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final row = _dailyLogs[index];
        final log = row.readTable(db.foodLogs);
        final food = row.readTable(db.foods);

        return InkWell(
          onTap: () => _editFoodLog(context, log, food),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(16),
              // Visual indication of not eaten in planning mode
              border: _isPlanningMode && !log.isEaten
                  ? Border.all(
                      color: AppTheme.textMuted.withValues(alpha: 0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                // Checkbox in planning mode
                if (_isPlanningMode) ...[
                  Checkbox(
                    value: log.isEaten,
                    onChanged: (value) => _toggleEaten(log, value ?? false),
                    activeColor: AppTheme.nutritionColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.nutritionColor.withValues(
                      alpha: log.isEaten || !_isPlanningMode ? 0.1 : 0.05,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.restaurant_menu_rounded,
                    color: log.isEaten || !_isPlanningMode
                        ? AppTheme.nutritionColor
                        : AppTheme.textMuted,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          decoration: _isPlanningMode && !log.isEaten
                              ? TextDecoration.lineThrough
                              : null,
                          color: _isPlanningMode && !log.isEaten
                              ? AppTheme.textMuted
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${log.mealType} - ${(food.calories * log.servings).toInt()} kcal',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _isPlanningMode && !log.isEaten
                              ? AppTheme.textMuted
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${(food.protein * log.servings).toStringAsFixed(1)}p',
                      style: TextStyle(
                        color: _isPlanningMode && !log.isEaten
                            ? AppTheme.textMuted
                            : AppTheme.proteinColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${(food.carbs * log.servings).toStringAsFixed(1)}c',
                      style: TextStyle(
                        color: _isPlanningMode && !log.isEaten
                            ? AppTheme.textMuted
                            : AppTheme.carbsColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${(food.fat * log.servings).toStringAsFixed(1)}f',
                      style: TextStyle(
                        color: _isPlanningMode && !log.isEaten
                            ? AppTheme.textMuted
                            : AppTheme.fatColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: (300 + index * 50).ms),
        );
      },
    );
  }

  /// Toggle the eaten status of a food log
  Future<void> _toggleEaten(FoodLog log, bool eaten) async {
    final db = ref.read(databaseProvider);
    await (db.update(db.foodLogs)..where((l) => l.id.equals(log.id))).write(
      FoodLogsCompanion(isEaten: Value(eaten)),
    );
    _loadDailyLogs(); // Refresh to update totals
  }

  /// Toggle the eaten status of an alcohol log
  Future<void> _toggleAlcoholEaten(AlcoholLog log, bool eaten) async {
    final db = ref.read(databaseProvider);
    await (db.update(db.alcoholLogs)..where((l) => l.id.equals(log.id))).write(
      AlcoholLogsCompanion(isEaten: Value(eaten)),
    );
    _loadDailyLogs(); // Refresh to update totals
  }

  Widget _buildSupplementList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Supplements',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted),
        ),
        const SizedBox(height: 8),
        ...List.generate(_supplementLogs.length, (index) {
          final s = _supplementLogs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.medication_rounded,
                    color: Colors.purple,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    s.supplement.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Text(
                  '${s.log.dosage} ${s.supplement.dosageUnit}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ).animate().fadeIn(delay: (400 + index * 50).ms);
        }),
      ],
    );
  }

  Widget _buildAlcoholList() {
    // Drink type display names
    const drinkNames = {
      'beer': 'Beer',
      'wine': 'Wine',
      'whiskey': 'Whiskey',
      'vodka': 'Vodka',
      'cocktail': 'Cocktail',
      'other': 'Other',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alcohol',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted),
        ),
        const SizedBox(height: 8),
        ...List.generate(_alcoholLogs.length, (index) {
          final a = _alcoholLogs[index];
          final drinkName = drinkNames[a.drinkType] ?? a.drinkType;
          return InkWell(
            onTap: () => _editAlcoholLog(context, a),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  if (_isPlanningMode) ...[
                    Checkbox(
                      value: a.isEaten,
                      onChanged: (value) =>
                          _toggleAlcoholEaten(a, value ?? false),
                      activeColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(
                        alpha: a.isEaten || !_isPlanningMode ? 0.15 : 0.05,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.local_bar_rounded,
                      color: a.isEaten || !_isPlanningMode
                          ? Colors.amber
                          : AppTheme.textMuted,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          drinkName,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                decoration: _isPlanningMode && !a.isEaten
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: _isPlanningMode && !a.isEaten
                                    ? AppTheme.textMuted
                                    : null,
                              ),
                        ),
                        if (a.volumeMl != null)
                          Text(
                            '${a.volumeMl!.toInt()} ml x ${a.units.toStringAsFixed(1)}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppTheme.textMuted),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${a.calories.toInt()} kcal',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _isPlanningMode && !a.isEaten
                              ? AppTheme.textMuted
                              : Colors.amber,
                        ),
                      ),
                      if (a.carbs > 0)
                        Text(
                          '${a.carbs.toStringAsFixed(1)}g carbs',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: _isPlanningMode && !a.isEaten
                                    ? AppTheme.textMuted
                                    : AppTheme.carbsColor,
                                fontSize: 10,
                              ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: (450 + index * 50).ms);
        }),
      ],
    );
  }

  void _editAlcoholLog(BuildContext context, AlcoholLog log) async {
    final result = await showDialog(
      context: context,
      builder: (context) => EditAlcoholLogDialog(log: log),
    );

    if (result == true) {
      _loadDailyLogs();
    }
  }

  Widget _buildDeficitTrackingCard() {
    final daily = _dailyDeficit;
    final weekly = _weeklyDeficit;
    final planSummary = _activePlanDeficit;
    final dailyDeficit = daily?.deficit ?? 0;
    final weeklyDeficit = weekly?.deficit ?? 0;
    final bmr = _currentBmr;
    final activityBurn = (daily?.caloriesOut ?? 0) - (bmr ?? 0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.nutritionColor.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.track_changes_rounded,
                color: AppTheme.nutritionColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Energy & Deficit',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              if (planSummary != null)
                IconButton(
                  onPressed: _clearActivePlan,
                  icon: const Icon(Icons.pause_circle_outline_rounded),
                  tooltip: 'Deactivate Plan',
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.surfaceLight,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDeficitMetric(
                  'In',
                  '${(daily?.caloriesIn ?? 0).toInt()}',
                  Colors.orange.shade400,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDeficitMetric(
                  'Out',
                  '${(daily?.caloriesOut ?? 0).toInt()}',
                  Colors.blue.shade400,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDeficitMetric(
                  'Daily',
                  _formatSignedCalories(dailyDeficit),
                  _deficitColor(dailyDeficit),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDeficitMetric(
                  'Steps',
                  '${daily?.steps ?? 0}',
                  AppTheme.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDeficitMetric(
                  'Week',
                  _formatSignedCalories(weeklyDeficit),
                  _deficitColor(weeklyDeficit),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDeficitMetric(
                  'Avg/Day',
                  planSummary == null
                      ? '--'
                      : _formatSignedCalories(planSummary.averageDailyDeficit),
                  planSummary == null
                      ? AppTheme.textMuted
                      : _deficitColor(planSummary.averageDailyDeficit),
                ),
              ),
            ],
          ),
          if (bmr != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildDeficitMetric(
                    'BMR',
                    '${bmr.toInt()}',
                    Colors.purple.shade400,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDeficitMetric(
                    'Activity',
                    _formatSignedCalories(activityBurn),
                    activityBurn >= 0
                        ? Colors.blue.shade400
                        : Colors.red.shade400,
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(child: SizedBox.shrink()),
              ],
            ),
          ],
          if (planSummary != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${planSummary.plan.name} • ${_goalTypeLabel(planSummary.plan.goalType)}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Week ${planSummary.elapsedWeeks}/${planSummary.totalWeeks} • ${_formatSignedCalories(planSummary.totalDeficit)} total',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppTheme.textMuted),
                  ),
                  if (planSummary.targetTotalDeficit != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Target total deficit: ${_formatSignedCalories(planSummary.targetTotalDeficit!.toDouble())}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showEnergyLogDialog,
                  icon: const Icon(Icons.edit_rounded, size: 18),
                  label: const Text('Log Out + Steps'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showPlanDialog,
                  icon: const Icon(Icons.event_note_rounded, size: 18),
                  label: const Text('Plan Weeks'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showBmrDialog,
                  icon: const Icon(Icons.monitor_weight_outlined, size: 18),
                  label: Text(bmr == null ? 'Set BMR' : 'BMR ${bmr.toInt()}'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: planSummary == null
                      ? null
                      : _openCutProgressScreen,
                  icon: const Icon(Icons.show_chart_rounded, size: 18),
                  label: const Text('Cut Progress'),
                ),
              ),
            ],
          ),
          if (planSummary != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showEditWeekTargetsDialog,
                    icon: const Icon(Icons.tune_rounded, size: 18),
                    label: const Text('Edit Week Targets'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDeficitMetric(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppTheme.textMuted),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Color _deficitColor(double deficit) {
    if (deficit > 0) return Colors.green.shade500;
    if (deficit < 0) return Colors.red.shade400;
    return AppTheme.textSecondary;
  }

  String _formatSignedCalories(double value) {
    final intValue = value.round();
    if (intValue > 0) return '+$intValue';
    return '$intValue';
  }

  String _goalTypeLabel(String goalType) {
    switch (nutritionGoalTypeFromDb(goalType)) {
      case NutritionGoalType.maintain:
        return 'Maintain';
      case NutritionGoalType.gain:
        return 'Gain';
      case NutritionGoalType.cut:
        return 'Cut';
    }
  }

  Future<void> _showEnergyLogDialog() async {
    final repo = ref.read(caloriePlanningRepositoryProvider);
    final existing = await repo.getDailyEnergyLog(_selectedDate);
    final bmr = await repo.getCurrentBmr();
    if (!mounted) return;

    final caloriesOutController = TextEditingController(
      text:
          existing?.caloriesOut.toStringAsFixed(0) ??
          (bmr?.toStringAsFixed(0) ?? ''),
    );
    final stepsController = TextEditingController(
      text: existing?.steps.toString() ?? '',
    );
    final notesController = TextEditingController(text: existing?.notes ?? '');

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Log Daily Out + Steps'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: caloriesOutController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Calories Out',
                hintText: 'e.g. 2400',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: stepsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Steps',
                hintText: 'e.g. 9000',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Notes (Optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (shouldSave == true) {
      final caloriesOut = double.tryParse(caloriesOutController.text.trim());
      final steps = int.tryParse(stepsController.text.trim()) ?? 0;

      if (caloriesOut == null || caloriesOut <= 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Enter a valid calories out value')),
          );
        }
      } else {
        await repo.upsertDailyEnergyLog(
          date: _selectedDate,
          caloriesOut: caloriesOut,
          steps: steps < 0 ? 0 : steps,
          notes: notesController.text.trim().isEmpty
              ? null
              : notesController.text.trim(),
        );
        await _loadDailyLogs();
      }
    }

    caloriesOutController.dispose();
    stepsController.dispose();
    notesController.dispose();
  }

  Future<void> _showBmrDialog() async {
    final repo = ref.read(caloriePlanningRepositoryProvider);
    final existingBmr = await repo.getCurrentBmr();
    if (!mounted) return;

    final bmrController = TextEditingController(
      text: existingBmr?.toStringAsFixed(0) ?? '',
    );

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Set BMR'),
        content: TextField(
          controller: bmrController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Basal Metabolic Rate',
            hintText: 'e.g. 1650 kcal/day',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (shouldSave == true) {
      final bmr = double.tryParse(bmrController.text.trim());
      if (bmr == null || bmr <= 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Enter a valid BMR value')),
          );
        }
      } else {
        await repo.upsertCurrentBmr(bmr);
        await _loadDailyLogs();
      }
    }

    bmrController.dispose();
  }

  Future<void> _showPlanDialog() async {
    final repo = ref.read(caloriePlanningRepositoryProvider);
    final nameController = TextEditingController(
      text: 'Plan ${DateTime.now().month}/${DateTime.now().day}',
    );
    final weeksController = TextEditingController(text: '8');
    final targetDailyController = TextEditingController();
    final targetWeeklyDeficitController = TextEditingController(text: '3500');
    DateTime startDate = _selectedDate;
    NutritionGoalType goalType = NutritionGoalType.cut;

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.surface,
              title: const Text('Create Multi-Week Plan'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Plan Name'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<NutritionGoalType>(
                      initialValue: goalType,
                      dropdownColor: AppTheme.surface,
                      items: const [
                        DropdownMenuItem(
                          value: NutritionGoalType.maintain,
                          child: Text('Maintain'),
                        ),
                        DropdownMenuItem(
                          value: NutritionGoalType.gain,
                          child: Text('Gain'),
                        ),
                        DropdownMenuItem(
                          value: NutritionGoalType.cut,
                          child: Text('Cut'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => goalType = value);
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Goal Type'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: weeksController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Total Weeks',
                        hintText: 'e.g. 8',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: targetDailyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Target Calories In (Daily, Optional)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: targetWeeklyDeficitController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Target Weekly Deficit (Optional)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: AppTheme.lightTheme,
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setDialogState(() => startDate = picked);
                        }
                      },
                      icon: const Icon(Icons.calendar_today_rounded, size: 16),
                      label: Text(
                        'Start: ${startDate.day}/${startDate.month}/${startDate.year}',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (shouldSave == true) {
      final weeks = int.tryParse(weeksController.text.trim()) ?? 0;
      if (weeks <= 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Total weeks must be at least 1')),
          );
        }
      } else {
        final targetDaily = int.tryParse(targetDailyController.text.trim());
        final targetWeeklyDeficit = int.tryParse(
          targetWeeklyDeficitController.text.trim(),
        );
        await repo.createPlan(
          name: nameController.text.trim(),
          goalType: goalType,
          startDate: startDate,
          totalWeeks: weeks,
          targetDailyCalories: targetDaily,
          targetWeeklyDeficit: targetWeeklyDeficit,
          setActive: true,
        );
        await _loadDailyLogs();
      }
    }

    nameController.dispose();
    weeksController.dispose();
    targetDailyController.dispose();
    targetWeeklyDeficitController.dispose();
  }

  Future<void> _showEditWeekTargetsDialog() async {
    final repo = ref.read(caloriePlanningRepositoryProvider);
    final activePlan = await repo.getActivePlan();

    if (activePlan == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Create and activate a plan first')),
        );
      }
      return;
    }

    final weeks = await repo.getPlanWeeks(activePlan.id);
    if (!mounted) return;
    if (weeks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No weeks found in this plan')),
      );
      return;
    }

    final dailyControllers = <int, TextEditingController>{};
    final weeklyControllers = <int, TextEditingController>{};
    for (final week in weeks) {
      dailyControllers[week.weekNumber] = TextEditingController(
        text: week.targetDailyCalories?.toString() ?? '',
      );
      weeklyControllers[week.weekNumber] = TextEditingController(
        text: week.targetWeeklyDeficit?.toString() ?? '',
      );
    }

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text('Edit Week Targets • ${activePlan.name}'),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: weeks
                  .map(
                    (week) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Week ${week.weekNumber} • ${week.weekStartDate.day}/${week.weekStartDate.month} - ${week.weekEndDate.day}/${week.weekEndDate.month}',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: dailyControllers[week.weekNumber],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Daily Calories In',
                                    hintText: 'Optional',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller:
                                      weeklyControllers[week.weekNumber],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Weekly Deficit',
                                    hintText: 'Optional',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (shouldSave == true) {
      final updates = weeks
          .map(
            (week) => PlanWeekTargetInput(
              weekNumber: week.weekNumber,
              targetDailyCalories: _nullableInt(
                dailyControllers[week.weekNumber]?.text,
              ),
              targetWeeklyDeficit: _nullableInt(
                weeklyControllers[week.weekNumber]?.text,
              ),
            ),
          )
          .toList();

      await repo.updatePlanWeekTargets(
        planId: activePlan.id,
        weekTargets: updates,
      );
      await _loadDailyLogs();
    }

    for (final controller in dailyControllers.values) {
      controller.dispose();
    }
    for (final controller in weeklyControllers.values) {
      controller.dispose();
    }
  }

  void _openCutProgressScreen() {
    final planSummary = _activePlanDeficit;
    if (planSummary == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No active plan found')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CutProgressScreen(planId: planSummary.plan.id),
      ),
    );
  }

  int? _nullableInt(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return int.tryParse(trimmed);
  }

  Future<void> _clearActivePlan() async {
    final repo = ref.read(caloriePlanningRepositoryProvider);
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Deactivate Active Plan?'),
        content: const Text(
          'This keeps all past data, but stops the current plan from being active.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'Deactivate',
              style: TextStyle(color: Colors.red.shade400),
            ),
          ),
        ],
      ),
    );

    if (shouldClear == true) {
      await repo.clearActivePlan();
      await _loadDailyLogs();
    }
  }

  Widget _buildMacroLabel(
    String label,
    double value,
    String unit,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(1)}$unit',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color),
        ),
      ],
    );
  }

  Widget _buildQuickAddButton(
    BuildContext context,
    IconData icon,
    String label,
    LinearGradient gradient,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.titleSmall),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyLogState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.restaurant_menu_rounded,
              size: 48,
              color: AppTheme.nutritionColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No food logged today',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap Add Food to start',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  void _showAddFoodSheet(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ManualFoodLogScreen(initialDate: _selectedDate),
      ),
    );

    if (result == true) {
      _loadDailyLogs();
    }
  }

  void _showSupplementsSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SupplementLogSheet(initialDate: _selectedDate),
    );
    _loadDailyLogs(); // Refresh after closing
  }

  void _showAlcoholSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AlcoholLogSheet(initialDate: _selectedDate),
    );
    _loadDailyLogs(); // Refresh after closing
  }

  void _showBarcodeScannerPlaceholder(BuildContext context) {
    // Placeholder - user wanted manual flow strictly, maybe remove this or point to manual too?
    // I will keep it for now as placeholder for future
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Barcode scanner coming soon')),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: AppTheme
              .lightTheme, // Force light theme for picker or match current
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (picked.year == _selectedDate.year &&
          picked.month == _selectedDate.month &&
          picked.day == _selectedDate.day) {
        return;
      }

      setState(() => _selectedDate = picked);
      _loadDailyLogs();
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  void _editFoodLog(BuildContext context, FoodLog log, Food food) async {
    final result = await showDialog(
      context: context,
      builder: (context) => EditFoodLogDialog(log: log, food: food),
    );

    if (result == true) {
      _loadDailyLogs();
    }
  }
}

class SupplementLogWithDetails {
  final SupplementLog log;
  final Supplement supplement;
  SupplementLogWithDetails({required this.log, required this.supplement});
}
