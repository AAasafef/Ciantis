import '../dao/task_dao.dart';
import '../models/task_model.dart';

class TaskRepository {
  final TaskDao _dao = TaskDao();

  // -----------------------------
  // ADD TASK
  // -----------------------------
  Future<void> addTask(TaskModel task) async {
    await _dao.insertTask(task);
  }

  // -----------------------------
  // UPDATE TASK
  // -----------------------------
  Future<void> updateTask(TaskModel task) async {
    await _dao.updateTask(task);
  }

  // -----------------------------
  // DELETE TASK
  // -----------------------------
  Future<void> deleteTask(String id) async {
    await _dao.deleteTask(id);
  }

  // -----------------------------
  // GET ALL TASKS
  // -----------------------------
  Future<List<TaskModel>> getAllTasks() async {
    return await _dao.getAllTasks();
  }

  // -----------------------------
  // GET TASK BY ID
  // -----------------------------
  Future<TaskModel?> getTaskById(String id) async {
    return await _dao.getTaskById(id);
  }

  // -----------------------------
  // GET TASKS BY CATEGORY
  // -----------------------------
  Future<List<TaskModel>> getTasksByCategory(String category) async {
    return await _dao.getTasksByCategory(category);
  }

  // -----------------------------
  // GET TASKS BY DUE DATE
  // -----------------------------
  Future<List<TaskModel>> getTasksByDueDate(DateTime date) async {
    return await _dao.getTasksByDueDate(date);
  }
}
