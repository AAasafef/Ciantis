import 'package:cloud_firestore/cloud_firestore.dart';
import '../dao/task_dao.dart';
import '../models/task_model.dart';

class TaskRepository {
  final TaskDao _taskDao = TaskDao.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // COLLECTION NAME
  final String _collection = 'tasks';

  // -----------------------------
  // CREATE / ADD TASK
  // -----------------------------
  Future<void> addTask(TaskModel task) async {
    // Save locally
    await _taskDao.insertTask(task);

    // Save to cloud
    await _firestore.collection(_collection).doc(task.id).set(task.toFirestore());
  }

  // -----------------------------
  // UPDATE TASK
  // -----------------------------
  Future<void> updateTask(TaskModel task) async {
    // Update local
    await _taskDao.updateTask(task);

    // Update cloud
    await _firestore.collection(_collection).doc(task.id).update(task.toFirestore());
  }

  // -----------------------------
  // DELETE TASK
  // -----------------------------
  Future<void> deleteTask(String id) async {
    // Delete local
    await _taskDao.deleteTask(id);

    // Delete cloud
    await _firestore.collection(_collection).doc(id).delete();
  }

  // -----------------------------
  // GET ALL TASKS (LOCAL FIRST)
  // -----------------------------
  Future<List<TaskModel>> getAllTasks() async {
    // Always load from local first (fast)
    final localTasks = await _taskDao.getAllTasks();

    // Then sync cloud → local
    await _syncFromCloud();

    // Return updated local list
    return await _taskDao.getAllTasks();
  }

  // -----------------------------
  // SYNC CLOUD → LOCAL
  // -----------------------------
  Future<void> _syncFromCloud() async {
    final snapshot = await _firestore.collection(_collection).get();

    for (var doc in snapshot.docs) {
      final task = TaskModel.fromFirestore(doc);
      await _taskDao.insertTask(task);
    }
  }

  // -----------------------------
  // GET SINGLE TASK
  // -----------------------------
  Future<TaskModel?> getTaskById(String id) async {
    return await _taskDao.getTaskById(id);
  }
}
