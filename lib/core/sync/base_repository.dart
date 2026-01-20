import 'package:drift/drift.dart';
import '../database/database.dart';

/// Base repository to handle offline-first sync logic
abstract class BaseRepository {
  final AppDatabase db;

  BaseRepository(this.db);

  /// Performs a local write and queues it for sync in a single transaction.
  /// 
  /// [action]: 'create', 'update', or 'delete'
  /// [table]: The target table name (e.g. 'exercise_logs')
  /// [performWrite]: Function that executes the local write and returns the record ID
  Future<int> performWithSync({
    required String action,
    required String table,
    required Future<int> Function() performWrite,
  }) async {
    return await db.transaction<int>(() async {
      // 1. Perform local write
      final id = await performWrite();

      // 2. Queue for sync
      await db.into(db.syncQueue).insert(
        SyncQueueCompanion.insert(
          targetTable: table,
          recordId: id,
          action: action,
          queuedAt: Value(DateTime.now()),
        ),
      );

      return id;
    });
  }
}
