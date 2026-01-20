import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../../../core/sync/base_repository.dart';

class ExerciseRepository extends BaseRepository {
  ExerciseRepository(super.db);

  /// Log a single set
  Future<int> logSet(ExerciseLogsCompanion log) {
    return performWithSync(
      action: 'create',
      table: 'exercise_logs',
      performWrite: () => db.into(db.exerciseLogs).insert(log),
    );
  }

  /// Delete a log
  Future<void> deleteLog(int id) {
    return performWithSync(
      action: 'delete',
      table: 'exercise_logs',
      performWrite: () async {
        // Mark as deleted instead of hard delete for sync safety
        await (db.update(db.exerciseLogs)..where((t) => t.id.equals(id))).write(
          const ExerciseLogsCompanion(isDeleted: Value(true)),
        );
        return id;
      },
    );
  }
  
  // Add other methods (update, etc.) as needed
}
