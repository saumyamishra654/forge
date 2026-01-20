import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import '../widgets/edit_exercise_log_dialog.dart';

class ExerciseHistoryScreen extends ConsumerStatefulWidget {
  const ExerciseHistoryScreen({super.key});

  @override
  ConsumerState<ExerciseHistoryScreen> createState() => _ExerciseHistoryScreenState();
}

class _ExerciseHistoryScreenState extends ConsumerState<ExerciseHistoryScreen> {
  // Map of Date -> List of Log Entries
  Map<DateTime, List<ExerciseLogWithDetails>> _groupedLogs = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final db = ref.read(databaseProvider);
    
    // Join ExerciseLogs with Exercises to get names
    final query = db.select(db.exerciseLogs).join([
      drift.innerJoin(
        db.exercises,
        db.exercises.id.equalsExp(db.exerciseLogs.exerciseId),
      ),
    ]);
    
    // Order by date descending
    query.orderBy([drift.OrderingTerm(expression: db.exerciseLogs.logDate, mode: drift.OrderingMode.desc)]);

    final result = await query.get();
    
    final logs = result.map((row) {
      return ExerciseLogWithDetails(
        log: row.readTable(db.exerciseLogs),
        exercise: row.readTable(db.exercises),
      );
    }).toList();

    // Group by Date (ignoring seconds/milliseconds difference if they are slightly off, 
    // but usually they are exact from session save. 
    // To be safe, we can group by "Session ID" if we had one, but we use exact timestamp.
    // Let's assume exact timestamp for now as per WorkoutSessionScreen logic)
    final Map<DateTime, List<ExerciseLogWithDetails>> grouped = {};
    
    for (var log in logs) {
      // Find matching existing key (fuzzy match within 1 minute?)
      // Or just exact match since we save them in a loop with same timestamp variable.
      // Let's rely on exact match for this MVP.
      final date = log.log.logDate;
      grouped.update(date, (list) => list..add(log), ifAbsent: () => [log]);
    }

    if (mounted) {
      setState(() {
        _groupedLogs = grouped;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort keys descending
    final sortedDates = _groupedLogs.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Workout History'),
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : sortedDates.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sortedDates.length,
                  itemBuilder: (context, index) {
                    final date = sortedDates[index];
                    final logs = _groupedLogs[date]!;
                    return _buildSessionCard(date, logs);
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded, size: 64, color: AppTheme.textMuted.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            'No workouts yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(DateTime date, List<ExerciseLogWithDetails> logs) {
    // Calculate stats
    final uniqueExercises = logs.map((e) => e.exercise.id).toSet().length;
    final totalSets = logs.length;
    final totalVolume = logs.fold(0.0, (sum, e) {
      if (e.exercise.isCardio) return sum;
      return sum + ((e.log.weight ?? 0) * (e.log.reps ?? 0));
    });
    final totalDistance = logs.fold(0.0, (sum, e) => sum + (e.log.distanceKm ?? 0));
    final hasCardio = logs.any((e) => e.exercise.isCardio);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: InkWell(
        onTap: () => _showSessionDetails(date, logs),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('EEEE, MMM d, y').format(date),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat('h:mm a').format(date),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStatBadge(Icons.fitness_center_rounded, '$uniqueExercises Exercises'),
                  const SizedBox(width: 8),
                  _buildStatBadge(Icons.repeat_rounded, '$totalSets Sets'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (totalVolume > 0)
                    _buildStatBadge(
                      Icons.monitor_weight_rounded,
                      'Vol: ${(totalVolume / 1000).toStringAsFixed(1)}t',
                      color: AppTheme.primary,
                    ),
                  if (hasCardio && totalVolume > 0) const SizedBox(width: 8),
                  if (hasCardio)
                    _buildStatBadge(
                      Icons.straighten_rounded, 
                      'Dist: ${totalDistance.toStringAsFixed(1)}km',
                      color: AppTheme.exerciseColor,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, String text, {Color? color}) {
    final badgeColor = color ?? AppTheme.textMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: badgeColor, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _showSessionDetails(DateTime date, List<ExerciseLogWithDetails> logs) {
    // Group logs by exercise
    final groupedByExercise = <int, List<ExerciseLogWithDetails>>{};
    for (var log in logs) {
      groupedByExercise.update(log.exercise.id, (l) => l..add(log), ifAbsent: () => [log]);
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Session Details',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          DateFormat('EEEE, MMM d, h:mm a').format(date),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.all(24),
                  itemCount: groupedByExercise.length,
                  itemBuilder: (context, index) {
                    final exerciseId = groupedByExercise.keys.elementAt(index);
                    final exercises = groupedByExercise[exerciseId]!;
                    final first = exercises.first;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.exerciseColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.fitness_center_rounded, size: 16, color: AppTheme.exerciseColor),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  first.exercise.name,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_rounded, size: 18, color: Colors.red.shade400),
                                onPressed: () => _deleteExerciseGroup(context, exercises, date, logs),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...exercises.asMap().entries.map((entry) {
                            final i = entry.key;
                            final e = entry.value;
                            return InkWell(
                              onTap: () => _editLog(context, e),
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${i + 1}',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppTheme.textMuted,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: e.exercise.isCardio
                                          ? Text(
                                              '${e.log.durationMinutes ?? 0} mins • ${e.log.distanceKm ?? 0} km',
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            )
                                          : Text(
                                              '${e.log.weight}kg × ${e.log.reps}',
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            ),
                                    ),
                                    const Icon(Icons.edit_rounded, size: 14, color: AppTheme.textMuted),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteExerciseGroup(BuildContext sheetContext, List<ExerciseLogWithDetails> exercises, DateTime date, List<ExerciseLogWithDetails> allLogs) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Delete Exercise?'),
        content: Text('Delete all ${exercises.length} sets of ${exercises.first.exercise.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete', style: TextStyle(color: Colors.red.shade400)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final db = ref.read(databaseProvider);
      for (var e in exercises) {
        await db.exerciseLogs.deleteWhere((tbl) => tbl.id.equals(e.log.id));
      }
      
      if (mounted) {
        Navigator.pop(sheetContext); // Close sheet
        _loadHistory(); // Refresh
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted ${exercises.first.exercise.name}')),
        );
      }
    }
  }

  Future<void> _editLog(BuildContext context, ExerciseLogWithDetails details) async {
    final result = await showDialog(
      context: context,
      builder: (context) => EditExerciseLogDialog(
        log: details.log,
        exercise: details.exercise,
      ),
    );

    if (result != null) {
      final db = ref.read(databaseProvider);
      
      if (result == 'delete') {
        await db.exerciseLogs.deleteWhere((tbl) => tbl.id.equals(details.log.id));
      } else if (result is ExerciseLog) {
        await db.update(db.exerciseLogs).replace(result);
      }
      
      
      // Reload history and close sheet to refresh view
      if (!mounted) return;
      
      Navigator.pop(context); // Close sheet
      _loadHistory(); // Refresh list
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result == 'delete' ? 'Log deleted' : 'Log updated')),
      );
    }
  }
}

class ExerciseLogWithDetails {
  final ExerciseLog log;
  final Exercise exercise;

  ExerciseLogWithDetails({required this.log, required this.exercise});
}
