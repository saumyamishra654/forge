---
description: Implement cross-platform JSON backup and restore for Flutter (Web & Native)
---

# Cross-Platform Backup & Restore Workflow

This workflow guides you through implementing a robust backup system that works on both Mobile (iOS/Android) and Web (PWA).

## 1. Dependencies
Add the following to `pubspec.yaml`:
- `file_picker`: For selecting files on all platforms.
- `share_plus`: For exporting files on Native.
- `path_provider`: For temporary directories (Native).
- `intl`: For timestamp formatting.

## 2. Platform-Specific Helpers
Create a conditional export to handle platform differences (Download vs Share).

**`lib/core/backup/backup_helper.dart`** (Stub)
```dart
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
// Conditional imports
if (dart.library.html) 'backup_helper_web.dart'
if (dart.library.io) 'backup_helper_native.dart';

class BackupHelper {
  static Future<void> downloadFile(Uint8List bytes, String fileName) {
    throw UnimplementedError();
  }
}
```

**`lib/core/backup/backup_helper_web.dart`** (Web Implementation)
```dart
import 'dart:html' as html;
import 'dart:typed_data';

class BackupHelper {
  static Future<void> downloadFile(Uint8List bytes, String fileName) async {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
```

**`lib/core/backup/backup_helper_native.dart`** (Native Stub)
```dart
import 'dart:typed_data';

class BackupHelper {
  static Future<void> downloadFile(Uint8List bytes, String fileName) async {
    // on Native, we use Share.shareXFiles in the main service, 
    // or you can implement file saving logic here.
    // This stub is just to satisfy the compiler.
  }
}
```

## 3. Backup Logic
In your `BackupService`:

**Export:**
1. Collect data from DB tables into a Map.
2. `jsonEncode` the Map.
3. `utf8.encode` to get `Uint8List`.
4. **Web**: Call `BackupHelper.downloadFile(bytes, name)`.
5. **Native**: Write bytes to `NSTemporaryDirectory`, then `Share.shareXFiles([XFile(path)])`.

**Import:**
1. `FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json'], withData: true)`
   - **Crucial**: `withData: true` enables `result.files.single.bytes` on Web.
2. If `bytes` is present (Web), `utf8.decode(bytes)`.
3. If `path` is present (Native), `File(path).readAsString()`.
4. Parse JSON and `insertOnConflictUpdate` into DB.

## 4. Database Restoration
Use `insertOnConflictUpdate` to merge data safely without wiping the existing database (unless a full wipe is desired).

```dart
await db.into(db.table).insertOnConflictUpdate(Item.fromJson(json));
```
