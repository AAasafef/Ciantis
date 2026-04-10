import '../models/task_model.dart';
import 'task_repository.dart';

/// Extensions that add advanced querying and batch operations
/// to the TaskRepository. These are used by:
/// - Dashboard
/// - Mode Engine
/// - Next Best Action Engine
/// - Calendar subsystem
/// - Notification Engine
extension TaskRepositoryExtensions on TaskRepository {
  // -----------------------------
  // GET HIGH PRIORITY TASKS
  // -----------------------------
  Future<List<TaskModel>> getHighPriorityTasks() async {
    final all = await getAllTasks();
    return all.where((t) => t.priority >= 4 && !t.isCompleted).toList();
  }

  // -----------------------------
  // GET OVERDUE TASKS
  // -----------------------------
  Future<List<TaskModel>> getOverdueTasks() async {
    final all = await getAllTasks();
    final now = DateTime.now();

    return all.where((t) {
      if (t.dueDate == null) return false;
      return !t.isCompleted && t.dueDate!.isBefore(now);
    }).toList();
  }

  // -----------------------------
  // GET TASKS SORTED BY URGENCY SCORE
  // -----------------------------
  Future<List<TaskModel>> getTasksByUrgency() async {
    final all = await getAllTasks();

    all.sort((a, b) => b.urgencyScore.compareTo(a.urgencyScore));

    return all;
  }

  // -----------------------------
  // BULK DELETE
  // -----------------------------
  Future<void> deleteTasks(List<String> ids) async {
    for (final id in ids) {
      await deleteTask(id);
    }
  }

  // -----------------------------
  // BULK UPDATE
  // -----------------------------
  Future<void> updateTasks(List<TaskModel> tasks) async {
    for (final task in tasks) {
      await updateTask(task);
    }
  }

  // -----------------------------
  // GET TASKS BY CATEGORY
  // -----------------------------
  Future<List<TaskModel>> getTasksInCategory(String category) async {
    final all = await getAllTasks();
    return all.where((t) => t.category == category).toList();
  }

  // -----------------------------
  // GET TASKS DUE IN NEXT X DAYS
  // -----------------------------
  Future<List<TaskModel>> getTasksDueInDays(int days) async {
    final all = await getAllTasks();
    final now = DateTime.now();
    final limit = now.add(Duration(days: days));

    return all.where((t) {
      if (t.dueDate == null) return false;
      return !t.isCompleted &&
          t.dueDate!.isAfter(now) &&
          t.dueDate!.isBefore(limit);
    }).toList();
  }
}
