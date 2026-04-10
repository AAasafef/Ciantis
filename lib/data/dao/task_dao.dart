import 'package:sqflite/sqflite.dart';
import '../models/task_model.dart';

class TaskDao {
  final Database db;

  TaskDao(this.db);

  static const String tableName = "tasks";

  static const String createTableQuery = """
    CREATE TABLE IF NOT EXISTS $tableName (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT,
      createdAt TEXT NOT NULL,
      dueDate TEXT,
      completedAt TEXT,
      isCompleted INTEGER NOT NULL,
      emotionalLoad INTEGER NOT NULL,
      fatigueImpact INTEGER NOT NULL,
      category TEXT NOT NULL,
      location TEXT,
      hasSubtasks INTEGER NOT NULL,
      subtaskIds TEXT,
      reminderEnabled INTEGER NOT NULL,
      reminderMinutesBefore INTEGER NOT NULL,
      isRecurring INTEGER NOT NULL,
      recurrenceRule TEXT
    );
  """;

  Future<void> insert(TaskModel task) async {
    await db.insert(
      tableName,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(TaskModel task) async {
    await db.update(
      tableName,
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  Future<void> delete(String id) async {
    await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<TaskModel?> getById(String id) async {
    final result = await db.query(
      tableName,
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return TaskModel.fromMap(result.first);
  }

  Future<List<TaskModel>> getAll() async {
    final result = await db.query(
      tableName,
      orderBy: "createdAt DESC",
    );

    return result.map((m) => TaskModel.fromMap(m)).toList();
  }

  Future<List<TaskModel>> getByDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final result = await db.query(
      tableName,
      where: "dueDate >= ? AND dueDate < ?",
      whereArgs: [
        start.toIso8601String(),
        end.toIso8601String(),
      ],
      orderBy: "dueDate ASC",
    );

    return result.map((m) => TaskModel.fromMap(m)).toList();
  }

  Future<void> toggleCompletion(TaskModel task) async {
    final updated = task.copyWith(
      isCompleted: !task.isCompleted,
      completedAt: !task.isCompleted ? DateTime.now() : null,
    );

    await update(updated);
  }
}
