import '../../data/models/task_model.dart';

/// Converts tasks into calendar‑friendly structures.
/// This is the bridge between the Tasks subsystem and the Calendar subsystem.
///
/// It provides:
/// - Tasks grouped by date
/// - Overdue tasks
/// - Upcoming tasks
/// - Normalized date keys (midnight)
///
/// Used by:
/// - Calendar Month View
/// - Calendar Week View
/// - Calendar Day View
/// - Dashboard indicators
/// - Mode Engine scheduling
class TaskCalendarMapper {
  // Singleton
  static final TaskCalendarMapper instance =
      TaskCalendarMapper._internal();

  TaskCalendarMapper._internal();

  // -----------------------------
  // NORMALIZE DATE (midnight)
  // -----------------------------
  DateTime normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // -----------------------------
  // GROUP TASKS BY DATE
  // -----------------------------
  Map<DateTime, List<TaskModel>> groupByDate(List<TaskModel> tasks) {
    final Map<DateTime, List<TaskModel>> map = {};

    for (final task in tasks) {
      if (task.dueDate == null) continue;

      final key = normalize(task.dueDate!);

      if (!map.containsKey(key)) {
        map[key] = [];
      }

      map[key]!.add(task);
    }

    return map;
  }

  // -----------------------------
  // GET OVERDUE TASKS
  // -----------------------------
  List<TaskModel> overdueTasks(List<TaskModel> tasks) {
    final now = DateTime.now();
    return tasks.where((t) {
      if (t.dueDate == null) return false;
      return !t.isCompleted && t.dueDate!.isBefore(now);
    }).toList();
  }

  // -----------------------------
  // GET UPCOMING TASKS (next X days)
  // -----------------------------
  List<TaskModel> upcomingTasks(List<TaskModel> tasks, int days) {
    final now = DateTime.now();
    final limit = now.add(Duration(days: days));

    return tasks.where((t) {
      if (t.dueDate == null) return false;
      return !t.isCompleted &&
          t.dueDate!.isAfter(now) &&
          t.dueDate!.isBefore(limit);
    }).toList();
  }

  // -----------------------------
  // FULL CALENDAR PACKAGE
  // -----------------------------
  Map<String, dynamic> buildCalendarPackage(List<TaskModel> tasks) {
    return {
      "grouped": groupByDate(tasks),
      "overdue": overdueTasks(tasks),
      "upcoming3Days": upcomingTasks(tasks, 3),
      "upcoming7Days": upcomingTasks(tasks, 7),
    };
  }
}
