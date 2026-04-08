import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../models/notification_model.dart';

class NotificationDao {
  static const String table = 'notifications';

  // -----------------------------
  // CREATE TABLE
  // -----------------------------
  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        scheduledTime TEXT NOT NULL,
        type TEXT NOT NULL,
        linkedId TEXT,
        delivered INTEGER NOT NULL,
        read INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  // -----------------------------
  // INSERT NOTIFICATION
  // -----------------------------
  Future<void> insertNotification(NotificationModel notification) async {
    final db = await AppDatabase.instance.database;

    await db.insert(
      table,
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // -----------------------------
  // UPDATE NOTIFICATION
  // -----------------------------
  Future<void> updateNotification(NotificationModel notification) async {
    final db = await AppDatabase.instance.database;

    await db.update(
      table,
      notification.toMap(),
      where: 'id = ?',
      whereArgs: [notification.id],
    );
  }

  // -----------------------------
  // DELETE NOTIFICATION
  // -----------------------------
  Future<void> deleteNotification(String id) async {
    final db = await AppDatabase.instance.database;

    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // -----------------------------
  // GET ALL NOTIFICATIONS
  // -----------------------------
  Future<List<NotificationModel>> getAllNotifications() async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      table,
      orderBy: 'scheduledTime ASC',
    );

    return maps.map((m) => NotificationModel.fromMap(m)).toList();
  }

  // -----------------------------
  // GET UNREAD NOTIFICATIONS
  // -----------------------------
  Future<List<NotificationModel>> getUnreadNotifications() async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      table,
      where: 'read = 0',
      orderBy: 'scheduledTime ASC',
    );

    return maps.map((m) => NotificationModel.fromMap(m)).toList();
  }

  // -----------------------------
  // GET UPCOMING NOTIFICATIONS
  // -----------------------------
  Future<List<NotificationModel>> getUpcomingNotifications() async {
    final db = await AppDatabase.instance.database;

    final now = DateTime.now().toIso8601String();

    final maps = await db.query(
      table,
      where: 'scheduledTime >= ? AND delivered = 0',
      whereArgs: [now],
      orderBy: 'scheduledTime ASC',
    );

    return maps.map((m) => NotificationModel.fromMap(m)).toList();
  }

  // -----------------------------
  // GET NOTIFICATIONS BY LINKED ENTITY
  // -----------------------------
  Future<List<NotificationModel>> getNotificationsByLinkedId(
      String linkedId) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      table,
      where: 'linkedId = ?',
      whereArgs: [linkedId],
      orderBy: 'scheduledTime ASC',
    );

    return maps.map((m) => NotificationModel.fromMap(m)).toList();
  }
}
