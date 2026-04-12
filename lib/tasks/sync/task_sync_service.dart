import '../task_facade.dart';
import '../models/task.dart';
import '../export/task_export_engine.dart';
import '../export/task_backup_service.dart';

/// TaskSyncService is the future-ready sync layer for Tasks OS.
/// 
/// It mirrors CalendarSyncService and provides:
/// - Push (local → cloud)
/// - Pull (cloud → local)
/// - Conflict resolution hooks
/// - Developer logging
/// 
/// Actual cloud integration will be added later.
class TaskSyncService {
  // Singleton
  static final TaskSyncService instance =
      TaskSyncService._internal();
  TaskSyncService._internal();

  final _facade = TaskFacade.instance;
  final _export = TaskExportEngine.instance;
  final _backup = TaskBackupService.instance;

  bool _initialized = false;

  // -----------------------------
  // INITIALIZE
  // -----------------------------
  void initialize() {
    if (_initialized) return;
    _initialized = true;
  }

  // -----------------------------
  // SYNC ALL (placeholder)
  // -----------------------------
  Future<void> syncAll() async {
    // Placeholder for future cloud sync
    // For now, just log + backup
    await _backup.autoBackup();
  }

  // -----------------------------
  // PUSH (local → cloud)
  // -----------------------------
  Future<void> push() async {
    // Placeholder for cloud push
    final json = _export.exportAllAsJson();
    // ignore: avoid_print
    print("[TASK SYNC] PUSH → $json");
  }

  // -----------------------------
  // PULL (cloud → local)
  // -----------------------------
  Future<void> pull() async {
    // Placeholder for cloud pull
    // ignore: avoid_print
    print("[TASK SYNC] PULL → (no cloud yet)");
  }

  // -----------------------------
  // CONFLICT RESOLUTION (stub)
  // -----------------------------
  Task resolveConflict(Task local, Task remote) {
    // Simple rule for now:
    // Remote wins if updated more recently (future metadata)
    return remote;
  }

  // -----------------------------
  // DISPOSE
  // -----------------------------
  void dispose() {
    // Nothing to dispose yet
  }
}
