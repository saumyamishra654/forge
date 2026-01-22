import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../database/database.dart';
import 'dart:io' as io;
import 'backup_helper.dart';

class BackupService {
  final AppDatabase db;

  BackupService(this.db);

  /// Generates a full JSON backup of all data
  Future<void> exportData() async {
    final Map<String, dynamic> backup = {
      'version': 1,
      'timestamp': DateTime.now().toIso8601String(),
      'tables': {},
    };

    // Export each table
    backup['tables']['exercises'] = await _exportTable(db.exercises);
    backup['tables']['exerciseLogs'] = await _exportTable(db.exerciseLogs);
    
    backup['tables']['foods'] = await _exportTable(db.foods);
    backup['tables']['foodLogs'] = await _exportTable(db.foodLogs);
    backup['tables']['supplements'] = await _exportTable(db.supplements);
    backup['tables']['supplementLogs'] = await _exportTable(db.supplementLogs);
    backup['tables']['alcoholLogs'] = await _exportTable(db.alcoholLogs);
    
    backup['tables']['weightLogs'] = await _exportTable(db.weightLogs);
    backup['tables']['bodyFatLogs'] = await _exportTable(db.bodyFatLogs);
    backup['tables']['expenseCategories'] = await _exportTable(db.expenseCategories);
    backup['tables']['expenses'] = await _exportTable(db.expenses);

    // Convert to JSON
    final jsonString = jsonEncode(backup);
    final bytes = utf8.encode(jsonString);
    final dateStr = DateFormat('yyyy-MM-dd_HHmm').format(DateTime.now());
    final fileName = 'forge_backup_$dateStr.json';

    if (kIsWeb) {
      // WEB: Trigger browser download
      _downloadWeb(bytes, fileName);
    } else {
      // NATIVE: Use Share Sheet
      final tempDir = await getTemporaryDirectory();
      final file = io.File('${tempDir.path}/$fileName');
      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Forge Data Backup ($dateStr)',
      );
    }
  }

  /// Restores data from a picked JSON file
  Future<bool> restoreData() async {
    try {
      // Pick file (FilePicker works on both Native and Web)
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true, // Crucial for Web
      );

      if (result == null || result.files.isEmpty) return false;

      final bytes = result.files.single.bytes;
      if (bytes == null) {
        // Fallback for native if bytes are null (though they shouldn't be with withData: true)
        if (!kIsWeb) {
          final file = io.File(result.files.single.path!);
          final content = await file.readAsString();
          return _processRestore(content);
        }
        return false;
      }

      final jsonString = utf8.decode(bytes);
      return _processRestore(jsonString);
    } catch (e) {
      debugPrint('Restore failed: $e');
      return false;
    }
  }

  Future<bool> _processRestore(String jsonString) async {
    final Map<String, dynamic> backup = jsonDecode(jsonString);

    // Validate version
    if (backup['version'] != 1) {
      throw Exception('Unsupported backup version');
    }

    final tables = backup['tables'] as Map<String, dynamic>;

    await db.transaction(() async {
      if (tables.containsKey('exercises') && tables['exercises'] != null) {
        for (var json in tables['exercises']) {
          await db.into(db.exercises).insertOnConflictUpdate(Exercise.fromJson(json));
        }
      }
      if (tables.containsKey('foods') && tables['foods'] != null) {
        for (var json in tables['foods']) {
          await db.into(db.foods).insertOnConflictUpdate(Food.fromJson(json));
        }
      }
      if (tables.containsKey('supplements') && tables['supplements'] != null) {
        for (var json in tables['supplements']) {
          await db.into(db.supplements).insertOnConflictUpdate(Supplement.fromJson(json));
        }
      }
      
      // Logs
      if (tables.containsKey('exerciseLogs') && tables['exerciseLogs'] != null) {
        for (var json in tables['exerciseLogs']) {
          await db.into(db.exerciseLogs).insertOnConflictUpdate(ExerciseLog.fromJson(json));
        }
      }
      if (tables.containsKey('foodLogs') && tables['foodLogs'] != null) {
        for (var json in tables['foodLogs']) {
          await db.into(db.foodLogs).insertOnConflictUpdate(FoodLog.fromJson(json));
        }
      }
      if (tables.containsKey('supplementLogs') && tables['supplementLogs'] != null) {
        for (var json in tables['supplementLogs']) {
          await db.into(db.supplementLogs).insertOnConflictUpdate(SupplementLog.fromJson(json));
        }
      }
      if (tables.containsKey('alcoholLogs') && tables['alcoholLogs'] != null) {
        for (var json in tables['alcoholLogs']) {
          await db.into(db.alcoholLogs).insertOnConflictUpdate(AlcoholLog.fromJson(json));
        }
      }
      if (tables.containsKey('weightLogs') && tables['weightLogs'] != null) {
        for (var json in tables['weightLogs']) {
          await db.into(db.weightLogs).insertOnConflictUpdate(WeightLog.fromJson(json));
        }
      }
      if (tables.containsKey('bodyFatLogs') && tables['bodyFatLogs'] != null) {
        for (var json in tables['bodyFatLogs']) {
          await db.into(db.bodyFatLogs).insertOnConflictUpdate(BodyFatLog.fromJson(json));
        }
      }
      if (tables.containsKey('expenseCategories') && tables['expenseCategories'] != null) {
        for (var json in tables['expenseCategories']) {
          await db.into(db.expenseCategories).insertOnConflictUpdate(ExpenseCategory.fromJson(json));
        }
      }
      if (tables.containsKey('expenses') && tables['expenses'] != null) {
        for (var json in tables['expenses']) {
          await db.into(db.expenses).insertOnConflictUpdate(Expense.fromJson(json));
        }
      }
    });

    return true;
  }

  Future<List<Map<String, dynamic>>> _exportTable(TableInfo table) async {
    final rows = await db.select(table).get();
    return rows.map((row) => (row as dynamic).toJson()).cast<Map<String, dynamic>>().toList();
  }

  /// Helper to trigger a download in the browser
  void _downloadWeb(List<int> bytes, String fileName) {
    BackupHelper.downloadFile(Uint8List.fromList(bytes), fileName);
  }
}

