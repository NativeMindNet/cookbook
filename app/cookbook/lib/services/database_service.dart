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

      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await _runSqlFile(db, 'assets/db/migrations/001_init.sql');
          await _runSqlFile(db, 'assets/db/seeds/001_seed.sql');
        },
      );
      _initCompleter.complete();
    } catch (e) {
      _initCompleter.completeError(e);
      rethrow;
    }
  }

  Future<void> _runSqlFile(Database db, String assetPath) async {
    final sqlContent = await rootBundle.loadString(assetPath);
    final statements = sqlContent
        .split(';')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty && !s.startsWith('--'))
        .toList();

    for (final statement in statements) {
      await db.execute(statement);
    }
  }
}
