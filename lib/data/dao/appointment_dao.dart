import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../models/appointment_model.dart';

class AppointmentDao {
  static const String table = 'appointments';

  // -----------------------------
  // CREATE TABLE
  // -----------------------------
  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        location TEXT,
        category TEXT NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT NOT NULL,
        emotionalLoad INTEGER NOT NULL,
        fatigueImpact INTEGER NOT NULL,
        isCompleted INTEGER NOT NULL,
        reminderEnabled INTEGER NOT NULL,
        reminderMinutesBefore INTEGER,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  // -----------------------------
  // INSERT
  // -----------------------------
  Future<void> insertAppointment(AppointmentModel appt) async {
    final db = await AppDatabase.instance.database;

    await db.insert(
      table,
      appt.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // -----------------------------
  // UPDATE
  // -----------------------------
  Future<void> updateAppointment(AppointmentModel appt) async {
    final db = await AppDatabase.instance.database;

    await db.update(
      table,
      appt.toMap(),
      where: 'id = ?',
      whereArgs: [appt.id],
    );
  }

  // -----------------------------
  // DELETE
  // -----------------------------
  Future<void> deleteAppointment(String id) async {
    final db = await AppDatabase.instance.database;

    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // -----------------------------
  // GET ALL
  // -----------------------------
  Future<List<AppointmentModel>> getAllAppointments() async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      table,
      orderBy: 'startTime ASC',
    );

    return maps.map((m) => AppointmentModel.fromMap(m)).toList();
  }

  // -----------------------------
  // GET BY DATE
  // -----------------------------
  Future<List<AppointmentModel>> getAppointmentsByDate(DateTime date) async {
    final db = await AppDatabase.instance.database;

    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final maps = await db.query(
      table,
      where: 'startTime >= ? AND startTime < ?',
      whereArgs: [
        start.toIso8601String(),
        end.toIso8601String(),
      ],
      orderBy: 'startTime ASC',
    );

    return maps.map((m) => AppointmentModel.fromMap(m)).toList();
  }

  // -----------------------------
  // UPCOMING APPOINTMENTS
  // -----------------------------
  Future<List<AppointmentModel>> getUpcomingAppointments() async {
    final db = await AppDatabase.instance.database;

    final now = DateTime.now().toIso8601String();

    final maps = await db.query(
      table,
      where: 'startTime >= ?',
      whereArgs: [now],
      orderBy: 'startTime ASC',
    );

    return maps.map((m) => AppointmentModel.fromMap(m)).toList();
  }

  // -----------------------------
  // SEARCH
  // -----------------------------
  Future<List<AppointmentModel>> searchAppointments(String query) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      table,
      where: '''
        title LIKE ? OR 
        description LIKE ? OR 
        location LIKE ?
      ''',
      whereArgs: [
        '%$query%',
        '%$query%',
        '%$query%',
      ],
      orderBy: 'startTime ASC',
    );

    return maps.map((m) => AppointmentModel.fromMap(m)).toList();
  }

  // -----------------------------
  // SORT BY EMOTIONAL LOAD
  // -----------------------------
  Future<List<AppointmentModel>> sortByEmotionalLoad({bool ascending = true}) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      table,
      orderBy: 'emotionalLoad ${ascending ? 'ASC' : 'DESC'}',
    );

    return maps.map((m) => AppointmentModel.fromMap(m)).toList();
  }

  // -----------------------------
  // SORT BY FATIGUE IMPACT
  // -----------------------------
  Future<List<AppointmentModel>> sortByFatigueImpact({bool ascending = true}) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      table,
      orderBy: 'fatigueImpact ${ascending ? 'ASC' : 'DESC'}',
    );

    return maps.map((m) => AppointmentModel.fromMap(m)).toList();
  }
}
