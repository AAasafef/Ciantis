import '../../data/models/task_model.dart';
import '../../data/services/task_service.dart';

/// Centralized bulk operations for tasks.
/// Used by:
/// - Task List Page (multi-select)
/// - Dashboard actions
/// - Mode Engine automation
/// - Next Best Action Engine
/// - Developer tools
class TaskBulkActions {
  // Singleton
  static final TaskBulkActions instance = TaskBulkActions._internal();
  TaskBulkActions._internal();

  // -----------------------------
  // BULK DELETE
  // -----------------------------
  Future<void> deleteTasks(
    TaskService service,
    List<TaskModel> tasks,
  ) async {
    for (final t in tasks) {
      await service.deleteTask(t.id);
    }
  }

  // -----------------------------
  // BULK COMPLETE
  // -----------------------------
  Future<void> completeTasks(
    TaskService service,
    List<TaskModel> tasks,
  ) async {
    for (final t in tasks) {
      await service.completeTask(t.id);
    }
  }

  // -----------------------------
  // BULK PRIORITY CHANGE
  // -----------------------------
  Future<void> changePriority(
    TaskService service,
    List<TaskModel> tasks,
    int newPriority,
  ) async {
    for (final t in tasks) {
      final updated = t.copyWith(priority: newPriority);
      await service.updateTask(updated);
    }
  }

  // -----------------------------
  // BULK CATEGORY CHANGE
  // -----------------------------
  Future<void> changeCategory(
    TaskService service,
    List<TaskModel> tasks,
    String newCategory,
  ) async {
    for (final t in tasks) {
      final updated = t.copyWith(category: newCategory);
      await service.updateTask(updated);
    }
  }

  // -----------------------------
  // BULK EMOTIONAL LOAD ADJUSTMENT
  // -----------------------------
  Future<void> adjustEmotionalLoad(
    TaskService service,
    List<TaskModel> tasks,
    int delta,
  ) async {
    for (final t in tasks) {
      final updated = t.copyWith(
        emotionalLoad: (t.emotionalLoad + delta).clamp(1, 10),
      );
      await service.updateTask(updated);
    }
  }

  // -----------------------------
  // BULK FATIGUE IMPACT ADJUSTMENT
  // -----------------------------
  Future<void> adjustFatigueImpact(
    TaskService service,
    List<TaskModel> tasks,
    int delta,
  ) async {
    for (final t in tasks) {
      final updated = t.copyWith(
        fatigueImpact: (t.fatigueImpact + delta).clamp(1, 10),
      );
      await service.updateTask(updated);
    }
  }

  // -----------------------------
  // BULK DUE DATE CHANGE
  // -----------------------------
  Future<void> changeDueDate(
    TaskService service,
    List<TaskModel> tasks,
    DateTime? newDate,
  ) async {
    for (final t in tasks) {
      final updated = t.copyWith(dueDate: newDate);
      await service.updateTask(updated);
    }
  }
}
