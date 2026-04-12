import '../models/task.dart';

/// TaskFilteringEngine provides universal filters used across Tasks OS.
/// 
/// These filters power:
/// - Today view
/// - Overdue list
/// - Smart suggestions
/// - Daily planning
/// - Mode Engine (fatigue, focus, recovery)
/// - Academic + Routine integrations
class TaskFilteringEngine {
  // Singleton
  static final TaskFilteringEngine instance =
      TaskFilteringEngine._internal();
  TaskFilteringEngine._internal();

  // -----------------------------
  // TODAY TASKS
  // -----------------------------
  List<Task> today(List<Task> tasks, DateTime now) {
    return tasks.where((t) {
      if (t.isCompleted) return false;

      // Due today
      if (t.dueDate != null &&
          _sameDay(t.dueDate!, now)) {
        return true;
      }

      // Scheduled today
      if (t.scheduledStart != null &&
          _sameDay(t.scheduledStart!, now)) {
        return true;
      }

      return false;
    }).toList();
  }

  // -----------------------------
  // OVERDUE TASKS
  // -----------------------------
  List<Task> overdue(List<Task> tasks, DateTime now) {
    return tasks.where((t) {
      if (t.isCompleted) return false;
      if (t.dueDate == null) return false;
      return t.dueDate!.isBefore(now);
    }).toList();
  }

  // -----------------------------
  // STARRED TASKS
  // -----------------------------
  List<Task> starred(List<Task> tasks) {
    return tasks.where((t) => t.isStarred && !t.isCompleted).toList();
  }

  // -----------------------------
  // HIGH PRIORITY
  // -----------------------------
  List<Task> highPriority(List<Task> tasks) {
    return tasks.where((t) {
      return !t.isCompleted &&
          (t.priority == TaskPriority.high ||
           t.priority == TaskPriority.critical);
    }).toList();
  }

  // -----------------------------
  // LOW ENERGY (FOR FATIGUE MODE)
  // -----------------------------
  List<Task> lowEnergy(List<Task> tasks) {
    return tasks.where((t) {
      return !t.isCompleted &&
          (t.energy == TaskEnergy.low ||
           t.energy == TaskEnergy.medium);
    }).toList();
  }

  // -----------------------------
  // FLEXIBLE TASKS
  // -----------------------------
  List<Task> flexible(List<Task> tasks) {
    return tasks.where((t) {
      return !t.isCompleted &&
          (t.flexibility == TaskFlexibility.flexible ||
           t.flexibility == TaskFlexibility.anytime);
    }).toList();
  }

  // -----------------------------
  // UNSCHEDULED TASKS
  // -----------------------------
  List<Task> unscheduled(List<Task> tasks) {
    return tasks.where((t) {
      return !t.isCompleted &&
          t.scheduledStart == null &&
          t.scheduledEnd == null;
    }).toList();
  }

  // -----------------------------
  // COMPLETED TASKS
  // -----------------------------
  List<Task> completed(List<Task> tasks) {
    return tasks.where((t) => t.isCompleted).toList();
  }

  // -----------------------------
  // SAME DAY CHECK
  // -----------------------------
  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}
