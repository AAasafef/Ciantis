import 'package:sqflite/sqflite.dart';
import '../models/habit_model.dart';
import '../database/app_database.dart';

class HabitDao {
  static const String tableName = 'habits';

  // -----------------------------
  // CREATE TABLE
  // -----------------------------
  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        priority INTEGER NOT NULL,
        emotionalLoad INTEGER NOT NULL,
        fatigueImpact INTEGER NOT NULL,
        days TEXT NOT NULL,
        active INTEGER NOT NULL,
        streak INTEGER NOT NULL,
        lastCompletedDate TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  // -----------------------------
  // INSERT HABIT
  // -----------------------------
  Future<void> insertHabit(HabitModel habit) async {
    final db = await AppDatabase.instance.database;
    await db.insert(
      tableName,
      habit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // -----------------------------
  // UPDATE HABIT
  // -----------------------------
  Future<void> updateHabit(HabitModel habit) async {
    final db = await AppDatabase.instance.database;
    await db.update(
      tableName,
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  // -----------------------------
  // DELETE HABIT
  // -----------------------------
  Future<void> deleteHabit(String id) async {
    final db = await AppDatabase.instance.database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // -----------------------------
  // GET ALL HABITS
  // -----------------------------
  Future<List<HabitModel>> getAllHabits() async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query(tableName, orderBy: 'createdAt DESC');

    return maps.map((m) => HabitModel.fromMap(m)).toList();
  }

  // -----------------------------
  // GET HABIT BY ID
  // -----------------------------
  Future<HabitModel?> getHabitById(String id) async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return HabitModel.fromMap(maps.first);
  }

  // -----------------------------
  // GET ACTIVE HABITS
  // -----------------------------
  Future<List<HabitModel>> getActiveHabits() async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query(
      tableName,
      where: 'active = 1',
      orderBy: 'priority DESC',
    );

    return maps.map((m) => HabitModel.fromMap(m)).toList();
  }

  // -----------------------------
  // GET HABITS FOR SPECIFIC WEEKDAY
  // -----------------------------
  Future<List<HabitModel>> getHabitsForWeekday(int weekday) async {
    final db = await AppDatabase.instance.database;

    // weekday is 1–7 (Mon–Sun)
    final maps = await db.query(
      tableName,
      where: 'days LIKE ? AND active = 1',
      whereArgs: ['%$weekday%'],
      orderBy: 'priority DESC',
    );

    return maps.map((m) => HabitModel.fromMap(m)).toList();
  }
}
