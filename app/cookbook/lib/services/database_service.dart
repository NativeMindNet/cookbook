import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _db;
  final Completer<void> _initCompleter = Completer<void>();

  Future<Database> get database async {
    if (_db != null) return _db!;
    await _initCompleter.future;
    return _db!;
  }

  Future<void> init() async {
    if (_db != null) return;

    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'cookbook.db');

      // For development: delete database to re-create with new schema
      // await deleteDatabase(path); 

      print('Initializing database at $path');

      _db = await openDatabase(
        path,
        version: 2,
        onCreate: (db, version) async {
          print('Creating database...');
          await _runSqlFile(db, 'assets/db/migrations/001_init.sql');
          await _runSqlFile(db, 'assets/db/seeds/001_seed.sql');
          print('Database created and seeded.');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            print('Upgrading database $oldVersion -> $newVersion');
            await _runSqlFile(db, 'assets/db/migrations/002_upgrade_to_v2.sql');
          }
        },
      );
      _initCompleter.complete();
    } catch (e) {
      print('Database Init Error: $e');
      _initCompleter.completeError(e);
      rethrow;
    }
  }

  Future<void> _runSqlFile(Database db, String assetPath) async {
    print('Running SQL file: $assetPath');
    final sqlContent = await rootBundle.loadString(assetPath);
    
    // Improved splitting: match semicolon followed by newline or end of string
    // This avoids splitting inside strings if they don't contain ;\n
    final statements = sqlContent
        .split(RegExp(r';\s*\n'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    for (var statement in statements) {
      // Remove comments and clean up
      statement = statement.replaceAll(RegExp(r'--.*'), '').trim();
      if (statement.isEmpty) continue;
      
      try {
        await db.execute(statement);
      } catch (e) {
        print('Error executing statement: $statement');
        print('Error: $e');
        rethrow;
      }
    }
  }
}
