import 'package:sqflite/sqflite.dart';
import '../models/task_model.dart';
import '../database/app_database.dart';

class TaskDao {
  static const String tableName = 'tasks';

  // -----------------------------
  // CREATE TABLE
  // -----------------------------
  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        dueDate TEXT,
        completed INTEGER NOT NULL,
        category TEXT NOT NULL,
        priority INTEGER NOT NULL,
        emotionalLoad INTEGER NOT NULL,
        fatigueImpact INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  // -----------------------------
  // INSERT TASK
  // -----------------------------
  Future<void> insertTask(TaskModel task) async {
    final db = await AppDatabase.instance.database;
    await db.insert(
      tableName,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // -----------------------------
  // UPDATE TASK
  // -----------------------------
  Future<void> updateTask(TaskModel task) async {
    final db = await AppDatabase.instance.database;
    await db.update(
      tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // -----------------------------
  // DELETE TASK
  // -----------------------------
  Future<void> deleteTask(String id) async {
    final db = await AppDatabase.instance.database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // -----------------------------
  // GET ALL TASKS
  // -----------------------------
  Future<List<TaskModel>> getAllTasks() async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query(tableName, orderBy: 'createdAt DESC');

    return maps.map((m) => TaskModel.fromMap(m)).toList();
  }

  // -----------------------------
  // GET TASK BY ID
  // -----------------------------
  Future<TaskModel?> getTaskById(String id) async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return TaskModel.fromMap(maps.first);
  }

  // -----------------------------
  // GET TASKS BY CATEGORY
  // -----------------------------
  Future<List<TaskModel>> getTasksByCategory(String category) async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query(
      tableName,
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'priority DESC',
    );

    return maps.map((m) => TaskModel.fromMap(m)).toList();
  }

  // -----------------------------
  // GET OVERDUE TASKS
  // -----------------------------
  Future<List<TaskModel>> getOverdueTasks(DateTime now) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      tableName,
      where: 'dueDate IS NOT NULL AND completed = 0 AND dueDate < ?',
      whereArgs: [now.toIso8601String()],
      orderBy: 'dueDate ASC',
    );

    return maps.map((m) => TaskModel.fromMap(m)).toList();
  }

  // -----------------------------
  // GET TASKS DUE ON SPECIFIC DATE
  // -----------------------------
  Future<List<TaskModel>> getTasksForDate(DateTime date) async {
    final db = await AppDatabase.instance.database;

    final start = DateTime(date.year, date.month, date.day, 0, 0);
    final end = DateTime(date.year, date.month, date.day, 23, 59);

    final maps = await db.query(
      tableName,
      where: 'dueDate >= ? AND dueDate <= ?',
      whereArgs: [
        start.toIso8601String(),
        end.toIso8601String(),
      ],
      orderBy: 'priority DESC',
    );

    return maps.map((m) => TaskModel.fromMap(m)).toList();
  }
}
