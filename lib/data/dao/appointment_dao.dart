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
        reminderEnabled INTEGER NOT NULL,
        completed INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  // -----------------------------
  // INSERT APPOINTMENT
  // -----------------------------
  Future<void> insertAppointment(AppointmentModel appointment) async {
    final db = await AppDatabase.instance.database;

    await db.insert(
      table,
      appointment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // -----------------------------
  // UPDATE APPOINTMENT
  // -----------------------------
  Future<void> updateAppointment(AppointmentModel appointment) async {
    final db = await AppDatabase.instance.database;

    await db.update(
      table,
      appointment.toMap(),
      where: 'id = ?',
      whereArgs: [appointment.id],
    );
  }

  // -----------------------------
  // DELETE APPOINTMENT
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
  // GET ALL APPOINTMENTS
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
  // GET APPOINTMENT BY ID
  // -----------------------------
  Future<AppointmentModel?> getAppointmentById(String id) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return AppointmentModel.fromMap(maps.first);
  }

  // -----------------------------
  // GET APPOINTMENTS BY DATE
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
  // GET APPOINTMENTS BY CATEGORY
  // -----------------------------
  Future<List<AppointmentModel>> getAppointmentsByCategory(
      String category) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      table,
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'startTime ASC',
    );

    return maps.map((m) => AppointmentModel.fromMap(m)).toList();
  }
}
