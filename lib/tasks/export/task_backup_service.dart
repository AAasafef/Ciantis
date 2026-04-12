import 'dart:convert';
import 'dart:io';

import '../task_facade.dart';
import 'task_export_engine.dart';

/// TaskBackupService handles:
/// - Local backup
/// - Restore
/// - Autosave hooks
/// - Future cloud sync integration
///
/// This mirrors CalendarBackupService for consistency.
class TaskBackupService {
  // Singleton
  static final TaskBackupService instance =
      TaskBackupService._internal();
  TaskBackupService._internal();

  final _facade = TaskFacade.instance;
  final _export = TaskExportEngine.instance;

  late final Directory _dir;
  late final File _file;

  bool _initialized = false;

  // -----------------------------
  // INITIALIZE
  // -----------------------------
  Future<void> initialize() async {
    if (_initialized) return;

    _dir = Directory.systemTemp.createTempSync("ciantis_tasks_backup");
    _file = File("${_dir.path}/tasks_backup.json");

    _initialized = true;
  }

  // -----------------------------
  // BACKUP NOW
  // -----------------------------
  Future<bool> backupNow() async {
    try {
      final json = _export.exportAllAsJson();
      await _file.writeAsString(json);
      return true;
    } catch (_) {
      return false;
    }
  }

  // -----------------------------
  // RESTORE
  // -----------------------------
  Future<bool> restore() async {
    try {
      if (!await _file.exists()) return false;

      final json = await _file.readAsString();
      final list = jsonDecode(json) as List<dynamic>;

      final tasks = list.map((map) {
        return Task.fromMap(map as Map<String, dynamic>);
      }).toList();

      _facade.replaceAll(tasks);
      return true;
    } catch (_) {
      return false;
    }
  }

  // -----------------------------
  // AUTO-BACKUP HOOK
  // -----------------------------
  Future<void> autoBackup() async {
    await backupNow();
  }

  // -----------------------------
  // DISPOSE
  // -----------------------------
  void dispose() {
    // No streams to close here, but included for symmetry
  }
}
