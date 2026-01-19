import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:drift/drift.dart' show Value;
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import '../widgets/exercise_picker.dart';
import '../widgets/set_logger.dart';

/// Data class for a workout day
class WorkoutDay {
  final DateTime date;
  final List<WorkoutExercise> exercises;
  final double totalVolume;
  final int totalSets;
  final String workoutType; // Push, Pull, Legs, Full Body, etc.

  WorkoutDay({
    required this.date,
    required this.exercises,
    required this.totalVolume,
    required this.totalSets,
    required this.workoutType,
  });
}

class WorkoutExercise {
  final Exercise exercise;
  final List<ExerciseLog> logs;
  final double volume;

  WorkoutExercise({required this.exercise, required this.logs, required this.volume});
}

/// Body part volume data
class BodyPartVolume {
  final String bodyPart;
  final double volume;
  final Color color;

  BodyPartVolume({required this.bodyPart, required this.volume, required this.color});
}

class ExerciseHomeScreen extends ConsumerStatefulWidget {
  const ExerciseHomeScreen({super.key});

  @override
  ConsumerState<ExerciseHomeScreen> createState() => _ExerciseHomeScreenState();
}

class _ExerciseHomeScreenState extends ConsumerState<ExerciseHomeScreen> {
  List<WorkoutDay> _workoutHistory = [];
  Map<String, double> _bodyPartVolumes = {};
  double _weeklyVolume = 0;
  int _weeklyWorkouts = 0;
  int _weeklySets = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkoutData();
  }

  Future<void> _loadWorkoutData() async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    
    // Fetch all exercise logs
    final logs = await db.select(db.exerciseLogs).get();
    final exercises = await db.select(db.exercises).get();
    final exerciseMap = {for (var e in exercises) e.id: e};
    
    // Group logs by date
    final Map<String, List<ExerciseLog>> logsByDate = {};
    for (final log in logs) {
      final dateKey = '${log.logDate.year}-${log.logDate.month}-${log.logDate.day}';
      logsByDate.putIfAbsent(dateKey, () => []).add(log);
    }
    
    // Build workout days
    final List<WorkoutDay> workouts = [];
    final Map<String, double> bodyPartVol = {};
    double weekVol = 0;
    int weekSets = 0;
    
    for (final entry in logsByDate.entries) {
      final dayLogs = entry.value;
      if (dayLogs.isEmpty) continue;
      
      final date = dayLogs.first.logDate;
      
      // Group by exercise
      final Map<int, List<ExerciseLog>> byExercise = {};
      for (final log in dayLogs) {
        byExercise.putIfAbsent(log.exerciseId, () => []).add(log);
      }
      
      // Build exercise list
      final List<WorkoutExercise> dayExercises = [];
      double dayVolume = 0;
      int daySets = 0;
      final Set<String> categories = {};
      
      for (final exEntry in byExercise.entries) {
        final exercise = exerciseMap[exEntry.key];
        if (exercise == null) continue;
        
        categories.add(exercise.category);
        double exVolume = 0;
        for (final log in exEntry.value) {
          final vol = (log.sets ?? 1) * (log.reps ?? 0) * (log.weight ?? 0);
          exVolume += vol;
          daySets += log.sets ?? 1;
        }
        
        dayVolume += exVolume;
        dayExercises.add(WorkoutExercise(
          exercise: exercise,
          logs: exEntry.value,
          volume: exVolume,
        ));
        
        // Track body part volume (for the last 7 days)
        if (date.isAfter(weekAgo)) {
          final category = exercise.category;
          bodyPartVol[category] = (bodyPartVol[category] ?? 0) + exVolume;
        }
      }
      
      // Determine workout type from categories
      final workoutType = _determineWorkoutType(categories);
      
      workouts.add(WorkoutDay(
        date: date,
        exercises: dayExercises,
        totalVolume: dayVolume,
        totalSets: daySets,
        workoutType: workoutType,
      ));
      
      // Weekly stats
      if (date.isAfter(weekAgo)) {
        weekVol += dayVolume;
        weekSets += daySets;
      }
    }
    
    // Sort by date descending
    workouts.sort((a, b) => b.date.compareTo(a.date));
    
    setState(() {
      _workoutHistory = workouts;
      _bodyPartVolumes = bodyPartVol;
      _weeklyVolume = weekVol;
      _weeklyWorkouts = workouts.where((w) => w.date.isAfter(weekAgo)).length;
      _weeklySets = weekSets;
      _isLoading = false;
    });
  }

  String _determineWorkoutType(Set<String> categories) {
    if (categories.length == 1) {
      switch (categories.first) {
        case 'Chest':
        case 'Shoulders':
        case 'Arms':
          if (categories.contains('Chest')) return 'Push';
          return categories.first;
        case 'Back':
          return 'Pull';
        case 'Legs':
          return 'Legs';
        case 'Core':
          return 'Core';
        case 'Cardio':
          return 'Cardio';
        default:
          return categories.first;
      }
    }
    
    // Multi-category detection
    if (categories.containsAll(['Chest', 'Shoulders'])) return 'Push';
    if (categories.containsAll(['Back', 'Arms']) && !categories.contains('Chest')) return 'Pull';
    if (categories.length >= 4) return 'Full Body';
    if (categories.contains('Cardio') && categories.length == 1) return 'Cardio';
    
    return 'Mixed';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadWorkoutData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _buildHeader(),
                    const SizedBox(height: 24),
                    
                    // Weekly Stats
                    _buildWeeklyStats(),
                    const SizedBox(height: 24),
                    
                    // Body Part Volume
                    if (_bodyPartVolumes.isNotEmpty) ...[
                      _buildBodyPartVolume(),
                      const SizedBox(height: 24),
                    ],
                    
                    // Past Workouts
                    _buildWorkoutHistory(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workouts',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Last 7 days',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showAddExerciseSheet(context),
          icon: const Icon(Icons.add, size: 20),
          label: const Text('Log Workout'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.exerciseColor,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildWeeklyStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.exerciseGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('$_weeklyWorkouts', 'Workouts', Icons.calendar_today_rounded),
              _buildStatDivider(),
              _buildStatItem('$_weeklySets', 'Sets', Icons.repeat_rounded),
              _buildStatDivider(),
              _buildStatItem('${(_weeklyVolume / 1000).toStringAsFixed(1)}t', 'Volume', Icons.fitness_center_rounded),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 60,
      color: Colors.white.withValues(alpha: 0.3),
    );
  }

  Widget _buildBodyPartVolume() {
    final bodyPartColors = {
      'Chest': Colors.red.shade400,
      'Back': Colors.blue.shade400,
      'Legs': Colors.green.shade400,
      'Shoulders': Colors.orange.shade400,
      'Arms': Colors.purple.shade400,
      'Core': Colors.teal.shade400,
      'Cardio': Colors.pink.shade400,
    };

    final sortedParts = _bodyPartVolumes.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Volume by Body Part',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: sortedParts.map((entry) {
              final maxVol = sortedParts.first.value;
              final percent = maxVol > 0 ? entry.value / maxVol : 0.0;
              final color = bodyPartColors[entry.key] ?? AppTheme.primary;
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        entry.key,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: percent,
                            child: Container(
                              height: 20,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 60,
                      child: Text(
                        '${(entry.value / 1000).toStringAsFixed(1)}t',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 150.ms, duration: 400.ms);
  }

  Widget _buildWorkoutHistory() {
    if (_workoutHistory.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Workout History',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        ...List.generate(_workoutHistory.length, (index) {
          return _buildWorkoutDayCard(_workoutHistory[index])
              .animate()
              .fadeIn(delay: Duration(milliseconds: 200 + index * 50), duration: 400.ms);
        }),
      ],
    );
  }

  Widget _buildWorkoutDayCard(WorkoutDay workout) {
    final typeColor = _getWorkoutTypeColor(workout.workoutType);
    final dateStr = _formatDate(workout.date);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: typeColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getWorkoutTypeIcon(workout.workoutType),
            color: typeColor,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.workoutType,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    dateStr,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${(workout.totalVolume / 1000).toStringAsFixed(1)}t',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: typeColor,
                  ),
                ),
                Text(
                  '${workout.totalSets} sets',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        children: workout.exercises.map((we) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: typeColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        we.exercise.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '${we.logs.length} sets • ${(we.volume / 1000).toStringAsFixed(2)}t volume',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getWorkoutTypeColor(String type) {
    switch (type) {
      case 'Push': return Colors.red.shade400;
      case 'Pull': return Colors.blue.shade400;
      case 'Legs': return Colors.green.shade400;
      case 'Full Body': return Colors.purple.shade400;
      case 'Cardio': return Colors.orange.shade400;
      case 'Core': return Colors.teal.shade400;
      default: return AppTheme.exerciseColor;
    }
  }

  IconData _getWorkoutTypeIcon(String type) {
    switch (type) {
      case 'Push': return Icons.arrow_upward_rounded;
      case 'Pull': return Icons.arrow_downward_rounded;
      case 'Legs': return Icons.directions_walk_rounded;
      case 'Full Body': return Icons.accessibility_new_rounded;
      case 'Cardio': return Icons.directions_run_rounded;
      case 'Core': return Icons.center_focus_strong_rounded;
      default: return Icons.fitness_center_rounded;
    }
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.exerciseColor.withValues(alpha: 0.1),
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
              'No workouts logged yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Start tracking your workouts to see stats',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showAddExerciseSheet(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Log Your First Workout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.exerciseColor,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  void _showAddExerciseSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddExerciseSheet(
        onSaved: () {
          _loadWorkoutData();
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    final diff = today.difference(dateOnly).inDays;
    
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '$diff days ago';
    
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }
}

/// Bottom sheet for adding a new exercise
class AddExerciseSheet extends ConsumerStatefulWidget {
  final VoidCallback? onSaved;
  
  const AddExerciseSheet({super.key, this.onSaved});

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
                  'Log Exercise',
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
    
    widget.onSaved?.call();
    
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exercise logged successfully!')),
      );
    }
  }
}
