import 'dart:async';

import '../models/task.dart';

/// TaskRepository is the core data layer for Tasks OS.
/// It provides:
/// - In-memory storage
/// - CRUD operations
/// - Streams for UI updates
/// - Replace-all (for import/backup)
/// - Query helpers
class TaskRepository {
  // Singleton
  static final TaskRepository instance = TaskRepository._internal();
  TaskRepository._internal();

  final List<Task> _tasks = [];

  final _streamController = StreamController<List<Task>>.broadcast();
  Stream<List<Task>> get stream => _streamController.stream;

  // -----------------------------
  // GET ALL
  // -----------------------------
  List<Task> get all => List.unmodifiable(_tasks);

  // -----------------------------
  // ADD
  // -----------------------------
  void add(Task task) {
    _tasks.add(task);
    _emit();
  }

  // -----------------------------
  // UPDATE
  // -----------------------------
  void update(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      _emit();
    }
  }

  // -----------------------------
  // UPSERT
  // -----------------------------
  void upsert(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index == -1) {
      _tasks.add(task);
    } else {
      _tasks[index] = task;
    }
    _emit();
  }

  // -----------------------------
  // DELETE
  // -----------------------------
  void delete(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _emit();
  }

  // -----------------------------
  // REPLACE ALL (IMPORT / BACKUP)
  // -----------------------------
  void replaceAll(List<Task> tasks) {
    _tasks
      ..clear()
      ..addAll(tasks);
    _emit();
  }

  // -----------------------------
  // QUERY HELPERS
  // -----------------------------
  List<Task> dueToday(DateTime now) {
    return _tasks.where((t) {
      if (t.dueDate == null) return false;
      return t.dueDate!.year == now.year &&
          t.dueDate!.month == now.month &&
          t.dueDate!.day == now.day;
    }).toList();
  }

  List<Task> overdue(DateTime now) {
    return _tasks.where((t) {
      if (t.dueDate == null) return false;
      return !t.isCompleted && t.dueDate!.isBefore(now);
    }).toList();
  }

  List<Task> scheduledFor(DateTime day) {
    return _tasks.where((t) {
      if (t.scheduledStart == null) return false;
      return t.scheduledStart!.year == day.year &&
          t.scheduledStart!.month == day.month &&
          t.scheduledStart!.day == day.day;
    }).toList();
  }

  // -----------------------------
  // INTERNAL EMIT
  // -----------------------------
  void _emit() {
    _streamController.add(List.unmodifiable(_tasks));
  }

  // -----------------------------
  // DISPOSE
  // -----------------------------
  void dispose() {
    _streamController.close();
  }
}
