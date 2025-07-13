import 'dart:async';
import 'package:path/path.dart'; // CORRECTED IMPORT
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "QuitCompanion.db";
  static const _databaseVersion = 1;

  // --- TABLE DEFINITIONS ---
  static const tableSettings = 'settings';
  static const tableReasons = 'reasons';
  static const tableDailyCheckins = 'daily_checkins';
  static const tableUrges = 'urges';
  static const tableJournalEntries = 'journal_entries';
  static const tableGoals = 'goals';
  static const tableGoalSubtasks = 'goal_subtasks';
  static const tableResources = 'resources';

  // --- Singleton Pattern ---
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // --- Initialize Database ---
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // --- SQL CREATE Statements ---
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableSettings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
      ''');
    await db.execute('''
      CREATE TABLE $tableReasons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        statement TEXT NOT NULL
      )
      ''');
    await db.execute('''
      CREATE TABLE $tableDailyCheckins (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL UNIQUE,
        relapsed INTEGER NOT NULL,
        urgeLevel INTEGER NOT NULL,
        mood TEXT NOT NULL,
        triggers TEXT,
        positiveActions TEXT,
        score INTEGER NOT NULL
      )
      ''');
    await db.execute('''
      CREATE TABLE $tableUrges (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT NOT NULL,
        intensity INTEGER NOT NULL,
        trigger TEXT,
        resolution TEXT NOT NULL,
        notes TEXT
      )
      ''');
    await db.execute('''
      CREATE TABLE $tableJournalEntries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT NOT NULL,
        content TEXT NOT NULL,
        mood TEXT,
        template TEXT
      )
      ''');
    await db.execute('''
      CREATE TABLE $tableGoals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER NOT NULL DEFAULT 0
      )
      ''');
    await db.execute('''
      CREATE TABLE $tableGoalSubtasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        goalId INTEGER NOT NULL,
        task TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (goalId) REFERENCES $tableGoals (id) ON DELETE CASCADE
      )
      ''');
    await db.execute('''
      CREATE TABLE $tableResources (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        instruction TEXT NOT NULL
      )
      ''');
  }

  // --- Generic CRUD Helpers ---
  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table,
      {String? orderBy}) async {
    Database db = await instance.database;
    return await db.query(table, orderBy: orderBy);
  }

  Future<int> update(String table, Map<String, dynamic> row, String whereColumn,
      var whereArg) async {
    Database db = await instance.database;
    return await db
        .update(table, row, where: '$whereColumn = ?', whereArgs: [whereArg]);
  }

  Future<int> delete(String table, String whereColumn, var whereArg) async {
    Database db = await instance.database;
    return await db
        .delete(table, where: '$whereColumn = ?', whereArgs: [whereArg]);
  }

  Future<Map<String, dynamic>?> queryRow(
      String table, String whereColumn, var whereArg) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result =
        await db.query(table, where: '$whereColumn = ?', whereArgs: [whereArg]);
    return result.isNotEmpty ? result.first : null;
  }
}
