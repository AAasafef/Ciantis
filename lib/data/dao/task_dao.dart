import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../models/task_model.dart';

class TaskDao {
  static const String table = 'tasks';

  // -----------------------------
  // CREATE TABLE
  // -----------------------------
  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        priority INTEGER NOT NULL,
        emotionalLoad INTEGER NOT NULL,
        fatigueImpact INTEGER NOT NULL,
        dueDate TEXT,
        completed INTEGER NOT NULL,
        streak INTEGER NOT NULL,
        lastCompletedDate TEXT,
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
      table,
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
      table,
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
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // -----------------------------
  // GET ALL TASKS
  // -----------------------------
  Future<List<TaskModel>> getAllTasks() async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      table,
      orderBy: 'createdAt DESC',
    );

    return maps.map((m) => TaskModel.fromMap(m)).toList();
  }

  // -----------------------------
  // GET TASK BY ID
  // -----------------------------
  Future<TaskModel?> getTaskById(String id) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      table,
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
      table,
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'priority DESC',
    );

    return maps.map((m) => TaskModel.fromMap(m)).toList();
  }

  // -----------------------------
  // GET TASKS BY DUE DATE
  // -----------------------------
  Future<List<TaskModel>> getTasksByDueDate(DateTime date) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      table,
      where: 'dueDate = ?',
      whereArgs: [date.toIso8601String()],
      orderBy: 'priority DESC',
    );

    return maps.map((m) => TaskModel.fromMap(m)).toList();
  }
}
