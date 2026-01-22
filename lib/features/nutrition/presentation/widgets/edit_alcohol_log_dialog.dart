import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';

class EditAlcoholLogDialog extends ConsumerStatefulWidget {
  final AlcoholLog log;

  const EditAlcoholLogDialog({
    super.key,
    required this.log,
  });

  @override
  ConsumerState<EditAlcoholLogDialog> createState() => _EditAlcoholLogDialogState();
}

class _EditAlcoholLogDialogState extends ConsumerState<EditAlcoholLogDialog> {
  late String _selectedType;
  late TextEditingController _unitsController;
  late TextEditingController _volumeController;
  
  // (type, label, kcal/100ml, default ml, protein/100ml, carbs/100ml, fat/100ml)
  final _drinkTypes = [
    ('beer', 'Beer', 43.0, 330.0, 0.5, 3.6, 0.0),
    ('wine', 'Wine', 83.0, 150.0, 0.1, 2.6, 0.0),
    ('whiskey', 'Whiskey', 250.0, 30.0, 0.0, 0.0, 0.0),
    ('vodka', 'Vodka', 231.0, 30.0, 0.0, 0.0, 0.0),
    ('cocktail', 'Cocktail', 150.0, 200.0, 0.0, 15.0, 0.0),
    ('other', 'Other', 100.0, 100.0, 0.0, 5.0, 0.0),
  ];

  double get _ratio {
    final selectedDrink = _drinkTypes.firstWhere((d) => d.$1 == _selectedType);
    final units = double.tryParse(_unitsController.text) ?? 1;
    final volume = double.tryParse(_volumeController.text) ?? selectedDrink.$4;
    return volume / 100 * units;
  }
  
  double get _calories {
    final selectedDrink = _drinkTypes.firstWhere((d) => d.$1 == _selectedType);
    return selectedDrink.$3 * _ratio;
  }
  
  double get _carbs {
    final selectedDrink = _drinkTypes.firstWhere((d) => d.$1 == _selectedType);
    return selectedDrink.$6 * _ratio;
  }

  @override
  void initState() {
    super.initState();
    _selectedType = widget.log.drinkType;
    _unitsController = TextEditingController(text: widget.log.units.toString());
    _volumeController = TextEditingController(text: (widget.log.volumeMl ?? 100).toInt().toString());
  }

  @override
  void dispose() {
    _unitsController.dispose();
    _volumeController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    final selectedDrink = _drinkTypes.firstWhere((d) => d.$1 == _selectedType);
    final protein = selectedDrink.$5 * _ratio;
    final fat = selectedDrink.$7 * _ratio;
    
    await (db.update(db.alcoholLogs)..where((a) => a.id.equals(widget.log.id))).write(
      AlcoholLogsCompanion(
        drinkType: Value(_selectedType),
        units: Value(double.tryParse(_unitsController.text) ?? 1),
        volumeMl: Value(double.tryParse(_volumeController.text)),
        calories: Value(_calories),
        protein: Value(protein),
        carbs: Value(_carbs),
        fat: Value(fat),
      ),
    );
    
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
        content: const Text('Remove this alcohol entry?'),
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
      await (db.delete(db.alcoholLogs)..where((a) => a.id.equals(widget.log.id))).go();
      
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
                      'Edit Alcohol',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    onPressed: _delete,
                    icon: Icon(Icons.delete_outline_rounded, color: Colors.red.shade400),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Drink Type Selection
              Text('Type', style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _drinkTypes.map((drink) {
                  final isSelected = _selectedType == drink.$1;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedType = drink.$1;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? Colors.amber.withValues(alpha: 0.2)
                            : AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected 
                            ? Border.all(color: Colors.amber)
                            : null,
                      ),
                      child: Text(
                        drink.$2,
                        style: TextStyle(
                          color: isSelected ? Colors.amber : AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 20),
              
              // Quantity and Volume
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _unitsController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Drinks'),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _volumeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Volume (ml)'),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Calorie + Carbs Display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${_calories.toInt()}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.amber),
                        ),
                        Text('kcal', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${_carbs.toStringAsFixed(1)}g',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.carbsColor),
                        ),
                        Text('carbs', style: Theme.of(context).textTheme.bodySmall),
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
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
