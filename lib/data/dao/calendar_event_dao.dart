import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/calendar_event_model.dart';

class CalendarEventDao {
  static final CalendarEventDao instance = CalendarEventDao._internal();
  Database? _database;

  CalendarEventDao._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ciantis_calendar.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE calendar_events (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT,
            startTime INTEGER NOT NULL,
            endTime INTEGER NOT NULL,
            category TEXT NOT NULL,
            isAllDay INTEGER NOT NULL,
            location TEXT,
            emotionalLoad INTEGER NOT NULL,
            fatigueImpact INTEGER NOT NULL,
            createdAt INTEGER NOT NULL,
            updatedAt INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // -----------------------------
  // INSERT EVENT
  // -----------------------------
  Future<void> insertEvent(CalendarEventModel event) async {
    final db = await database;

    await db.insert(
      'calendar_events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // -----------------------------
  // UPDATE EVENT
  // -----------------------------
  Future<void> updateEvent(CalendarEventModel event) async {
    final db = await database;

    await db.update(
      'calendar_events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  // -----------------------------
  // DELETE EVENT
  // -----------------------------
  Future<void> deleteEvent(String id) async {
    final db = await database;

    await db.delete(
      'calendar_events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // -----------------------------
  // GET ALL EVENTS
  // -----------------------------
  Future<List<CalendarEventModel>> getAllEvents() async {
    final db = await database;

    final maps = await db.query(
      'calendar_events',
      orderBy: 'startTime ASC',
    );

    return maps.map((map) => CalendarEventModel.fromMap(map)).toList();
  }

  // -----------------------------
  // GET EVENT BY ID
  // -----------------------------
  Future<CalendarEventModel?> getEventById(String id) async {
    final db = await database;

    final maps = await db.query(
      'calendar_events',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return CalendarEventModel.fromMap(maps.first);
  }

  // -----------------------------
  // GET EVENTS IN DATE RANGE
  // -----------------------------
  Future<List<CalendarEventModel>> getEventsInRange(
      DateTime start, DateTime end) async {
    final db = await database;

    final maps = await db.query(
      'calendar_events',
      where: 'startTime >= ? AND endTime <= ?',
      whereArgs: [
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      ],
      orderBy: 'startTime ASC',
    );

    return maps.map((map) => CalendarEventModel.fromMap(map)).toList();
  }
}
