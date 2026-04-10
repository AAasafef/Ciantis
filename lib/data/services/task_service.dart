import '../models/task_model.dart';
import '../repositories/task_repository.dart';
import '../../core/notifications/task_notification_engine.dart';

/// TaskService is the main orchestrator for all task operations.
/// This version includes notification hooks for:
/// - Task created
/// - Task updated
/// - Task deleted
/// - Task completed
class TaskService {
  final TaskRepository repository;

  TaskService(this.repository);

  // -----------------------------
  // CREATE TASK
  // -----------------------------
  Future<TaskModel> createTask({
    required String title,
    required String description,
    required String category,
    required int priority,
    required int emotionalLoad,
    required int fatigueImpact,
    required DateTime? dueDate,
  }) async {
    final task = TaskModel.create(
      title: title,
      description: description,
      category: category,
      priority: priority,
      emotionalLoad: emotionalLoad,
      fatigueImpact: fatigueImpact,
      dueDate: dueDate,
    );

    await repository.createTask(task);

    // Notify engine
    await TaskNotificationEngine.instance.onTaskCreated(task);

    return task;
  }

  // -----------------------------
  // GET ALL TASKS
  // -----------------------------
  Future<List<TaskModel>> getAllTasks() async {
    return repository.getAllTasks();
  }

  // -----------------------------
  // GET TASK BY ID
  // -----------------------------
  Future<TaskModel?> getTaskById(String id) async {
    return repository.getTaskById(id);
  }

  // -----------------------------
  // UPDATE TASK
  // -----------------------------
  Future<void> updateTask(TaskModel task) async {
    await repository.updateTask(task);

    // Notify engine
    await TaskNotificationEngine.instance.onTaskUpdated(task);
  }

  // -----------------------------
  // DELETE TASK
  // -----------------------------
  Future<void> deleteTask(String id) async {
    await repository.deleteTask(id);

    // Notify engine
    await TaskNotificationEngine.instance.onTaskDeleted(id);
  }

  // -----------------------------
  // COMPLETE TASK
  // -----------------------------
  Future<void> completeTask(String id) async {
    final task = await repository.getTaskById(id);
    if (task == null) return;

    final updated = task.copyWith(isCompleted: true);

    await repository.updateTask(updated);

    // Cancel reminder since task is done
    await TaskNotificationEngine.instance.cancelTaskReminder(id);
  }
}
