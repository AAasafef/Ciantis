import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../models/client_model.dart';

class ClientDao {
  static const String table = 'clients';

  // -----------------------------
  // CREATE TABLE
  // -----------------------------
  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT,
        email TEXT,
        notes TEXT,
        preferredServices TEXT,
        lastAppointment TEXT,
        totalVisits INTEGER NOT NULL,
        rankingScore INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  // -----------------------------
  // INSERT CLIENT
  // -----------------------------
  Future<void> insertClient(ClientModel client) async {
    final db = await AppDatabase.instance.database;

    await db.insert(
      table,
      client.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // -----------------------------
  // UPDATE CLIENT
  // -----------------------------
  Future<void> updateClient(ClientModel client) async {
    final db = await AppDatabase.instance.database;

    await db.update(
      table,
      client.toMap(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  // -----------------------------
  // DELETE CLIENT
  // -----------------------------
  Future<void> deleteClient(String id) async {
    final db = await AppDatabase.instance.database;

    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // -----------------------------
  // GET ALL CLIENTS
  // -----------------------------
  Future<List<ClientModel>> getAllClients() async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      table,
      orderBy: 'name ASC',
    );

    return maps.map((m) => ClientModel.fromMap(m)).toList();
  }

  // -----------------------------
  // GET CLIENT BY ID
  // -----------------------------
  Future<ClientModel?> getClientById(String id) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return ClientModel.fromMap(maps.first);
  }

  // -----------------------------
  // SEARCH CLIENTS
  // -----------------------------
  Future<List<ClientModel>> searchClients(String query) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      table,
      where: '''
        name LIKE ? OR 
        phone LIKE ? OR 
        email LIKE ?
      ''',
      whereArgs: [
        '%$query%',
        '%$query%',
        '%$query%',
      ],
      orderBy: 'name ASC',
    );

    return maps.map((m) => ClientModel.fromMap(m)).toList();
  }

  // -----------------------------
  // SORT BY RANKING SCORE
  // -----------------------------
  Future<List<ClientModel>> getTopRankedClients() async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      table,
      orderBy: 'rankingScore DESC',
    );

    return maps.map((m) => ClientModel.fromMap(m)).toList();
  }
}
