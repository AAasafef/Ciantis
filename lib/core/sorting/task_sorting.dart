import '../../data/models/task_model.dart';

/// Centralized sorting utilities for tasks.
/// Used by:
/// - Task List Page
/// - Dashboard
/// - Calendar subsystem
/// - Mode Engine
/// - Next Best Action Engine
/// - Analytics & Heatmaps
class TaskSorting {
  // Singleton
  static final TaskSorting instance = TaskSorting._internal();
  TaskSorting._internal();

  // -----------------------------
  // SORT BY PRIORITY (DESC)
  // -----------------------------
  List<TaskModel> byPriority(List<TaskModel> tasks) {
    final list = List<TaskModel>.from(tasks);
    list.sort((a, b) => b.priority.compareTo(a.priority));
    return list;
  }

  // -----------------------------
  // SORT BY DUE DATE (ASC)
  // -----------------------------
  List<TaskModel> byDueDate(List<TaskModel> tasks) {
    final list = List<TaskModel>.from(tasks);
    list.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
    return list;
  }

  // -----------------------------
  // SORT BY URGENCY SCORE (DESC)
  // -----------------------------
  List<TaskModel> byUrgency(List<TaskModel> tasks) {
    final list = List<TaskModel>.from(tasks);
    list.sort((a, b) => b.urgencyScore.compareTo(a.urgencyScore));
    return list;
  }

  // -----------------------------
  // SORT BY EMOTIONAL LOAD (DESC)
  // -----------------------------
  List<TaskModel> byEmotionalLoad(List<TaskModel> tasks) {
    final list = List<TaskModel>.from(tasks);
    list.sort((a, b) => b.emotionalLoad.compareTo(a.emotionalLoad));
    return list;
  }

  // -----------------------------
  // SORT BY FATIGUE IMPACT (DESC)
  // -----------------------------
  List<TaskModel> byFatigueImpact(List<TaskModel> tasks) {
    final list = List<TaskModel>.from(tasks);
    list.sort((a, b) => b.fatigueImpact.compareTo(a.fatigueImpact));
    return list;
  }

  // -----------------------------
  // SORT BY COMPLETION (INCOMPLETE FIRST)
  // -----------------------------
  List<TaskModel> byCompletionStatus(List<TaskModel> tasks) {
    final list = List<TaskModel>.from(tasks);
    list.sort((a, b) {
      if (a.isCompleted == b.isCompleted) return 0;
      return a.isCompleted ? 1 : -1;
    });
    return list;
  }

  // -----------------------------
  // COMBINED SORTING STRATEGY
  // -----------------------------
  /// Strategy:
  /// 1. Incomplete tasks first
  /// 2. Higher urgency first
  /// 3. Earlier due date first
  List<TaskModel> combinedStrategy(List<TaskModel> tasks) {
    final list = List<TaskModel>.from(tasks);

    list.sort((a, b) {
      // Incomplete first
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }

      // Higher urgency next
      if (a.urgencyScore != b.urgencyScore) {
        return b.urgencyScore.compareTo(a.urgencyScore);
      }

      // Earlier due date last
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;

      return a.dueDate!.compareTo(b.dueDate!);
    });

    return list;
  }
}
