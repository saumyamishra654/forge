import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:drift/drift.dart' show Value;
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import '../widgets/exercise_picker.dart';
import '../widgets/set_logger.dart';

/// Active workout session state
class WorkoutSession {
  final DateTime startTime;
  final List<SessionExercise> exercises;
  int? manualCalories;

  WorkoutSession({
    required this.startTime,
    this.exercises = const [],
    this.manualCalories,
  });

  double get totalVolume => exercises.fold(0, (sum, e) => sum + e.volume);
  int get totalSets => exercises.fold(0, (sum, e) => sum + e.sets.length);
  int get exerciseCount => exercises.length;
  Duration get duration => DateTime.now().difference(startTime);
}

class SessionExercise {
  final Exercise exercise;
  final List<SetData> sets;

  SessionExercise({required this.exercise, required this.sets});

  double get volume => sets.fold(0, (sum, s) => sum + (s.weight * s.reps));
}

class WorkoutSessionScreen extends ConsumerStatefulWidget {
  const WorkoutSessionScreen({super.key});

  @override
  ConsumerState<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends ConsumerState<WorkoutSessionScreen> {
  late WorkoutSession _session;
  final _caloriesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _session = WorkoutSession(startTime: DateTime.now(), exercises: []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Workout'),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _confirmExit,
        ),
        actions: [
          if (_session.exercises.isNotEmpty)
            TextButton(
              onPressed: _finishWorkout,
              child: const Text('Finish', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: Column(
        children: [
          // Workout Stats Header
          _buildStatsHeader(),
          
          // Exercise List
          Expanded(
            child: _session.exercises.isEmpty
                ? _buildEmptyState()
                : _buildExerciseList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addExercise,
        backgroundColor: AppTheme.exerciseColor,
        icon: const Icon(Icons.add),
        label: const Text('Add Exercise'),
      ),
    );
  }

  Widget _buildStatsHeader() {
    final duration = _session.duration;
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.exerciseGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Timer and Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                '$minutes:${seconds.toString().padLeft(2, '0')}',
                'Duration',
                Icons.timer_outlined,
              ),
              _buildStatDivider(),
              _buildStatItem(
                '${_session.exerciseCount}',
                'Exercises',
                Icons.fitness_center_rounded,
              ),
              _buildStatDivider(),
              _buildStatItem(
                '${_session.totalSets}',
                'Sets',
                Icons.repeat_rounded,
              ),
              _buildStatDivider(),
              _buildStatItem(
                '${(_session.totalVolume / 1000).toStringAsFixed(1)}t',
                'Volume',
                Icons.monitor_weight_rounded,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Manual Calories Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _caloriesController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Manual calories',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                    prefixIcon: Icon(Icons.local_fire_department, color: Colors.white.withValues(alpha: 0.7)),
                    suffixText: 'kcal',
                    suffixStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.1),
                  ),
                  onChanged: (value) {
                    _session.manualCalories = int.tryParse(value);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withValues(alpha: 0.3),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center_rounded,
            size: 64,
            color: AppTheme.exerciseColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No exercises yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap "Add Exercise" to start your workout',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildExerciseList() {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _session.exercises.length,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) newIndex--;
          final item = _session.exercises.removeAt(oldIndex);
          _session.exercises.insert(newIndex, item);
        });
      },
      itemBuilder: (context, index) {
        return _buildExerciseCard(_session.exercises[index], index);
      },
    );
  }

  Widget _buildExerciseCard(SessionExercise exercise, int index) {
    return Card(
      key: ValueKey(exercise),
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.card,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.exerciseColor.withValues(alpha: 0.15),
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
                        exercise.exercise.name,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        '${exercise.sets.length} sets • ${(exercise.volume / 1000).toStringAsFixed(2)}t volume',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_rounded, size: 20),
                  onPressed: () => _editExercise(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete_rounded, size: 20, color: Colors.red.shade400),
                  onPressed: () => _removeExercise(index),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Set details
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: exercise.sets.asMap().entries.map((entry) {
                final setNum = entry.key + 1;
                final set = entry.value;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$setNum: ${set.weight}kg × ${set.reps}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 50 * index), duration: 300.ms);
  }

  void _addExercise() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddExerciseToSessionSheet(
        onAdd: (exercise, sets) {
          setState(() {
            _session.exercises.add(SessionExercise(exercise: exercise, sets: sets));
          });
        },
      ),
    );
  }

  void _editExercise(int index) {
    final current = _session.exercises[index];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddExerciseToSessionSheet(
        initialExercise: current.exercise,
        initialSets: current.sets,
        onAdd: (exercise, sets) {
          setState(() {
            _session.exercises[index] = SessionExercise(exercise: exercise, sets: sets);
          });
        },
      ),
    );
  }

  void _removeExercise(int index) {
    setState(() {
      _session.exercises.removeAt(index);
    });
  }

  void _confirmExit() {
    if (_session.exercises.isEmpty) {
      Navigator.pop(context);
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Discard Workout?'),
        content: const Text('Your workout progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Discard', style: TextStyle(color: Colors.red.shade400)),
          ),
        ],
      ),
    );
  }

  Future<void> _finishWorkout() async {
    if (_session.exercises.isEmpty) return;

    final db = ref.read(databaseProvider);

    // Save all exercises
    for (final sessionExercise in _session.exercises) {
      for (final set in sessionExercise.sets) {
        await db.into(db.exerciseLogs).insert(
          ExerciseLogsCompanion.insert(
            logDate: _session.startTime,
            exerciseId: sessionExercise.exercise.id,
            sets: Value(1),
            reps: Value(set.reps),
            weight: Value(set.weight),
          ),
        );
      }
    }

    if (mounted) {
      Navigator.pop(context, true); // Return true to indicate workout saved
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Workout saved! ${_session.exerciseCount} exercises, ${_session.totalSets} sets, ${(_session.totalVolume / 1000).toStringAsFixed(1)}t volume',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    super.dispose();
  }
}

/// Sheet for adding an exercise to the current session
class _AddExerciseToSessionSheet extends ConsumerStatefulWidget {
  final Exercise? initialExercise;
  final List<SetData>? initialSets;
  final Function(Exercise exercise, List<SetData> sets) onAdd;

  const _AddExerciseToSessionSheet({
    this.initialExercise,
    this.initialSets,
    required this.onAdd,
  });

  @override
  ConsumerState<_AddExerciseToSessionSheet> createState() => _AddExerciseToSessionSheetState();
}

class _AddExerciseToSessionSheetState extends ConsumerState<_AddExerciseToSessionSheet> {
  Exercise? _selectedExercise;
  List<SetData> _sets = [];
  double? _lastWeight;

  @override
  void initState() {
    super.initState();
    _selectedExercise = widget.initialExercise;
    _sets = widget.initialSets?.toList() ?? [];
  }

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
                  widget.initialExercise != null ? 'Edit Exercise' : 'Add Exercise',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),

          // Exercise Picker (only if not editing)
          if (widget.initialExercise == null)
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
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
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
                        color: AppTheme.exerciseColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.fitness_center_rounded, color: AppTheme.exerciseColor),
                    ),
                    const SizedBox(width: 12),
                    Text(widget.initialExercise!.name, style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
            ),

          // Last weight indicator
          if (_lastWeight != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
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
                initialSets: widget.initialSets,
                onSetsChanged: (sets) {
                  _sets = sets;
                },
              ),
            ),

          // Add Button
          if (_selectedExercise != null && _sets.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onAdd(_selectedExercise!, _sets);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.exerciseColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(widget.initialExercise != null ? 'Update Exercise' : 'Add to Workout'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
