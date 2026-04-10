import '../dao/task_dao.dart';
import '../models/task_model.dart';

/// Repository layer for Tasks.
/// Handles sorting, filtering, and preparing data for the service layer.
class TaskRepository {
  final TaskDao dao;

  TaskRepository(this.dao);

  Future<List<TaskModel>> getAllTasks() async {
    final tasks = await dao.getAllTasks();

    // Sort by:
    // 1. Incomplete first
    // 2. Priority (high → low)
    // 3. Due date (soonest → latest)
    tasks.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }

      if (a.priority != b.priority) {
        return b.priority.compareTo(a.priority);
      }

      if (a.dueDate != null && b.dueDate != null) {
        return a.dueDate!.compareTo(b.dueDate!);
      }

      return 0;
    });

    return tasks;
  }

  Future<void> addTask(TaskModel task) async {
    await dao.addTask(task);
  }

  Future<void> updateTask(TaskModel task) async {
    await dao.updateTask(task);
  }

  Future<void> deleteTask(String id) async {
    await dao.deleteTask(id);
  }

  Future<TaskModel?> getTaskById(String id) async {
    final tasks = await dao.getAllTasks();
    try {
      return tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<TaskModel>> getTasksByCategory(String category) async {
    final tasks = await dao.getAllTasks();
    return tasks.where((t) => t.category == category).toList();
  }

  Future<List<TaskModel>> getTasksDueToday() async {
    final tasks = await dao.getAllTasks();
    final now = DateTime.now();

    return tasks.where((t) {
      if (t.dueDate == null) return false;
      return t.dueDate!.year == now.year &&
          t.dueDate!.month == now.month &&
          t.dueDate!.day == now.day;
    }).toList();
  }
}
