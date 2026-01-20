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

class NutritionHomeScreen extends ConsumerStatefulWidget {
  const NutritionHomeScreen({super.key});

  @override
  ConsumerState<NutritionHomeScreen> createState() => _NutritionHomeScreenState();
}

class _NutritionHomeScreenState extends ConsumerState<NutritionHomeScreen> {
  DateTime _selectedDate = DateTime.now();
  
  // Today's totals (will be calculated from food logs)
  double _totalCalories = 0;
  double _totalProtein = 0;
  double _totalCarbs = 0;
  double _totalFat = 0;

  bool _isLoading = true;
  List<TypedResult> _dailyLogs = [];
  List<SupplementLogWithDetails> _supplementLogs = [];

  @override
  void initState() {
    super.initState();
    _loadDailyLogs();
  }

  Future<void> _loadDailyLogs() async {
    setState(() => _isLoading = true);
    final db = ref.read(databaseProvider);
    final start = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final end = start.add(const Duration(days: 1));
    
    final query = db.select(db.foodLogs).join([
      innerJoin(db.foods, db.foods.id.equalsExp(db.foodLogs.foodId)),
    ])
      ..where(db.foodLogs.logDate.isBetweenValues(start, end));
      
    final results = await query.get();
    
    double cal = 0, prot = 0, carb = 0, fat = 0;
    
    for (var row in results) {
      final log = row.readTable(db.foodLogs);
      final food = row.readTable(db.foods);
      final ratio = log.servings;
      
      cal += food.calories * ratio;
      prot += food.protein * ratio;
      carb += food.carbs * ratio;
      fat += food.fat * ratio;
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
    
    if (mounted) {
      setState(() {
        _dailyLogs = results;
        _supplementLogs = suppList;
        _totalCalories = cal;
        _totalProtein = prot;
        _totalCarbs = carb;
        _totalFat = fat;
        _isLoading = false;
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
            
            // Macro Ring Chart
            Container(
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
            
            (_dailyLogs.isEmpty && _supplementLogs.isEmpty)
                ? _buildEmptyLogState()
                : Column(
                    children: [
                      if (_dailyLogs.isNotEmpty) _buildFoodList(),
                      if (_supplementLogs.isNotEmpty) ...[                  
                        const SizedBox(height: 16),
                        _buildSupplementList(),
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
            ),
            child: Row(
              children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.nutritionColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.restaurant_menu_rounded, color: AppTheme.nutritionColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${log.mealType} • ${food.calories.toInt()} kcal',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${food.protein.toStringAsFixed(1)}p',
                    style: TextStyle(color: AppTheme.proteinColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${food.carbs.toStringAsFixed(1)}c',
                    style: TextStyle(color: AppTheme.carbsColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${food.fat.toStringAsFixed(1)}f',
                    style: TextStyle(color: AppTheme.fatColor, fontSize: 12, fontWeight: FontWeight.bold),
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
      MaterialPageRoute(builder: (_) => const ManualFoodLogScreen()),
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
      builder: (context) => const SupplementLogSheet(),
    );
    _loadDailyLogs(); // Refresh after closing
  }

  void _showAlcoholSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AlcoholLogSheet(),
    );
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
