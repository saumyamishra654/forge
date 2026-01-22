import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';

class ExerciseEditorDialog extends ConsumerStatefulWidget {
  final Exercise? exercise; // Null for new exercise

  const ExerciseEditorDialog({super.key, this.exercise});

  @override
  ConsumerState<ExerciseEditorDialog> createState() => _ExerciseEditorDialogState();
}

class _ExerciseEditorDialogState extends ConsumerState<ExerciseEditorDialog> {
  late TextEditingController _nameController;
  late String _selectedCategory;
  String? _selectedCardioType;
  List<String> _selectedMuscles = [];

  final List<String> _allMuscles = [
    'Chest', 'Back', 'Shoulders', 'Biceps', 'Triceps', 
    'Abs', 'Quads', 'Hamstrings', 'Glutes', 'Calves', 
    'Forearms', 'Full Body'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.exercise?.name ?? '');
    _selectedCategory = widget.exercise?.category ?? 'Push';
    _selectedCardioType = widget.exercise?.cardioType;
    
    if (widget.exercise?.muscleGroup != null && widget.exercise!.muscleGroup!.isNotEmpty) {
      _selectedMuscles = widget.exercise!.muscleGroup!.split(',');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) return;

    final db = ref.read(databaseProvider);
    final name = _nameController.text.trim();
    final isCardio = _selectedCategory == 'Cardio';
    final muscleGroup = _selectedMuscles.isEmpty ? null : _selectedMuscles.join(',');
    final cardioType = isCardio ? _selectedCardioType : null;

    if (widget.exercise == null) {
      // Create
      await db.into(db.exercises).insert(
        ExercisesCompanion.insert(
          name: name,
          category: _selectedCategory,
          muscleGroup: Value(muscleGroup),
          isCardio: Value(isCardio),
          cardioType: Value(cardioType),
        ),
      );
    } else {
      // Update
      await (db.update(db.exercises)..where((t) => t.id.equals(widget.exercise!.id))).write(
        ExercisesCompanion(
          name: Value(name),
          category: Value(_selectedCategory),
          muscleGroup: Value(muscleGroup),
          isCardio: Value(isCardio),
          cardioType: Value(cardioType),
        ),
      );
    }

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surface,
      title: Text(widget.exercise == null ? 'New Exercise' : 'Edit Exercise'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Exercise Name',
                hintText: 'e.g. Bench Press',
              ),
              autofocus: widget.exercise == null,
            ),
            const SizedBox(height: 16),
            
            // Category
            // Category
            InputDecorator(
              decoration: const InputDecoration(labelText: 'Category'),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isDense: true,
                  isExpanded: true,
                  items: ['Push', 'Pull', 'Legs', 'Cardio']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() {
                    _selectedCategory = v!;
                    if (v != 'Cardio') _selectedCardioType = null;
                  }),
                ),
              ),
            ),

            // Cardio Options
            if (_selectedCategory == 'Cardio') ...[
              const SizedBox(height: 16),
              Text('Cardio Type', style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 8),
              Row(
                children: ['LISS', 'HIIT'].map((type) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(type),
                    selected: _selectedCardioType == type,
                    onSelected: (sel) => setState(() => _selectedCardioType = sel ? type : null),
                    selectedColor: AppTheme.exerciseColor.withValues(alpha: 0.3),
                  ),
                )).toList(),
              ),
            ],

            // Muscle Groups
            const SizedBox(height: 16),
            Text('Muscle Groups', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _allMuscles.map((muscle) => FilterChip(
                label: Text(muscle, style: const TextStyle(fontSize: 12)),
                selected: _selectedMuscles.contains(muscle),
                onSelected: (sel) => setState(() {
                  if (sel) {
                    _selectedMuscles.add(muscle);
                  } else {
                    _selectedMuscles.remove(muscle);
                  }
                }),
                selectedColor: AppTheme.primary.withValues(alpha: 0.3),
                visualDensity: VisualDensity.compact,
              )).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
