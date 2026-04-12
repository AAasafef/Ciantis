import 'dart:async';
import 'dart:io';

import 'calendar_export_engine.dart';
import 'calendar_import_engine.dart';

/// CalendarBackupService handles:
/// - Automatic periodic backups
/// - Manual backups
/// - Restore from backup
/// - Local file persistence
///
/// This is a silent background service.
class CalendarBackupService {
  // Singleton
  static final CalendarBackupService instance =
      CalendarBackupService._internal();
  CalendarBackupService._internal();

  Timer? _timer;

  // -----------------------------
  // INITIALIZE (START AUTO BACKUPS)
  // -----------------------------
  void initialize() {
    // Backup every 6 hours
    _timer = Timer.periodic(
      const Duration(hours: 6),
      (_) => _autoBackup(),
    );
  }

  // -----------------------------
  // MANUAL BACKUP
  // -----------------------------
  Future<bool> backupNow() async {
    try {
      final json = CalendarExportEngine.instance.exportAllAsJson();
      final file = await _backupFile();
      await file.writeAsString(json);
      return true;
    } catch (_) {
      return false;
    }
  }

  // -----------------------------
  // RESTORE BACKUP
  // -----------------------------
  Future<bool> restore() async {
    try {
      final file = await _backupFile();
      if (!await file.exists()) return false;

      final json = await file.readAsString();
      return CalendarImportEngine.instance.importReplaceAll(json);
    } catch (_) {
      return false;
    }
  }

  // -----------------------------
  // AUTO BACKUP
  // -----------------------------
  Future<void> _autoBackup() async {
    try {
      final json = CalendarExportEngine.instance.exportAllAsJson();
      final file = await _backupFile();
      await file.writeAsString(json);
    } catch (_) {
      // Silent fail
    }
  }

  // -----------------------------
  // BACKUP FILE PATH
  // -----------------------------
  Future<File> _backupFile() async {
    final dir = Directory.systemTemp; // Replace with app directory later
    return File("${dir.path}/ciantis_calendar_backup.json");
  }

  // -----------------------------
  // DISPOSE
  // -----------------------------
  void dispose() {
    _timer?.cancel();
  }
}
