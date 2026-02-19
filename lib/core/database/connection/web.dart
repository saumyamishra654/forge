import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

LazyDatabase connect() {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: 'forge',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );

    if (result.missingFeatures.isNotEmpty) {
      throw UnsupportedError(
        'WebAssembly SQLite is not supported in this browser: ${result.missingFeatures}',
      );
    }

    return result.resolvedExecutor;
  });
}
