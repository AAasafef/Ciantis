import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/habit_model.dart';

class HabitDao {
  static final HabitDao instance = HabitDao._internal();
  Database? _database;

  HabitDao._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ciantis_habits.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE habits (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT,
            frequency TEXT NOT NULL,
            targetDays TEXT,
            streakCount INTEGER NOT NULL,
            lastCompletedDate INTEGER,
            createdAt INTEGER NOT NULL,
            updatedAt INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // -----------------------------
  // INSERT HABIT
  // -----------------------------
  Future<void> insertHabit(HabitModel habit) async {
    final db = await database;

    await db.insert(
      'habits',
      habit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // -----------------------------
  // UPDATE HABIT
  // -----------------------------
  Future<void> updateHabit(HabitModel habit) async {
    final db = await database;

    await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  // -----------------------------
  // DELETE HABIT
  // -----------------------------
  Future<void> deleteHabit(String id) async {
    final db = await database;

    await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // -----------------------------
  // GET ALL HABITS
  // -----------------------------
  Future<List<HabitModel>> getAllHabits() async {
    final db = await database;

    final maps = await db.query(
      'habits',
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => HabitModel.fromMap(map)).toList();
  }

  // -----------------------------
  // GET HABIT BY ID
  // -----------------------------
  Future<HabitModel?> getHabitById(String id) async {
    final db = await database;

    final maps = await db.query(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return HabitModel.fromMap(maps.first);
  }
}
