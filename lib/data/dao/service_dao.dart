import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../models/service_category_model.dart';
import '../models/service_model.dart';

class ServiceDao {
  static const String categoryTable = 'service_categories';
  static const String serviceTable = 'services';

  // -----------------------------
  // CREATE TABLES
  // -----------------------------
  Future<void> createTables(Database db) async {
    // Categories table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $categoryTable (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        color TEXT NOT NULL,
        sortOrder INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Services table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $serviceTable (
        id TEXT PRIMARY KEY,
        categoryId TEXT NOT NULL,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        duration INTEGER NOT NULL,
        notes TEXT,
        color TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES $categoryTable (id)
      )
    ''');
  }

  // -----------------------------
  // CATEGORY CRUD
  // -----------------------------
  Future<void> insertCategory(ServiceCategoryModel category) async {
    final db = await AppDatabase.instance.database;
    await db.insert(
      categoryTable,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCategory(ServiceCategoryModel category) async {
    final db = await AppDatabase.instance.database;
    await db.update(
      categoryTable,
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<void> deleteCategory(String id) async {
    final db = await AppDatabase.instance.database;
    await db.delete(
      categoryTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<ServiceCategoryModel>> getAllCategories() async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query(
      categoryTable,
      orderBy: 'sortOrder ASC',
    );
    return maps.map((m) => ServiceCategoryModel.fromMap(m)).toList();
  }

  // -----------------------------
  // SERVICE CRUD
  // -----------------------------
  Future<void> insertService(ServiceModel service) async {
    final db = await AppDatabase.instance.database;
    await db.insert(
      serviceTable,
      service.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateService(ServiceModel service) async {
    final db = await AppDatabase.instance.database;
    await db.update(
      serviceTable,
      service.toMap(),
      where: 'id = ?',
      whereArgs: [service.id],
    );
  }

  Future<void> deleteService(String id) async {
    final db = await AppDatabase.instance.database;
    await db.delete(
      serviceTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<ServiceModel>> getAllServices() async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query(
      serviceTable,
      orderBy: 'name ASC',
    );
    return maps.map((m) => ServiceModel.fromMap(m)).toList();
  }

  Future<List<ServiceModel>> getServicesByCategory(String categoryId) async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query(
      serviceTable,
      where: 'categoryId = ?',
      whereArgs: [categoryId],
      orderBy: 'name ASC',
    );
    return maps.map((m) => ServiceModel.fromMap(m)).toList();
  }

  // -----------------------------
  // SEARCH SERVICES
  // -----------------------------
  Future<List<ServiceModel>> searchServices(String query) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      serviceTable,
      where: '''
        name LIKE ? OR 
        notes LIKE ?
      ''',
      whereArgs: [
        '%$query%',
        '%$query%',
      ],
      orderBy: 'name ASC',
    );

    return maps.map((m) => ServiceModel.fromMap(m)).toList();
  }

  // -----------------------------
  // SORTING
  // -----------------------------
  Future<List<ServiceModel>> sortByPrice({bool ascending = true}) async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query(
      serviceTable,
      orderBy: 'price ${ascending ? 'ASC' : 'DESC'}',
    );
    return maps.map((m) => ServiceModel.fromMap(m)).toList();
  }

  Future<List<ServiceModel>> sortByDuration({bool ascending = true}) async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query(
      serviceTable,
      orderBy: 'duration ${ascending ? 'ASC' : 'DESC'}',
    );
    return maps.map((m) => ServiceModel.fromMap(m)).toList();
  }
}
