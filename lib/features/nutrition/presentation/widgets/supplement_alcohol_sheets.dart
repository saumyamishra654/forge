import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';

/// Supplement logging bottom sheet
class SupplementLogSheet extends ConsumerStatefulWidget {
  const SupplementLogSheet({super.key});

  @override
  ConsumerState<SupplementLogSheet> createState() => _SupplementLogSheetState();
}

class _SupplementLogSheetState extends ConsumerState<SupplementLogSheet> {
  List<Supplement> _supplements = [];
  Supplement? _selectedSupplement;
  final _dosageController = TextEditingController(text: '1');
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSupplements();
  }

  Future<void> _loadSupplements() async {
    final db = ref.read(databaseProvider);
    final supplements = await db.select(db.supplements).get();
    setState(() {
      _supplements = supplements;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            Text(
              'Log Supplement',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              // Supplement Selection
              Text('Select Supplement', style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: _supplements.length,
                  itemBuilder: (context, index) {
                    final supp = _supplements[index];
                    final isSelected = _selectedSupplement?.id == supp.id;
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.medication_rounded, color: Colors.purple, size: 20),
                      ),
                      title: Text(supp.name),
                      subtitle: Text(supp.dosageUnit),
                      selected: isSelected,
                      selectedTileColor: AppTheme.primary.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      onTap: () {
                        setState(() {
                          _selectedSupplement = supp;
                        });
                      },
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Dosage
              if (_selectedSupplement != null) ...[
                Text('Dosage', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _dosageController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _selectedSupplement!.dosageUnit,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _logSupplement,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Log Supplement'),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _logSupplement() async {
    if (_selectedSupplement == null) return;
    
    final dosage = double.tryParse(_dosageController.text) ?? 1;
    
    final db = ref.read(databaseProvider);
    await db.into(db.supplementLogs).insert(
      SupplementLogsCompanion.insert(
        logDate: DateTime.now(),
        supplementId: _selectedSupplement!.id,
        dosage: dosage,
      ),
    );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_selectedSupplement!.name} logged!')),
      );
    }
  }

  @override
  void dispose() {
    _dosageController.dispose();
    super.dispose();
  }
}

/// Alcohol logging bottom sheet
class AlcoholLogSheet extends ConsumerStatefulWidget {
  const AlcoholLogSheet({super.key});

  @override
  ConsumerState<AlcoholLogSheet> createState() => _AlcoholLogSheetState();
}

class _AlcoholLogSheetState extends ConsumerState<AlcoholLogSheet> {
  String _selectedType = 'beer';
  final _unitsController = TextEditingController(text: '1');
  final _volumeController = TextEditingController(text: '330');
  
  // (type, label, emoji, kcal/100ml, default ml, protein/100ml, carbs/100ml, fat/100ml)
  final _drinkTypes = [
    ('beer', 'Beer', 43.0, 330.0, 0.5, 3.6, 0.0),      // Beer has carbs!
    ('wine', 'Wine', 83.0, 150.0, 0.1, 2.6, 0.0),      // Wine has some carbs
    ('whiskey', 'Whiskey', 250.0, 30.0, 0.0, 0.0, 0.0), // Spirits = no macros
    ('vodka', 'Vodka', 231.0, 30.0, 0.0, 0.0, 0.0),
    ('cocktail', 'Cocktail', 150.0, 200.0, 0.0, 15.0, 0.0), // Cocktails often have sugar
    ('other', 'Other', 100.0, 100.0, 0.0, 5.0, 0.0),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedDrink = _drinkTypes.firstWhere((d) => d.$1 == _selectedType);
    final units = double.tryParse(_unitsController.text) ?? 1;
    final volume = double.tryParse(_volumeController.text) ?? selectedDrink.$4;
    final calories = (selectedDrink.$3 * volume / 100 * units).round();
    final carbs = (selectedDrink.$6 * volume / 100 * units);
    
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            Text(
              'Log Alcohol',
              style: Theme.of(context).textTheme.headlineSmall,
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
                      _volumeController.text = drink.$4.toInt().toString();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Colors.amber.withValues(alpha: 0.2)
                          : AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected 
                          ? Border.all(color: Colors.amber)
                          : null,
                    ),
                    child: Text(
                      drink.$2,
                      style: TextStyle(
                        color: isSelected ? Colors.amber : AppTheme.textSecondary,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Drinks', style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _unitsController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Volume (ml)', style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _volumeController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
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
                        '$calories',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.amber),
                      ),
                      Text('kcal', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '${carbs.toStringAsFixed(1)}g',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.carbsColor),
                      ),
                      Text('carbs', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _logAlcohol,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Log Drink'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logAlcohol() async {
    final selectedDrink = _drinkTypes.firstWhere((d) => d.$1 == _selectedType);
    final units = double.tryParse(_unitsController.text) ?? 1;
    final volume = double.tryParse(_volumeController.text) ?? selectedDrink.$4;
    final ratio = volume / 100 * units;
    
    final calories = selectedDrink.$3 * ratio;
    final protein = selectedDrink.$5 * ratio;
    final carbs = selectedDrink.$6 * ratio;
    final fat = selectedDrink.$7 * ratio;
    
    final db = ref.read(databaseProvider);
    await db.into(db.alcoholLogs).insert(
      AlcoholLogsCompanion.insert(
        logDate: DateTime.now(),
        drinkType: _selectedType,
        units: units,
        calories: calories,
        volumeMl: Value(volume),
        protein: Value(protein),
        carbs: Value(carbs),
        fat: Value(fat),
      ),
    );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${selectedDrink.$2} logged (+${calories.toInt()} kcal, ${carbs.toStringAsFixed(1)}g carbs)')),
      );
    }
  }

  @override
  void dispose() {
    _unitsController.dispose();
    _volumeController.dispose();
    super.dispose();
  }
}
