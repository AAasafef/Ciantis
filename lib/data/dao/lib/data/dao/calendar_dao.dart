import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';

class CalendarDao {
  static const String table = 'calendar_meta';

  // -----------------------------
  // CREATE TABLE
  // -----------------------------
  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        note TEXT,
        tag TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  // -----------------------------
  // INSERT META
  // -----------------------------
  Future<void> insertMeta(Map<String, dynamic> meta) async {
    final db = await AppDatabase.instance.database;

    await db.insert(
      table,
      meta,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // -----------------------------
  // UPDATE META
  // -----------------------------
  Future<void> updateMeta(Map<String, dynamic> meta) async {
    final db = await AppDatabase.instance.database;

    await db.update(
      table,
      meta,
      where: 'id = ?',
      whereArgs: [meta['id']],
    );
  }

  // -----------------------------
  // DELETE META
  // -----------------------------
  Future<void> deleteMeta(String id) async {
    final db = await AppDatabase.instance.database;

    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // -----------------------------
  // GET META FOR DATE
  // -----------------------------
  Future<Map<String, dynamic>?> getMetaForDate(DateTime date) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      table,
      where: 'date = ?',
      whereArgs: [DateTime(date.year, date.month, date.day).toIso8601String()],
    );

    if (maps.isEmpty) return null;

    return maps.first;
  }

  // -----------------------------
  // GET ALL META
  // -----------------------------
  Future<List<Map<String, dynamic>>> getAllMeta() async {
    final db = await AppDatabase.instance.database;

    return await db.query(
      table,
      orderBy: 'date ASC',
    );
  }
}
