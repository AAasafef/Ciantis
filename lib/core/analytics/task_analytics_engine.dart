import '../../data/models/task_model.dart';

/// The TaskAnalyticsEngine provides computed insights about the user's
/// task patterns, emotional load, fatigue, and productivity.
///
/// This engine is used by:
/// - Dashboard system
/// - Mode Engine
/// - Next Best Action Engine
/// - Notification Engine (future)
/// - Calendar subsystem
///
/// It is intentionally lightweight and pure (no storage).
class TaskAnalyticsEngine {
  // Singleton
  static final TaskAnalyticsEngine instance =
      TaskAnalyticsEngine._internal();

  TaskAnalyticsEngine._internal();

  // -----------------------------
  // DAILY ANALYTICS
  // -----------------------------
  Map<String, dynamic> dailyAnalytics(List<TaskModel> tasks) {
    final now = DateTime.now();

    final todayTasks = tasks.where((t) {
      if (t.dueDate == null) return false;
      return t.dueDate!.year == now.year &&
          t.dueDate!.month == now.month &&
          t.dueDate!.day == now.day;
    }).toList();

    final completedToday =
        todayTasks.where((t) => t.isCompleted).length;

    final emotionalAvg = _average(
      todayTasks.map((t) => t.emotionalLoad).toList(),
    );

    final fatigueAvg = _average(
      todayTasks.map((t) => t.fatigueImpact).toList(),
    );

    return {
      "tasksDueToday": todayTasks.length,
      "completedToday": completedToday,
      "emotionalAvg": emotionalAvg,
      "fatigueAvg": fatigueAvg,
    };
  }

  // -----------------------------
  // WEEKLY ANALYTICS
  // -----------------------------
  Map<String, dynamic> weeklyAnalytics(List<TaskModel> tasks) {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final weekTasks = tasks.where((t) {
      if (t.dueDate == null) return false;
      return t.dueDate!.isAfter(weekAgo) &&
          t.dueDate!.isBefore(now.add(const Duration(days: 1)));
    }).toList();

    final completed =
        weekTasks.where((t) => t.isCompleted).length;

    final completionRate =
        weekTasks.isEmpty ? 0 : completed / weekTasks.length;

    final emotionalAvg = _average(
      weekTasks.map((t) => t.emotionalLoad).toList(),
    );

    final fatigueAvg = _average(
      weekTasks.map((t) => t.fatigueImpact).toList(),
    );

    return {
      "tasksThisWeek": weekTasks.length,
      "completedThisWeek": completed,
      "completionRate": completionRate,
      "emotionalAvg": emotionalAvg,
      "fatigueAvg": fatigueAvg,
    };
  }

  // -----------------------------
  // PRESSURE SCORES
  // -----------------------------
  int highPriorityPressure(List<TaskModel> tasks) {
    return tasks
        .where((t) => t.priority >= 4 && !t.isCompleted)
        .length;
  }

  int overduePressure(List<TaskModel> tasks) {
    final now = DateTime.now();
    return tasks.where((t) {
      if (t.dueDate == null) return false;
      return !t.isCompleted && t.dueDate!.isBefore(now);
    }).length;
  }

  // -----------------------------
  // OVERALL ANALYTICS PACKAGE
  // -----------------------------
  Map<String, dynamic> fullAnalytics(List<TaskModel> tasks) {
    return {
      "daily": dailyAnalytics(tasks),
      "weekly": weeklyAnalytics(tasks),
      "highPriorityPressure": highPriorityPressure(tasks),
      "overduePressure": overduePressure(tasks),
      "totalTasks": tasks.length,
      "completedTasks":
          tasks.where((t) => t.isCompleted).length,
      "averageEmotionalLoad":
          _average(tasks.map((t) => t.emotionalLoad).toList()),
      "averageFatigueImpact":
          _average(tasks.map((t) => t.fatigueImpact).toList()),
    };
  }

  // -----------------------------
  // INTERNAL HELPERS
  // -----------------------------
  double _average(List<int> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }
}
