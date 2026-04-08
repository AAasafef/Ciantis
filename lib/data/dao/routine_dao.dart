import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/routine_model.dart';

class RoutineDao {
  static final RoutineDao instance = RoutineDao._internal();
  Database? _database;

  RoutineDao._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ciantis_routines.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // ROUTINES TABLE
        await db.execute('''
          CREATE TABLE routines (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT,
            category TEXT NOT NULL,
            createdAt INTEGER NOT NULL,
            updatedAt INTEGER NOT NULL
          )
        ''');

        // ROUTINE STEPS TABLE
        await db.execute('''
          CREATE TABLE routine_steps (
            id TEXT PRIMARY KEY,
            routineId TEXT NOT NULL,
            title TEXT NOT NULL,
            durationMinutes INTEGER,
            isCompleted INTEGER NOT NULL,
            emotionalNote TEXT,
            stepOrder INTEGER NOT NULL,
            FOREIGN KEY (routineId) REFERENCES routines (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  // -----------------------------
  // INSERT ROUTINE + STEPS
  // -----------------------------
  Future<void> insertRoutine(RoutineModel routine) async {
    final db = await database;

    await db.insert(
      'routines',
      {
        'id': routine.id,
        'title': routine.title,
        'description': routine.description,
        'category': routine.category,
        'createdAt': routine.createdAt.millisecondsSinceEpoch,
        'updatedAt': routine.updatedAt.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    for (var step in routine.steps) {
      await db.insert(
        'routine_steps',
        {
          'id': step.id,
          'routineId': routine.id,
          'title': step.title,
          'durationMinutes': step.durationMinutes,
          'isCompleted': step.isCompleted ? 1 : 0,
          'emotionalNote': step.emotionalNote,
          'stepOrder': step.order,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // -----------------------------
  // UPDATE ROUTINE + STEPS
  // -----------------------------
  Future<void> updateRoutine(RoutineModel routine) async {
    final db = await database;

    await db.update(
      'routines',
      {
        'title': routine.title,
        'description': routine.description,
        'category': routine.category,
        'updatedAt': routine.updatedAt.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [routine.id],
    );

    // Delete old steps
    await db.delete(
      'routine_steps',
      where: 'routineId = ?',
      whereArgs: [routine.id],
    );

    // Insert updated steps
    for (var step in routine.steps) {
      await db.insert(
        'routine_steps',
        {
          'id': step.id,
          'routineId': routine.id,
          'title': step.title,
          'durationMinutes': step.durationMinutes,
          'isCompleted': step.isCompleted ? 1 : 0,
          'emotionalNote': step.emotionalNote,
          'stepOrder': step.order,
        },
      );
    }
  }

  // -----------------------------
  // DELETE ROUTINE + STEPS
  // -----------------------------
  Future<void> deleteRoutine(String id) async {
    final db = await database;

    await db.delete(
      'routine_steps',
      where: 'routineId = ?',
      whereArgs: [id],
    );

    await db.delete(
      'routines',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // -----------------------------
  // GET ALL ROUTINES
  // -----------------------------
  Future<List<RoutineModel>> getAllRoutines() async {
    final db = await database;

    final routineMaps = await db.query(
      'routines',
      orderBy: 'createdAt DESC',
    );

    List<RoutineModel> routines = [];

    for (var map in routineMaps) {
      final steps = await _getStepsForRoutine(map['id']);
      routines.add(
        RoutineModel(
          id: map['id'],
          title: map['title'],
          description: map['description'],
          category: map['category'],
          steps: steps,
          createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
          updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
        ),
      );
    }

    return routines;
  }

  // -----------------------------
  // GET ROUTINE BY ID
  // -----------------------------
  Future<RoutineModel?> getRoutineById(String id) async {
    final db = await database;

    final maps = await db.query(
      'routines',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    final steps = await _getStepsForRoutine(id);

    final map = maps.first;

    return RoutineModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      steps: steps,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  // -----------------------------
  // GET STEPS FOR ROUTINE
  // -----------------------------
  Future<List<RoutineStep>> _getStepsForRoutine(String routineId) async {
    final db = await database;

    final maps = await db.query(
      'routine_steps',
      where: 'routineId = ?',
      whereArgs: [routineId],
      orderBy: 'stepOrder ASC',
    );

    return maps.map((map) {
      return RoutineStep(
        id: map['id'],
        title: map['title'],
        durationMinutes: map['durationMinutes'],
        isCompleted: map['isCompleted'] == 1,
        emotionalNote: map['emotionalNote'],
        order: map['stepOrder'],
      );
    }).toList();
  }
}
