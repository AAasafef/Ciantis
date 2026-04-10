import '../dao/task_dao.dart';
import '../models/task_model.dart';

class TaskRepository {
  final TaskDao dao;

  TaskRepository(this.dao);

  // Create
  Future<void> createTask(TaskModel task) async {
    await dao.insert(task);
  }

  // Update
  Future<void> updateTask(TaskModel task) async {
    await dao.update(task);
  }

  // Delete
  Future<void> deleteTask(String id) async {
    await dao.delete(id);
  }

  // Get by ID
  Future<TaskModel?> getTaskById(String id) async {
    return await dao.getById(id);
  }

  // Get all tasks
  Future<List<TaskModel>> getAllTasks() async {
    return await dao.getAll();
  }

  // Get tasks by date
  Future<List<TaskModel>> getTasksByDate(DateTime date) async {
    return await dao.getByDate(date);
  }

  // Toggle completion
  Future<void> toggleTaskCompletion(TaskModel task) async {
    await dao.toggleCompletion(task);
  }

  // Get tasks by category (school, kids, salon, health, personal)
  Future<List<TaskModel>> getTasksByCategory(String category) async {
    final all = await dao.getAll();
    return all.where((t) => t.category == category).toList();
  }

  // Get tasks with high emotional load
  Future<List<TaskModel>> getHighEmotionalLoadTasks() async {
    final all = await dao.getAll();
    return all.where((t) => t.emotionalLoad >= 7).toList();
  }

  // Get tasks with high fatigue impact
  Future<List<TaskModel>> getHighFatigueTasks() async {
    final all = await dao.getAll();
    return all.where((t) => t.fatigueImpact >= 7).toList();
  }

  // Get overdue tasks
  Future<List<TaskModel>> getOverdueTasks() async {
    final now = DateTime.now();
    final all = await dao.getAll();

    return all.where((t) {
      if (t.dueDate == null) return false;
      if (t.isCompleted) return false;
      return t.dueDate!.isBefore(now);
    }).toList();
  }

  // Get recurring tasks
  Future<List<TaskModel>> getRecurringTasks() async {
    final all = await dao.getAll();
    return all.where((t) => t.isRecurring).toList();
  }
}
