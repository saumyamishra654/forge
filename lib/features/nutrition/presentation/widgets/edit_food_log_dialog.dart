import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import 'package:drift/drift.dart' show Value;
import '../../providers/food_providers.dart';

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
  late String _selectedMealType;
  
  // Calculated macros
  double get _currentCalories => widget.food.calories * (double.tryParse(_servingsController.text) ?? 0);
  double get _currentProtein => widget.food.protein * (double.tryParse(_servingsController.text) ?? 0);
  double get _currentCarbs => widget.food.carbs * (double.tryParse(_servingsController.text) ?? 0);
  double get _currentFat => widget.food.fat * (double.tryParse(_servingsController.text) ?? 0);

  @override
  void initState() {
    super.initState();
    _servingsController = TextEditingController(text: widget.log.servings.toString());
    _selectedMealType = widget.log.mealType;
  }

  @override
  void dispose() {
    _servingsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final servings = double.tryParse(_servingsController.text);
    if (servings == null || servings <= 0) return;

    final db = ref.read(databaseProvider);
    
    // Update the log
    final updatedLog = widget.log.copyWith(
      servings: servings,
      mealType: _selectedMealType,
    );
    
    await db.update(db.foodLogs).replace(updatedLog);
    
    if (mounted) {
      Navigator.pop(context, true); // Return true to indicate refresh needed
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
      try {
        final foodRepo = ref.read(foodRepositoryProvider);
        await foodRepo.deleteLog(widget.log.id);
        
        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        debugPrint('Error deleting log: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Error deleting: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
            
            // Servings Input
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
            
            const SizedBox(height: 24),
            
            // Live Macro Update
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMacroStat('Calories', '${_currentCalories.toInt()}', Theme.of(context).textTheme.bodyLarge!.color!),
                  _buildMacroStat('Protein', '${_currentProtein.toStringAsFixed(1)}g', AppTheme.proteinColor),
                  _buildMacroStat('Carbs', '${_currentCarbs.toStringAsFixed(1)}g', AppTheme.carbsColor),
                  _buildMacroStat('Fat', '${_currentFat.toStringAsFixed(1)}g', AppTheme.fatColor),
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
