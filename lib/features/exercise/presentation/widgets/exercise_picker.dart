import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show OrderingTerm, Value;
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';

class ExercisePicker extends ConsumerStatefulWidget {
  final Function(Exercise exercise, double? lastWeight) onExerciseSelected;
  
  const ExercisePicker({super.key, required this.onExerciseSelected});

  @override
  ConsumerState<ExercisePicker> createState() => _ExercisePickerState();
}

class _ExercisePickerState extends ConsumerState<ExercisePicker> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<Exercise> _allExercises = [];
  List<Exercise> _filteredExercises = [];
  
  final List<String> _categories = ['All', 'Push', 'Pull', 'Legs', 'Cardio'];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final db = ref.read(databaseProvider);
    final exercises = await db.select(db.exercises).get();
    setState(() {
      _allExercises = exercises;
      _filteredExercises = exercises;
    });
  }

  void _filterExercises() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredExercises = _allExercises.where((exercise) {
        final matchesSearch = exercise.name.toLowerCase().contains(query);
        final matchesCategory = _selectedCategory == 'All' || 
            exercise.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  Future<double?> _getLastWeight(int exerciseId) async {
    final db = ref.read(databaseProvider);
    final logs = await (db.select(db.exerciseLogs)
      ..where((t) => t.exerciseId.equals(exerciseId))
      ..orderBy([(t) => OrderingTerm.desc(t.logDate)])
      ..limit(1))
      .get();
    
    if (logs.isNotEmpty && logs.first.weight != null) {
      return logs.first.weight;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Field
        TextField(
          controller: _searchController,
          onChanged: (_) => _filterExercises(),
          decoration: InputDecoration(
            hintText: 'Search exercises...',
            prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textMuted),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      _searchController.clear();
                      _filterExercises();
                    },
                  )
                : null,
          ),
        ),
        
        const SizedBox(height: 16),

        // Create Custom Exercise Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _showCreateExerciseDialog,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create Custom Exercise'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primary,
              side: const BorderSide(color: AppTheme.primary),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Category Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _selectedCategory = category);
                    _filterExercises();
                  },
                  backgroundColor: AppTheme.surfaceLight,
                  selectedColor: AppTheme.primary.withValues(alpha: 0.3),
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  side: BorderSide.none,
                ),
              );
            }).toList(),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Exercise List
        SizedBox(
          height: 250,
          child: _filteredExercises.isEmpty && _searchController.text.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No exercises found'),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _showCreateExerciseDialog,
                        child: const Text('Create New Exercise'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = _filteredExercises[index];
                    return _buildExerciseTile(exercise);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildExerciseTile(Exercise exercise) {
    final isCardio = exercise.isCardio;
    final icon = isCardio ? Icons.directions_run_rounded : Icons.fitness_center_rounded;
    final color = _getCategoryColor(exercise.category);
    
    return ListTile(
      onTap: () async {
        final lastWeight = await _getLastWeight(exercise.id);
        widget.onExerciseSelected(exercise, lastWeight);
      },
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        exercise.name,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subtitle: Text(
        '${exercise.category}${exercise.muscleGroup != null ? ' • ${exercise.muscleGroup}' : ''}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted),
    );
  }

  Future<void> _showCreateExerciseDialog() async {
    final nameController = TextEditingController(text: _searchController.text);
    String selectedCategory = 'Push';
    String? selectedCardioType;
    List<String> selectedMuscles = [];
    
    const allMuscles = ['Chest', 'Back', 'Shoulders', 'Biceps', 'Triceps', 'Abs', 'Quads', 'Hamstrings', 'Glutes', 'Calves', 'Forearms', 'Full Body'];

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppTheme.surface,
          title: const Text('Create Custom Exercise'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Exercise Name',
                    hintText: 'e.g. Diamond Pushups',
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: ['Push', 'Pull', 'Legs', 'Cardio']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() {
                    selectedCategory = v!;
                    if (v != 'Cardio') selectedCardioType = null;
                  }),
                ),
                
                // LISS/HIIT for Cardio
                if (selectedCategory == 'Cardio') ...[
                  const SizedBox(height: 16),
                  Text('Cardio Type', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: ['LISS', 'HIIT'].map((type) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(type),
                        selected: selectedCardioType == type,
                        onSelected: (sel) => setState(() => selectedCardioType = sel ? type : null),
                        selectedColor: AppTheme.exerciseColor.withValues(alpha: 0.3),
                      ),
                    )).toList(),
                  ),
                ],
                
                // Muscle Groups (multi-select)
                const SizedBox(height: 16),
                Text('Muscle Groups', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: allMuscles.map((muscle) => FilterChip(
                    label: Text(muscle, style: const TextStyle(fontSize: 12)),
                    selected: selectedMuscles.contains(muscle),
                    onSelected: (sel) => setState(() {
                      if (sel) {
                        selectedMuscles.add(muscle);
                      } else {
                        selectedMuscles.remove(muscle);
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
              onPressed: () async {
                if (nameController.text.trim().isEmpty) return;

                final db = ref.read(databaseProvider);
                await db.into(db.exercises).insert(
                  ExercisesCompanion.insert(
                    name: nameController.text.trim(),
                    category: selectedCategory,
                    muscleGroup: Value(selectedMuscles.isEmpty ? null : selectedMuscles.join(',')),
                    isCardio: Value(selectedCategory == 'Cardio'),
                    cardioType: Value(selectedCardioType),
                  ),
                );
                
                if (mounted) {
                  Navigator.pop(context);
                  _searchController.clear();
                  _loadExercises(); // Refresh list
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Push':
        return AppTheme.exerciseColor;
      case 'Pull':
        return AppTheme.primary;
      case 'Legs':
        return AppTheme.success;
      case 'Cardio':
        return AppTheme.accent;
      default:
        return AppTheme.textSecondary;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
