import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../models/routine_model.dart';

class RoutineDao {
  static const String routinesTable = 'routines';
  static const String stepsTable = 'routine_steps';

  // -----------------------------
  // CREATE TABLES
  // -----------------------------
  Future<void> createTables(Database db) async {
    // Routines table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $routinesTable (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        priority INTEGER NOT NULL,
        emotionalLoad INTEGER NOT NULL,
        fatigueImpact INTEGER NOT NULL,
        active INTEGER NOT NULL,
        streak INTEGER NOT NULL,
        lastCompletedDate TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Routine steps table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $stepsTable (
        id TEXT PRIMARY KEY,
        routineId TEXT NOT NULL,
        title TEXT NOT NULL,
        stepOrder INTEGER NOT NULL,
        durationMinutes INTEGER NOT NULL,
        emotionalLoad INTEGER NOT NULL,
        fatigueImpact INTEGER NOT NULL,
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
      {
        'id': routine.id,
        'title': routine.title,
        'description': routine.description,
        'category': routine.category,
        'priority': routine.priority,
        'emotionalLoad': routine.emotionalLoad,
        'fatigueImpact': routine.fatigueImpact,
        'active': routine.active ? 1 : 0,
        'streak': routine.streak,
        'lastCompletedDate': routine.lastCompletedDate?.toIso8601String(),
        'createdAt': routine.createdAt.toIso8601String(),
        'updatedAt': routine.updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Insert steps
    for (final step in routine.steps) {
      await db.insert(
        stepsTable,
        {
          'id': step.id,
          'routineId': routine.id,
          'title': step.title,
          'stepOrder': step.order,
          'durationMinutes': step.durationMinutes,
          'emotionalLoad': step.emotionalLoad,
          'fatigueImpact': step.fatigueImpact,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // -----------------------------
  // UPDATE ROUTINE
  // -----------------------------
  Future<void> updateRoutine(RoutineModel routine) async {
    final db = await AppDatabase.instance.database;

    await db.update(
      routinesTable,
      {
        'title': routine.title,
        'description': routine.description,
        'category': routine.category,
        'priority': routine.priority,
        'emotionalLoad': routine.emotionalLoad,
        'fatigueImpact': routine.fatigueImpact,
        'active': routine.active ? 1 : 0,
        'streak': routine.streak,
        'lastCompletedDate': routine.lastCompletedDate?.toIso8601String(),
        'updatedAt': routine.updatedAt.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [routine.id],
    );

    // Delete old steps
    await db.delete(
      stepsTable,
      where: 'routineId = ?',
      whereArgs: [routine.id],
    );

    // Insert updated steps
    for (final step in routine.steps) {
      await db.insert(
        stepsTable,
        {
          'id': step.id,
          'routineId': routine.id,
          'title': step.title,
          'stepOrder': step.order,
          'durationMinutes': step.durationMinutes,
          'emotionalLoad': step.emotionalLoad,
          'fatigueImpact': step.fatigueImpact,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // -----------------------------
  // DELETE ROUTINE
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

    final routineMaps = await db.query(
      routinesTable,
      orderBy: 'createdAt DESC',
    );

    List<RoutineModel> routines = [];

    for (final map in routineMaps) {
      final steps = await getStepsForRoutine(map['id']);
      routines.add(
        RoutineModel.fromMap({
          ...map,
          'steps': steps.map((e) => e.toMap()).toList(),
        }),
      );
    }

    return routines;
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

    final steps = await getStepsForRoutine(id);

    return RoutineModel.fromMap({
      ...maps.first,
      'steps': steps.map((e) => e.toMap()).toList(),
    });
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
      orderBy: 'stepOrder ASC',
    );

    return maps.map((m) => RoutineStepModel.fromMap(m)).toList();
  }
}
