import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';

class TaskService {
  final TaskRepository _repository = TaskRepository();
  final Uuid _uuid = const Uuid();

  // -----------------------------
  // CREATE TASK
  // -----------------------------
  Future<void> createTask({
    required String title,
    String? description,
    DateTime? dueDate,
  }) async {
    final now = DateTime.now();

    final task = TaskModel(
      id: _uuid.v4(),
      title: title.trim(),
      description: description?.trim(),
      dueDate: dueDate,
      isCompleted: false,
      createdAt: now,
      updatedAt: now,
    );

    await _repository.addTask(task);
  }

  // -----------------------------
  // UPDATE TASK
  // -----------------------------
  Future<void> updateTask(TaskModel task) async {
    final updated = task.copyWith(updatedAt: DateTime.now());
    await _repository.updateTask(updated);
  }

  // -----------------------------
  // TOGGLE COMPLETION
  // -----------------------------
  Future<void> toggleTaskCompletion(TaskModel task) async {
    final updated = task.copyWith(
      isCompleted: !task.isCompleted,
      updatedAt: DateTime.now(),
    );

    await _repository.updateTask(updated);
  }

  // -----------------------------
  // DELETE TASK
  // -----------------------------
  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
  }

  // -----------------------------
  // GET ALL TASKS
  // -----------------------------
  Future<List<TaskModel>> getAllTasks() async {
    return await _repository.getAllTasks();
  }

  // -----------------------------
  // GET SINGLE TASK
  // -----------------------------
  Future<TaskModel?> getTaskById(String id) async {
    return await _repository.getTaskById(id);
  }
}
