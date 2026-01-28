import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../../main.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import 'manual_food_log_screen.dart';

import '../widgets/supplement_alcohol_sheets.dart';
import '../widgets/edit_food_log_dialog.dart';
import '../widgets/edit_alcohol_log_dialog.dart';

class NutritionHomeScreen extends ConsumerStatefulWidget {
  const NutritionHomeScreen({super.key});

  @override
  ConsumerState<NutritionHomeScreen> createState() => _NutritionHomeScreenState();
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

  @override
  void initState() {
    super.initState();
    _loadDailyLogs();
  }

  Future<void> _loadDailyLogs() async {
    final db = ref.read(databaseProvider);
    final start = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final end = start.add(const Duration(days: 1));
    
    final query = db.select(db.foodLogs).join([
      innerJoin(db.foods, db.foods.id.equalsExp(db.foodLogs.foodId)),
    ])
      ..where(db.foodLogs.logDate.isBetweenValues(start, end));
      
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
      innerJoin(db.supplements, db.supplements.id.equalsExp(db.supplementLogs.supplementId)),
    ])
      ..where(db.supplementLogs.logDate.isBetweenValues(start, end));
    
    final suppResults = await suppQuery.get();
    final suppList = suppResults.map((row) => SupplementLogWithDetails(
      log: row.readTable(db.supplementLogs),
      supplement: row.readTable(db.supplements),
    )).toList();
    
    // Load Alcohol Logs
    final alcoholResults = await (db.select(db.alcoholLogs)
      ..where((a) => a.logDate.isBetweenValues(start, end)))
      .get();
    
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
                      onPressed: () => setState(() => _isPlanningMode = !_isPlanningMode),
                      icon: Icon(_isPlanningMode ? Icons.checklist_rounded : Icons.checklist_rtl_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: _isPlanningMode ? AppTheme.nutritionColor : AppTheme.surfaceLight,
                        foregroundColor: _isPlanningMode ? Colors.white : null,
                      ),
                      tooltip: _isPlanningMode ? 'Exit Planning Mode' : 'Enter Planning Mode',
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
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textMuted,
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
                                            value: _totalProtein > 0 ? _totalProtein : 1,
                                            color: AppTheme.proteinColor,
                                            radius: 15,
                                            showTitle: false,
                                          ),
                                          PieChartSectionData(
                                            value: _totalCarbs > 0 ? _totalCarbs : 1,
                                            color: AppTheme.carbsColor,
                                            radius: 15,
                                            showTitle: false,
                                          ),
                                          PieChartSectionData(
                                            value: _totalFat > 0 ? _totalFat : 1,
                                            color: AppTheme.fatColor,
                                            radius: 15,
                                            showTitle: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${_totalCalories.toInt()}',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                            border: Border.all(color: AppTheme.nutritionColor.withValues(alpha: 0.3), width: 2),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Actual',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                                            value: _actualProtein > 0 ? _actualProtein : 1,
                                            color: AppTheme.proteinColor,
                                            radius: 15,
                                            showTitle: false,
                                          ),
                                          PieChartSectionData(
                                            value: _actualCarbs > 0 ? _actualCarbs : 1,
                                            color: AppTheme.carbsColor,
                                            radius: 15,
                                            showTitle: false,
                                          ),
                                          PieChartSectionData(
                                            value: _actualFat > 0 ? _actualFat : 1,
                                            color: AppTheme.fatColor,
                                            radius: 15,
                                            showTitle: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${_actualCalories.toInt()}',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.nutritionColor,
                                ),
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
                                value: _totalProtein > 0 ? _totalProtein : 1,
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
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'kcal',
                              style: Theme.of(context).textTheme.bodySmall,
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
                      _buildMacroLabel('Protein', _totalProtein, 'g', AppTheme.proteinColor),
                      _buildMacroLabel('Carbs', _totalCarbs, 'g', AppTheme.carbsColor),
                      _buildMacroLabel('Fat', _totalFat, 'g', AppTheme.fatColor),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
            
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
                    LinearGradient(colors: [Colors.purple.shade400, Colors.purple.shade600]),
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
                    LinearGradient(colors: [Colors.amber.shade400, Colors.orange.shade600]),
                    () => _showAlcoholSheet(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickAddButton(
                    context,
                    Icons.history_rounded,
                    'Recent',
                    LinearGradient(colors: [Colors.grey.shade600, Colors.grey.shade800]),
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
            
            (_dailyLogs.isEmpty && _supplementLogs.isEmpty && _alcoholLogs.isEmpty)
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
                  ? Border.all(color: AppTheme.textMuted.withValues(alpha: 0.3), width: 1)
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                const SizedBox(width: 8),
              ],
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.nutritionColor.withValues(alpha: log.isEaten || !_isPlanningMode ? 0.1 : 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.restaurant_menu_rounded,
                  color: log.isEaten || !_isPlanningMode ? AppTheme.nutritionColor : AppTheme.textMuted,
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
                        decoration: _isPlanningMode && !log.isEaten ? TextDecoration.lineThrough : null,
                        color: _isPlanningMode && !log.isEaten ? AppTheme.textMuted : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${log.mealType} - ${(food.calories * log.servings).toInt()} kcal',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _isPlanningMode && !log.isEaten ? AppTheme.textMuted : null,
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
                      color: _isPlanningMode && !log.isEaten ? AppTheme.textMuted : AppTheme.proteinColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${(food.carbs * log.servings).toStringAsFixed(1)}c',
                    style: TextStyle(
                      color: _isPlanningMode && !log.isEaten ? AppTheme.textMuted : AppTheme.carbsColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${(food.fat * log.servings).toStringAsFixed(1)}f',
                    style: TextStyle(
                      color: _isPlanningMode && !log.isEaten ? AppTheme.textMuted : AppTheme.fatColor,
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
        Text('Supplements', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted)),
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
                  child: const Icon(Icons.medication_rounded, color: Colors.purple, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(s.supplement.name, style: Theme.of(context).textTheme.titleSmall),
                ),
                Text('${s.log.dosage} ${s.supplement.dosageUnit}', style: Theme.of(context).textTheme.bodySmall),
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
        Text('Alcohol', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted)),
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
                      onChanged: (value) => _toggleAlcoholEaten(a, value ?? false),
                      activeColor: Colors.amber,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: a.isEaten || !_isPlanningMode ? 0.15 : 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.local_bar_rounded, 
                      color: a.isEaten || !_isPlanningMode ? Colors.amber : AppTheme.textMuted,
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
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            decoration: _isPlanningMode && !a.isEaten ? TextDecoration.lineThrough : null,
                            color: _isPlanningMode && !a.isEaten ? AppTheme.textMuted : null,
                          ),
                        ),
                        if (a.volumeMl != null)
                          Text('${a.volumeMl!.toInt()} ml x ${a.units.toStringAsFixed(1)}', 
                               style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textMuted)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${a.calories.toInt()} kcal', 
                           style: Theme.of(context).textTheme.bodySmall?.copyWith(
                             color: _isPlanningMode && !a.isEaten ? AppTheme.textMuted : Colors.amber,
                           )),
                      if (a.carbs > 0)
                        Text('${a.carbs.toStringAsFixed(1)}g carbs', 
                             style: Theme.of(context).textTheme.bodySmall?.copyWith(
                               color: _isPlanningMode && !a.isEaten ? AppTheme.textMuted : AppTheme.carbsColor, 
                               fontSize: 10,
                             )),
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

  Widget _buildMacroLabel(String label, double value, String unit, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(1)}$unit',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: color,
          ),
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
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleSmall,
              ),
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
      MaterialPageRoute(builder: (_) => ManualFoodLogScreen(initialDate: _selectedDate)),
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
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Barcode scanner coming soon')));
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: AppTheme.lightTheme, // Force light theme for picker or match current
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (picked.year == _selectedDate.year && picked.month == _selectedDate.month && picked.day == _selectedDate.day) return;
      
      setState(() => _selectedDate = picked);
      _loadDailyLogs();
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
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
