import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';

class EditFoodLogDialog extends ConsumerStatefulWidget {
  final FoodLog log;
  final Food food;

  const EditFoodLogDialog({
    super.key,
    required this.log,
    required this.food,
  });

  @override
  ConsumerState<EditFoodLogDialog> createState() => _EditFoodLogDialogState();
}

class _EditFoodLogDialogState extends ConsumerState<EditFoodLogDialog> {
  late TextEditingController _servingsController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatController;
  late String _selectedMealType;
  bool _isEditingMacros = false;
  
  // Calculated macros based on servings
  double get _baseCalories => double.tryParse(_caloriesController.text) ?? 0;
  double get _baseProtein => double.tryParse(_proteinController.text) ?? 0;
  double get _baseCarbs => double.tryParse(_carbsController.text) ?? 0;
  double get _baseFat => double.tryParse(_fatController.text) ?? 0;
  double get _servings => double.tryParse(_servingsController.text) ?? 0;
  
  double get _currentCalories => _baseCalories * _servings;
  double get _currentProtein => _baseProtein * _servings;
  double get _currentCarbs => _baseCarbs * _servings;
  double get _currentFat => _baseFat * _servings;

  @override
  void initState() {
    super.initState();
    _servingsController = TextEditingController(text: widget.log.servings.toString());
    _caloriesController = TextEditingController(text: widget.food.calories.toString());
    _proteinController = TextEditingController(text: widget.food.protein.toString());
    _carbsController = TextEditingController(text: widget.food.carbs.toString());
    _fatController = TextEditingController(text: widget.food.fat.toString());
    _selectedMealType = widget.log.mealType;
  }

  @override
  void dispose() {
    _servingsController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final servings = double.tryParse(_servingsController.text);
    if (servings == null || servings <= 0) return;

    final db = ref.read(databaseProvider);
    
    // Update the food log
    final updatedLog = widget.log.copyWith(
      servings: servings,
      mealType: _selectedMealType,
    );
    await db.update(db.foodLogs).replace(updatedLog);
    
    // If macros were edited, update the food record too
    if (_isEditingMacros) {
      await (db.update(db.foods)..where((f) => f.id.equals(widget.food.id))).write(
        FoodsCompanion(
          calories: Value(_baseCalories),
          protein: Value(_baseProtein),
          carbs: Value(_baseCarbs),
          fat: Value(_baseFat),
        ),
      );
    }
    
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Delete Log?'),
        content: Text('Remove ${widget.food.name} from your log?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete', style: TextStyle(color: Colors.red.shade400)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final db = ref.read(databaseProvider);
      await (db.delete(db.foodLogs)..where((tbl) => tbl.id.equals(widget.log.id))).go();
      
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Edit Entry',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    onPressed: _delete,
                    icon: Icon(Icons.delete_outline_rounded, color: Colors.red.shade400),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Food Name
              Text(
                widget.food.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              
              // Servings and Meal Type
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _servingsController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Servings',
                        suffixText: 'srv',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedMealType,
                      dropdownColor: AppTheme.surface,
                      decoration: const InputDecoration(labelText: 'Meal'),
                      items: ['Breakfast', 'Lunch', 'Dinner', 'Snack']
                          .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedMealType = v!),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Edit Macros Toggle
              Row(
                children: [
                  Text(
                    'Edit Macros (per serving)',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const Spacer(),
                  Switch(
                    value: _isEditingMacros,
                    onChanged: (v) => setState(() => _isEditingMacros = v),
                    activeColor: AppTheme.nutritionColor,
                  ),
                ],
              ),
              
              // Macro editing fields (when toggled)
              if (_isEditingMacros) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _caloriesController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Calories'),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _proteinController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Protein (g)'),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _carbsController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Carbs (g)'),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _fatController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Fat (g)'),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 20),
              
              // Live Macro Preview
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Total for ${_servings.toStringAsFixed(1)} serving(s)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMacroStat('Calories', '${_currentCalories.toInt()}', Theme.of(context).textTheme.bodyLarge!.color!),
                        _buildMacroStat('Protein', '${_currentProtein.toStringAsFixed(1)}g', AppTheme.proteinColor),
                        _buildMacroStat('Carbs', '${_currentCarbs.toStringAsFixed(1)}g', AppTheme.carbsColor),
                        _buildMacroStat('Fat', '${_currentFat.toStringAsFixed(1)}g', AppTheme.fatColor),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.textMuted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
