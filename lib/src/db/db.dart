import 'package:jacked/src/db/seeds.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'jacked.db');

    await deleteDatabase(path);

    _db = await openDatabase(path, version: 1, onCreate: onCreate);

    return _db!;
  }
}

Future<void> onCreate(Database db, int version) async {
  await initExercisesTable(db);
  await initWorkoutTable(db);
}

Future<void> initExercisesTable(Database db) async {
  await db.execute('''
    CREATE TABLE Exercises (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      key TEXT NOT NULL UNIQUE
    );
  ''');
  for (final exercise in seedExercises) {
    await db.execute(
      'INSERT OR IGNORE INTO Exercises (id, key) VALUES (?, ?)',
      [exercise.id, exercise.key],
    );
  }
}

Future<void> initWorkoutTable(Database db) async {}
