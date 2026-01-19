import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:drift/drift.dart' show Value;
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import '../widgets/exercise_picker.dart';
import '../widgets/set_logger.dart';

class ExerciseHomeScreen extends ConsumerStatefulWidget {
  const ExerciseHomeScreen({super.key});

  @override
  ConsumerState<ExerciseHomeScreen> createState() => _ExerciseHomeScreenState();
}

class _ExerciseHomeScreenState extends ConsumerState<ExerciseHomeScreen> {
  DateTime _selectedDate = DateTime.now();
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exercise',
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
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: AppTheme.exerciseGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.fitness_center_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ).animate().fadeIn(duration: 400.ms),
          ),
          
          // Today's Workout Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat(context, '0', 'Exercises'),
                  _buildDivider(),
                  _buildStat(context, '0', 'Sets'),
                  _buildDivider(),
                  _buildStat(context, '0 kg', 'Volume'),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
          ),
          
          const SizedBox(height: 20),
          
          // Exercise Log List
          Expanded(
            child: _buildExerciseList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppTheme.exerciseColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppTheme.surfaceLight,
    );
  }

  Widget _buildExerciseList() {
    return FutureBuilder<List<ExerciseLog>>(
      future: ref.read(databaseProvider).select(ref.read(databaseProvider).exerciseLogs).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }
        
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return _buildExerciseLogCard(snapshot.data![index]);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.exerciseColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.fitness_center_rounded,
              size: 48,
              color: AppTheme.exerciseColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No workouts logged',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to start logging your workout',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddExerciseSheet(context),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Exercise'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.exerciseColor,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildExerciseLogCard(ExerciseLog log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.exerciseColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.fitness_center_rounded,
              color: AppTheme.exerciseColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exercise ${log.exerciseId}', // Will be replaced with actual name
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  '${log.sets} sets × ${log.reps} reps @ ${log.weight}kg',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            '${(log.sets ?? 0) * (log.reps ?? 0) * (log.weight ?? 0)} kg',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppTheme.exerciseColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExerciseSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddExerciseSheet(),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
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
}

/// Bottom sheet for adding a new exercise
class AddExerciseSheet extends ConsumerStatefulWidget {
  const AddExerciseSheet({super.key});

  @override
  ConsumerState<AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends ConsumerState<AddExerciseSheet> {
  Exercise? _selectedExercise;
  final List<SetData> _sets = [];
  double? _lastWeight;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.textMuted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Exercise',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          
          // Exercise Picker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ExercisePicker(
              onExerciseSelected: (exercise, lastWeight) {
                setState(() {
                  _selectedExercise = exercise;
                  _lastWeight = lastWeight;
                });
              },
            ),
          ),
          
          // Last weight indicator
          if (_lastWeight != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.history_rounded, color: AppTheme.primary, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Last used: ${_lastWeight}kg',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 300.ms),
          
          const SizedBox(height: 12),
          
          // Set Logger
          if (_selectedExercise != null)
            Expanded(
              child: SetLogger(
                exercise: _selectedExercise!,
                initialWeight: _lastWeight,
                onSetsChanged: (sets) {
                  setState(() => _sets.clear());
                  _sets.addAll(sets);
                },
              ),
            ),
          
          // Save Button
          if (_selectedExercise != null && _sets.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveExercise,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.exerciseColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Save Exercise'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _saveExercise() async {
    if (_selectedExercise == null || _sets.isEmpty) return;
    
    final db = ref.read(databaseProvider);
    
    for (final set in _sets) {
      await db.into(db.exerciseLogs).insert(
        ExerciseLogsCompanion.insert(
          logDate: DateTime.now(),
          exerciseId: _selectedExercise!.id,
          sets: Value(1),
          reps: Value(set.reps),
          weight: Value(set.weight),
        ),
      );
    }
    
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exercise logged successfully!')),
      );
    }
  }
}
