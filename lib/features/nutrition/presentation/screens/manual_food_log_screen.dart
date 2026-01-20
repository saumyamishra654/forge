import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../core/theme/app_theme.dart';
import '../../../../main.dart';
import '../../../../core/database/database.dart';

class ManualFoodLogScreen extends ConsumerStatefulWidget {
  const ManualFoodLogScreen({super.key});

  @override
  ConsumerState<ManualFoodLogScreen> createState() => _ManualFoodLogScreenState();
}

class _ManualFoodLogScreenState extends ConsumerState<ManualFoodLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _costController = TextEditingController();
  
  String _selectedMealType = 'Snack';
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _saveLog() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final db = ref.read(databaseProvider);
      final now = DateTime.now();

      // 1. Create the Food entry
      final foodId = await db.into(db.foods).insert(
        FoodsCompanion.insert(
          name: _nameController.text.trim().isEmpty 
              ? 'Quick Entry' 
              : _nameController.text.trim(),
          calories: double.parse(_caloriesController.text),
          protein: double.tryParse(_proteinController.text) ?? 0,
          carbs: double.tryParse(_carbsController.text) ?? 0,
          fat: double.tryParse(_fatController.text) ?? 0,
          source: const drift.Value('manual'),
          servingSize: const drift.Value(1), // Logical serving
          servingUnit: const drift.Value('serving'),
        ),
      );

      // 2. Create the Log entry
      await db.into(db.foodLogs).insert(
        FoodLogsCompanion.insert(
          logDate: now,
          foodId: foodId,
          mealType: _selectedMealType,
          servings: const drift.Value(1),
        ),
      );

      // 3. Create Expense (Optional)
      final cost = double.tryParse(_costController.text);
      if (cost != null && cost > 0) {
        // Find or create 'Food' category
        // Ideally we should have seeded categories. For now, we'll try to find 'Food' or 'Groceries' or create one.
        // Or simpler: Just pick the first category or look for one with 'food' in name.
        
        final categories = await db.select(db.expenseCategories).get();
        int categoryId;
        
        // Simple search for food-related category
        final foodCat = categories.cast<ExpenseCategory?>().firstWhere(
          (c) => c!.name.toLowerCase().contains('food') || c.name.toLowerCase().contains('grocer'), 
          orElse: () => null
        );
        
        if (foodCat != null) {
          categoryId = foodCat.id;
        } else if (categories.isNotEmpty) {
          categoryId = categories.first.id; // Fallback to first available
        } else {
          // If no categories exist, create a default 'Food' category
           categoryId = await db.into(db.expenseCategories).insert(
            ExpenseCategoriesCompanion.insert(
              name: 'Food',
              icon: '🍔',
              color: const drift.Value('0xFFEF5350'), // Red-400
              isFoodRelated: const drift.Value(true),
            )
          );
        }

        await db.into(db.expenses).insert(
          ExpensesCompanion.insert(
            logDate: now,
            categoryId: categoryId,
            amount: cost,
            description: drift.Value('Food: ${_nameController.text.trim().isEmpty ? "Quick Entry" : _nameController.text.trim()}'),
          )
        );
      }

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Food logged successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving log: $e'), backgroundColor: AppTheme.error),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Log'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meal Type Selector
              Text('MEAL', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ['Breakfast', 'Lunch', 'Dinner', 'Snack'].map((type) {
                    final isSelected = _selectedMealType == type;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedMealType = type);
                        },
                        selectedColor: AppTheme.nutritionColor.withValues(alpha: 0.2),
                        labelStyle: TextStyle(
                          color: isSelected ? AppTheme.nutritionColor : AppTheme.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color: isSelected ? AppTheme.nutritionColor : AppTheme.surfaceLight,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Name Field
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Food Name (Optional)',
                  hintText: 'e.g., Apple, Sandwich',
                  prefixIcon: Icon(Icons.edit_rounded, size: 20),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Calories (Primary)
              TextFormField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: 'Calories',
                  suffixText: 'kcal',
                  prefixIcon: Icon(Icons.local_fire_department_rounded, size: 20),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              Text('MACROS (Optional)', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: _buildMacroField(
                      controller: _proteinController,
                      label: 'Protein',
                      color: AppTheme.proteinColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMacroField(
                      controller: _carbsController,
                      label: 'Carbs',
                      color: AppTheme.carbsColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMacroField(
                      controller: _fatController,
                      label: 'Fat',
                      color: AppTheme.fatColor,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Cost Field (Optional)
              Text('FINANCE (Optional)', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 12),
              TextFormField(
                controller: _costController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Cost',
                  prefixText: '₹ ',
                  prefixIcon: Icon(Icons.currency_rupee_rounded, size: 20),
                ),
              ),

              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveLog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.nutritionColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSaving 
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                      )
                    : const Text('Log Food'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroField({
    required TextEditingController controller,
    required String label,
    required Color color,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        suffixText: 'g',
        prefixIcon: Container(
          margin: const EdgeInsets.all(10),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}
