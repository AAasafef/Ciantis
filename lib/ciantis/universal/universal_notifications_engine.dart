import 'ciantis_context.dart';
import 'mode_engine.dart';
import '../../tasks/notifications/task_notification_dispatcher.dart';
import '../../tasks/integrations/task_integration_hub.dart';

/// UniversalNotificationsEngine
/// -----------------------------
/// Unifies notifications across:
/// - Tasks OS
/// - Mode Engine
/// - Universal AI
///
/// Calendar OS will plug in later.
///
/// This engine decides WHEN and WHAT to notify.
class UniversalNotificationsEngine {
  // Singleton
  static final UniversalNotificationsEngine instance =
      UniversalNotificationsEngine._internal();
  UniversalNotificationsEngine._internal();

  final _context = CiantisContext.instance;
  final _mode = ModeEngine.instance;
  final _tasks = TaskIntegrationHub.instance;
  final _dispatcher = TaskNotificationDispatcher.instance;

  // -----------------------------
  // SEND UNIVERSAL NOTIFICATION
  // -----------------------------
  void send(String message) {
    _dispatcher.sendUniversal(message);
  }

  // -----------------------------
  // MODE-AWARE NOTIFICATION
  // -----------------------------
  void notifyModeChange() {
    final mode = _context.mode;
    send("Mode updated: $mode");
  }

  // -----------------------------
  // TASK REMINDER NOTIFICATION
  // -----------------------------
  void notifyTaskReminder() {
    final now = DateTime.now();
    final task = _tasks.nextBestAction(now: now, mode: _context.mode);

    if (task != null) {
      send("Reminder: ${task.title}");
    }
  }

  // -----------------------------
  // UNIVERSAL TICK (called every X minutes)
  // -----------------------------
  void tick() {
    // Update context time
    _context.updateTime(DateTime.now());

    // Auto-detect mode
    final oldMode = _context.mode;
    _mode.updateModeAutomatically();
    final newMode = _context.mode;

    // Notify if mode changed
    if (oldMode != newMode) {
      notifyModeChange();
    }

    // Task reminders
    notifyTaskReminder();
  }
}
