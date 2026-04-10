import 'package:sqflite/sqflite.dart';
import '../models/routine_model.dart';
import 'dart:convert';

class RoutineDao {
  final Database db;

  RoutineDao(this.db);

  static const String tableName = "routines";

  static const String createTableQuery = """
    CREATE TABLE IF NOT EXISTS $tableName (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT,
      category TEXT NOT NULL,
      isActive INTEGER NOT NULL,
      emotionalLoad INTEGER NOT NULL,
      fatigueImpact INTEGER NOT NULL,
      steps TEXT NOT NULL,
      streak INTEGER NOT NULL,
      lastCompletedAt TEXT,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL
    );
  """;

  // Insert
  Future<void> insert(RoutineModel routine) async {
    await db.insert(
      tableName,
      routine.toMap()..["steps"] = jsonEncode(routine.steps.map((s) => s.toMap()).toList()),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update
  Future<void> update(RoutineModel routine) async {
    await db.update(
      tableName,
      routine.toMap()..["steps"] = jsonEncode(routine.steps.map((s) => s.toMap()).toList()),
      where: "id = ?",
      whereArgs: [routine.id],
    );
  }

  // Delete
  Future<void> delete(String id) async {
    await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Get by ID
  Future<RoutineModel?> getById(String id) async {
    final result = await db.query(
      tableName,
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    final map = result.first;
    final stepsJson = jsonDecode(map["steps"]);
    map["steps"] = stepsJson;

    return RoutineModel.fromMap(map);
  }

  // Get all routines
  Future<List<RoutineModel>> getAll() async {
    final result = await db.query(
      tableName,
      orderBy: "createdAt DESC",
    );

    return result.map((map) {
      final stepsJson = jsonDecode(map["steps"]);
      map["steps"] = stepsJson;
      return RoutineModel.fromMap(map);
    }).toList();
  }

  // Get active routines
  Future<List<RoutineModel>> getActive() async {
    final result = await db.query(
      tableName,
      where: "isActive = ?",
      whereArgs: [1],
      orderBy: "createdAt DESC",
    );

    return result.map((map) {
      final stepsJson = jsonDecode(map["steps"]);
      map["steps"] = stepsJson;
      return RoutineModel.fromMap(map);
    }).toList();
  }

  // Update streak
  Future<void> updateStreak(String id, int streak, DateTime? lastCompletedAt) async {
    await db.update(
      tableName,
      {
        "streak": streak,
        "lastCompletedAt": lastCompletedAt?.toIso8601String(),
        "updatedAt": DateTime.now().toIso8601String(),
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
