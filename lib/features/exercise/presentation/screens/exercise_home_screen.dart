import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:drift/drift.dart' show OrderingMode, OrderingTerm;
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import 'workout_session_screen.dart';
import 'exercise_history_screen.dart';

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
  double? _currentWeight;
  double? _weightChange;
  double? _currentBodyFat;
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
    
    // Fetch body stats (Weight & Body Fat)
    final weightLogs = await (db.select(db.weightLogs)
      ..orderBy([(t) => OrderingTerm(expression: t.logDate, mode: OrderingMode.desc)])
      ..limit(2))
      .get();
      
    final fatLogs = await (db.select(db.bodyFatLogs)
      ..orderBy([(t) => OrderingTerm(expression: t.logDate, mode: OrderingMode.desc)])
      ..limit(1))
      .get();
      
    double? currentWeight;
    double? weightDiff;
    double? currentFat;
    
    if (weightLogs.isNotEmpty) {
      currentWeight = weightLogs.first.weightKg;
      if (weightLogs.length > 1) {
        weightDiff = currentWeight - weightLogs[1].weightKg;
      }
    }
    
    if (fatLogs.isNotEmpty) {
      currentFat = fatLogs.first.bodyFatPercent;
    }

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
        
        // Track body part volume by muscle group (for the last 7 days)
        if (date.isAfter(weekAgo)) {
          // Parse comma-separated muscle groups
          final muscles = exercise.muscleGroup?.split(',') ?? [exercise.category];
          final perMuscleVol = exVolume / muscles.length; // Distribute volume evenly
          for (var muscle in muscles) {
            muscle = muscle.trim();
            if (muscle.isNotEmpty) {
              bodyPartVol[muscle] = (bodyPartVol[muscle] ?? 0) + perMuscleVol;
            }
          }
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
      _currentWeight = currentWeight;
      _weightChange = weightDiff;
      _currentBodyFat = currentFat;
      _isLoading = false;
    });
  }

  String _determineWorkoutType(Set<String> categories) {
    // Single category
    if (categories.length == 1) {
      final cat = categories.first;
      if (cat == 'Cardio') return 'Cardio';
      return cat; // Push, Pull, Legs, etc.
    }
    
    // Multi-category detection
    final hasPush = categories.contains('Push');
    final hasPull = categories.contains('Pull');
    final hasLegs = categories.contains('Legs');
    final hasCardio = categories.contains('Cardio');
    
    // Full Body: Push + Pull + Legs
    if (hasPush && hasPull && hasLegs) return 'Full Body';
    
    // Upper: Push + Pull (no Legs)
    if (hasPush && hasPull && !hasLegs) return 'Upper';
    
    // Push + Legs or Pull + Legs
    if ((hasPush || hasPull) && hasLegs) return 'Mixed';
    
    // Cardio only with one other
    if (hasCardio && categories.length == 2) {
      final other = categories.firstWhere((c) => c != 'Cardio');
      return '$other + Cardio';
    }
    
    // Fallback
    if (categories.length >= 3) return 'Full Body';
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
                    
                    // Body Stats
                    _buildBodyStats(),
                    if (_currentWeight != null || _currentBodyFat != null) const SizedBox(height: 24),
                    
                    // Weekly Stats
                    _buildWeeklyStats(),
                    const SizedBox(height: 24),
                    
                    // Past Workouts
                    _buildWorkoutHistory(),
                    const SizedBox(height: 24),
                    
                    // Body Part Volume
                    if (_bodyPartVolumes.isNotEmpty) ...[
                      _buildBodyPartVolume(),
                      const SizedBox(height: 24),
                    ],
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
        Row(
          children: [
            IconButton.filledTonal(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ExerciseHistoryScreen()),
              ),
              icon: const Icon(Icons.history_rounded),
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.surfaceLight,
                foregroundColor: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () => _showStartOptions(context),
              icon: const Icon(Icons.play_arrow_rounded, size: 20),
              label: const Text('Start'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.exerciseColor,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildBodyStats() {
    if (_currentWeight == null && _currentBodyFat == null) return const SizedBox.shrink();

    return Row(
      children: [
        if (_currentWeight != null) ...[
          Expanded(
            child: _buildBodyStatCard(
              'Weight',
              '${_currentWeight}kg',
              _weightChange == null ? null : '${_weightChange! > 0 ? '+' : ''}${_weightChange!.toStringAsFixed(1)}kg',
              Icons.monitor_weight_rounded,
              Colors.blue.shade400,
              isWeight: true,
            ),
          ),
          if (_currentBodyFat != null) const SizedBox(width: 12),
        ],
        if (_currentBodyFat != null)
          Expanded(
            child: _buildBodyStatCard(
              'Body Fat',
              '$_currentBodyFat%',
              null,
              Icons.percent_rounded,
              Colors.teal.shade400,
            ),
          ),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildBodyStatCard(String label, String value, String? subtitle, IconData icon, Color color, {bool isWeight = false}) {
    Color? subtitleColor;
    if (subtitle != null && isWeight) {
      subtitleColor = subtitle.startsWith('-') ? AppTheme.success : AppTheme.error;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: subtitleColor ?? AppTheme.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
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
              onPressed: () => _showStartOptions(context),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start Your First Workout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.exerciseColor,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  void _showStartOptions(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Start Workout',
              style: Theme.of(sheetContext).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(sheetContext);
                _startWorkout(parentContext, null);
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.exerciseColor,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(sheetContext);
                _pickDateForWorkout(parentContext);
              },
              icon: const Icon(Icons.calendar_month_rounded),
              label: const Text('Log Past Workout'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateForWorkout(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 1)),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context), // Use current theme
          child: child!,
        );
      }
    );
    
    if (picked != null && context.mounted) {
      _startWorkout(context, picked);
    }
  }

  void _startWorkout(BuildContext context, DateTime? date) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutSessionScreen(initialDate: date),
      ),
    );
    
    // Refresh data if workout was saved
    if (result == true) {
      _loadWorkoutData();
    }
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
