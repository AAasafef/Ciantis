import '../../data/models/task_model.dart';

/// A lightweight, modular notification engine for Tasks.
/// This is a stub layer that will later connect to:
/// - Local notifications (iOS/Android)
/// - Push notifications
/// - Mode Engine triggers
/// - Next Best Action Engine
///
/// For now, it provides a clean API and logs actions.
class TaskNotificationEngine {
  // Singleton pattern
  static final TaskNotificationEngine instance =
      TaskNotificationEngine._internal();

  TaskNotificationEngine._internal();

  // -----------------------------
  // SCHEDULE REMINDER
  // -----------------------------
  Future<void> scheduleTaskReminder(TaskModel task) async {
    if (task.dueDate == null) return;

    // Placeholder for real scheduling
    // Later: integrate with flutter_local_notifications or platform channels
    // For now: simulate scheduling
    print(
        "[TaskNotificationEngine] Scheduled reminder for '${task.title}' at ${task.dueDate}");
  }

  // -----------------------------
  // CANCEL REMINDER
  // -----------------------------
  Future<void> cancelTaskReminder(String taskId) async {
    // Placeholder for real cancellation
    print("[TaskNotificationEngine] Cancelled reminder for task $taskId");
  }

  // -----------------------------
  // SEND INSTANT NOTIFICATION
  // -----------------------------
  Future<void> sendInstantNotification(String title, String body) async {
    // Placeholder for real notification
    print("[TaskNotificationEngine] Instant notification → $title: $body");
  }

  // -----------------------------
  // HOOK: ON TASK CREATED
  // -----------------------------
  Future<void> onTaskCreated(TaskModel task) async {
    await scheduleTaskReminder(task);
  }

  // -----------------------------
  // HOOK: ON TASK UPDATED
  // -----------------------------
  Future<void> onTaskUpdated(TaskModel task) async {
    // Cancel old reminder, schedule new one
    await cancelTaskReminder(task.id);
    await scheduleTaskReminder(task);
  }

  // -----------------------------
  // HOOK: ON TASK DELETED
  // -----------------------------
  Future<void> onTaskDeleted(String taskId) async {
    await cancelTaskReminder(taskId);
  }
}
