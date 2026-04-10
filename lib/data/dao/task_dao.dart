import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/task_model.dart';

/// TaskDao handles low-level storage of tasks.
/// Uses SharedPreferences for now, but can be upgraded to Hive/SQLite later.
class TaskDao {
  static const String storageKey = "ciantis_tasks";

  Future<List<TaskModel>> getAllTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);

    if (raw == null) return [];

    final List decoded = jsonDecode(raw);
    return decoded.map((e) => TaskModel.fromJson(e)).toList();
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(storageKey, encoded);
  }

  Future<void> addTask(TaskModel task) async {
    final tasks = await getAllTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  Future<void> updateTask(TaskModel updated) async {
    final tasks = await getAllTasks();
    final index = tasks.indexWhere((t) => t.id == updated.id);

    if (index != -1) {
      tasks[index] = updated;
      await saveTasks(tasks);
    }
  }

  Future<void> deleteTask(String id) async {
    final tasks = await getAllTasks();
    tasks.removeWhere((t) => t.id == id);
    await saveTasks(tasks);
  }
}
