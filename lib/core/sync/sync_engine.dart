import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../database/database.dart';
import 'connectivity_service.dart';
import 'sync_repository.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SyncEngine {
  final AppDatabase database;
  final SyncRepository syncRepository;
  final ConnectivityService connectivityService;

  StreamSubscription<bool>? _connectivitySubscription;
  StreamSubscription<List<dynamic>>? _queueSubscription;
  StreamSubscription<User?>? _authSubscription;
  bool _isSyncing = false;

  SyncEngine({
    required this.database,
    required this.syncRepository,
    required this.connectivityService,
  }) {
    _initialize();
  }

  void _initialize() {
    debugPrint('⚙️ SyncEngine initialized');
    
    // Listen to connectivity
    _connectivitySubscription = connectivityService.onConnectivityChanged.listen((isOnline) {
      if (isOnline) {
        _pushPendingChanges();
      }
    });

    // Listen to auth state changes (Backfill on Login)
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        debugPrint('👤 User signed in, triggering backfill...');
        triggerBackfill();
      }
    });

    // Watch sync queue
    _queueSubscription = database.select(database.syncQueue).watch().listen((items) {
      if (items.isNotEmpty && connectivityService.isOnline && !_isSyncing) {
        _pushPendingChanges();
      }
    });
  }

  Future<void> _pushPendingChanges() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final pendingItems = await (database.select(database.syncQueue)
            ..orderBy([(t) => OrderingTerm.asc(t.queuedAt)]))
          .get();

      if (pendingItems.isEmpty) return;

      debugPrint('🔄 Syncing ${pendingItems.length} pending items...');

      for (final item in pendingItems) {
        if (!connectivityService.isOnline) break;
        await _processQueueItem(item);
      }
    } catch (e) {
      debugPrint('❌ Sync error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  /// Triggers a scan of all local data to find unsynced items and queue them.
  /// Call this after login.
  Future<void> triggerBackfill() async {
    debugPrint('🕵️ Starting backfill scan for unsynced data...');
    
    // Helper to queue items
    Future<void> queueUnsyncedResults(String table, List<dynamic> results) async {
      int count = 0;
      for (final row in results) {
        // Check if already in queue
        final inQueue = await (database.select(database.syncQueue)
          ..where((t) => t.targetTable.equals(table) & t.recordId.equals(row.id)))
          .getSingleOrNull();
          
        if (inQueue == null) {
          // Determine action
          final String action = (row.remoteId != null) ? 'update' : 'create';
          if (row.isDeleted == true && row.remoteId == null) continue; // Skip local-only deleted

          await database.into(database.syncQueue).insert(
            SyncQueueCompanion.insert(
              targetTable: table,
              recordId: row.id,
              action: row.isDeleted == true ? 'delete' : action,
              queuedAt: Value(DateTime.now()),
            ),
          );
          count++;
        }
      }
      if (count > 0) debugPrint('  + Queued $count items from $table');
    }

    // 1. Exercise Logs
    final exerciseLogs = await (database.select(database.exerciseLogs)
      ..where((t) => t.syncStatus.equals(0)))
      .get();
    await queueUnsyncedResults('exercise_logs', exerciseLogs);

    // 2. Food Logs
    final foodLogs = await (database.select(database.foodLogs)
      ..where((t) => t.syncStatus.equals(0)))
      .get();
    await queueUnsyncedResults('food_logs', foodLogs);
    
    // 3. Weight Logs
    final weightLogs = await (database.select(database.weightLogs)
      ..where((t) => t.syncStatus.equals(0)))
      .get();
    await queueUnsyncedResults('weight_logs', weightLogs);

    debugPrint('✅ Backfill scan complete.');
    _pushPendingChanges();
  }

  Future<void> _processQueueItem(SyncQueueData item) async {
    try {
      debugPrint('🚀 Processing ${item.action} on ${item.targetTable} #${item.recordId}');
      
      // Fetch full record based on table and ID
      Map<String, dynamic>? data;
      
      // If NOT delete, fetch data
      if (item.action != 'delete') {
         data = await _fetchRecordData(item.targetTable, item.recordId);
         if (data == null) {
           debugPrint('⚠️ Record ${item.recordId} not found in ${item.targetTable}, removing from queue.');
           await (database.delete(database.syncQueue)..where((t) => t.id.equals(item.id))).go();
           return;
         }
      }

      // Perform Sync
      final remoteId = await syncRepository.syncRecord(
        table: item.targetTable,
        action: item.action,
        localId: item.recordId,
        data: data,
      );

      // If successful, update local record and remove from queue
      if (remoteId != null && item.action != 'delete') {
         await _updateLocalStatus(item.targetTable, item.recordId, remoteId);
      }
      
      await (database.delete(database.syncQueue)..where((t) => t.id.equals(item.id))).go();
      
    } catch (e) {
      debugPrint('❌ Failed to process sync item ${item.id}: $e');
      // Leave in queue to retry later
    }
  }

  Future<void> _updateLocalStatus(String table, int id, String remoteId) async {
    switch (table) {
      case 'exercise_logs':
        await (database.update(database.exerciseLogs)..where((t) => t.id.equals(id))).write(
          ExerciseLogsCompanion(
            syncStatus: const Value(2), // Synced
            remoteId: Value(remoteId),
          ),
        );
        break;
      case 'food_logs':
        await (database.update(database.foodLogs)..where((t) => t.id.equals(id))).write(
          FoodLogsCompanion(
            syncStatus: const Value(2),
            remoteId: Value(remoteId),
          ),
        );
        break;
      case 'weight_logs':
        await (database.update(database.weightLogs)..where((t) => t.id.equals(id))).write(
          WeightLogsCompanion(
            syncStatus: const Value(2),
            remoteId: Value(remoteId),
          ),
        );
        break;
    }
  }

  Future<Map<String, dynamic>?> _fetchRecordData(String table, int id) async {
    // Helper to fetch data as simple map
    switch (table) {
      case 'exercise_logs':
        final row = await (database.select(database.exerciseLogs)..where((t) => t.id.equals(id))).getSingleOrNull();
        return row?.toJson();
      case 'food_logs':
        final row = await (database.select(database.foodLogs)..where((t) => t.id.equals(id))).getSingleOrNull();
        return row?.toJson();
      case 'weight_logs':
        final row = await (database.select(database.weightLogs)..where((t) => t.id.equals(id))).getSingleOrNull();
        return row?.toJson();
      default:
        return null;
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _queueSubscription?.cancel();
    _authSubscription?.cancel();
  }
}
