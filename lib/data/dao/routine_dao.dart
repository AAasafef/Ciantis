import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../models/routine_model.dart';
import '../models/routine_step_model.dart';

class RoutineDao {
  static const String routinesTable = 'routines';
  static const String stepsTable = 'routine_steps';

  // -----------------------------
  // CREATE TABLES
  // -----------------------------
  Future<void> createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $routinesTable (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        emotionalLoad INTEGER NOT NULL,
        fatigueImpact INTEGER NOT NULL,
        estimatedDuration INTEGER NOT NULL,
        streak INTEGER NOT NULL,
        lastCompleted TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $stepsTable (
        id TEXT PRIMARY KEY,
        routineId TEXT NOT NULL,
        title TEXT NOT NULL,
        duration INTEGER NOT NULL,
        emotionalLoad INTEGER NOT NULL,
        fatigueImpact INTEGER NOT NULL,
        orderIndex INTEGER NOT NULL,
        completed INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (routineId) REFERENCES $routinesTable(id) ON DELETE CASCADE
      )
    ''');
  }

  // -----------------------------
  // INSERT ROUTINE
  // -----------------------------
  Future<void> insertRoutine(RoutineModel routine) async {
    final db = await AppDatabase.instance.database;

    await db.insert(
      routinesTable,
      routine.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // -----------------------------
  // UPDATE ROUTINE
  // -----------------------------
  Future<void> updateRoutine(RoutineModel routine) async {
    final db = await AppDatabase.instance.database;

    await db.update(
      routinesTable,
      routine.toMap(),
      where: 'id = ?',
      whereArgs: [routine.id],
    );
  }

  // -----------------------------
  // DELETE ROUTINE (CASCADE STEPS)
  // -----------------------------
  Future<void> deleteRoutine(String id) async {
    final db = await AppDatabase.instance.database;

    await db.delete(
      routinesTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    await db.delete(
      stepsTable,
      where: 'routineId = ?',
      whereArgs: [id],
    );
  }

  // -----------------------------
  // GET ALL ROUTINES
  // -----------------------------
  Future<List<RoutineModel>> getAllRoutines() async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      routinesTable,
      orderBy: 'createdAt DESC',
    );

    return maps.map((m) => RoutineModel.fromMap(m)).toList();
  }

  // -----------------------------
  // GET ROUTINE BY ID
  // -----------------------------
  Future<RoutineModel?> getRoutineById(String id) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      routinesTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return RoutineModel.fromMap(maps.first);
  }

  // -----------------------------
  // INSERT STEP
  // -----------------------------
  Future<void> insertStep(RoutineStepModel step) async {
    final db = await AppDatabase.instance.database;

    await db.insert(
      stepsTable,
      step.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // -----------------------------
  // UPDATE STEP
  // -----------------------------
  Future<void> updateStep(RoutineStepModel step) async {
    final db = await AppDatabase.instance.database;

    await db.update(
      stepsTable,
      step.toMap(),
      where: 'id = ?',
      whereArgs: [step.id],
    );
  }

  // -----------------------------
  // DELETE STEP
  // -----------------------------
  Future<void> deleteStep(String id) async {
    final db = await AppDatabase.instance.database;

    await db.delete(
      stepsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // -----------------------------
  // GET STEPS FOR ROUTINE
  // -----------------------------
  Future<List<RoutineStepModel>> getStepsForRoutine(String routineId) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      stepsTable,
      where: 'routineId = ?',
      whereArgs: [routineId],
      orderBy: 'orderIndex ASC',
    );

    return maps.map((m) => RoutineStepModel.fromMap(m)).toList();
  }
}
