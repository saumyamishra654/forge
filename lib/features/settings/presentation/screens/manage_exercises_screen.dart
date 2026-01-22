import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column; // clash with Flutter Column
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import '../widgets/exercise_editor_dialog.dart';

class ManageExercisesScreen extends ConsumerStatefulWidget {
  const ManageExercisesScreen({super.key});

  @override
  ConsumerState<ManageExercisesScreen> createState() => _ManageExercisesScreenState();
}

class _ManageExercisesScreenState extends ConsumerState<ManageExercisesScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Manage Exercises'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditor(context),
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}), // Trigger rebuild for search
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textMuted),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () => setState(() {
                           _searchController.clear();
                        }),
                      )
                    : null,
                filled: true,
                fillColor: AppTheme.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          Expanded(
            child: StreamBuilder<List<Exercise>>(
              stream: (db.select(db.exercises)
                ..orderBy([(t) => OrderingTerm(expression: t.name)]))
                .watch(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allExercises = snapshot.data!;
                final query = _searchController.text.toLowerCase();
                
                final filtered = allExercises.where((e) {
                  return e.name.toLowerCase().contains(query);
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      'No exercises found',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textMuted,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  padding: const EdgeInsets.only(bottom: 80), // Fab space
                  itemBuilder: (context, index) {
                    final exercise = filtered[index];
                    return ListTile(
                      title: Text(exercise.name),
                      subtitle: Text(
                        '${exercise.category}${exercise.muscleGroup != null ? ' • ${exercise.muscleGroup}' : ''}',
                        style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: _getCategoryColor(exercise.category).withValues(alpha: 0.1),
                        child: Icon(
                          exercise.isCardio ? Icons.directions_run : Icons.fitness_center,
                          color: _getCategoryColor(exercise.category),
                          size: 20,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit_rounded, color: AppTheme.textMuted),
                        onPressed: () => _showEditor(context, exercise: exercise),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditor(BuildContext context, {Exercise? exercise}) {
    showDialog(
      context: context,
      builder: (_) => ExerciseEditorDialog(exercise: exercise),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Push': return AppTheme.exerciseColor;
      case 'Pull': return AppTheme.primary;
      case 'Legs': return AppTheme.success;
      case 'Cardio': return AppTheme.accent;
      default: return AppTheme.textSecondary;
    }
  }
}
