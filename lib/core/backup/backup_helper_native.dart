import 'dart:typed_data';

class BackupHelper {
  static void downloadFile(Uint8List bytes, String fileName) {
    // Native uses Share Sheet via BackupService directly, 
    // but we need the class to exist for compilation.
  }
}
