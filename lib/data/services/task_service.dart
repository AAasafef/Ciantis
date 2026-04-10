import '../models/task_model.dart';
import '../repositories/task_repository.dart';

/// TaskService is the business-logic layer for the Tasks subsystem.
/// It handles creation, updates, completion, filtering, and future AI hooks.
class TaskService {
  final TaskRepository repository;

  TaskService(this.repository);

  // -----------------------------
  // CREATE
  // -----------------------------
  Future<void> createTask({
    required String title,
    String? description,
    DateTime? dueDate,
    required String category,
    required int priority,
    required int emotionalLoad,
    required int fatigueImpact,
  }) async {
    final task = TaskModel(
      title: title,
      description: description,
      dueDate: dueDate,
      category: category,
      priority: priority,
      emotionalLoad: emotionalLoad,
      fatigueImpact: fatigueImpact,
    );

    await repository.addTask(task);
  }

  // -----------------------------
  // READ
  // -----------------------------
  Future<List<TaskModel>> getAllTasks() async {
    return await repository.getAllTasks();
  }

  Future<TaskModel?> getTaskById(String id) async {
    return await repository.getTaskById(id);
  }

  Future<List<TaskModel>> getTasksByCategory(String category) async {
    return await repository.getTasksByCategory(category);
  }

  Future<List<TaskModel>> getTasksDueToday() async {
    return await repository.getTasksDueToday();
  }

  // -----------------------------
  // UPDATE
  // -----------------------------
  Future<void> updateTask(TaskModel task) async {
    final updated = task.copyWith(updatedAt: DateTime.now());
    await repository.updateTask(updated);
  }

  // -----------------------------
  // COMPLETE
  // -----------------------------
  Future<void> completeTask(String id) async {
    final task = await repository.getTaskById(id);
    if (task == null) return;

    final updated = task.copyWith(
      isCompleted: true,
      updatedAt: DateTime.now(),
    );

    await repository.updateTask(updated);
  }

  // -----------------------------
  // DELETE
  // -----------------------------
  Future<void> deleteTask(String id) async {
    await repository.deleteTask(id);
  }

  // -----------------------------
  // FUTURE: AI + MODE ENGINE HOOKS
  // -----------------------------
  /// Placeholder for future AI scoring, mode-aware prioritization,
  /// emotional load balancing, fatigue-aware scheduling, etc.
  Future<void> applySmartInsights() async {
    // Will integrate with:
    // - Mode Engine
    // - AI Suggestion Engine
    // - Emotional/Fatigue scoring
    // - Next Best Action Engine
  }
}
