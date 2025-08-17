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

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: onCreate,
    );

    return _db!;
  }
}

Future<void> onCreate(Database db, int version) async {
  await db.execute('''
    CREATE TABLE Exercises (
      id SERIAL PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      description TEXT
    );
  ''');
  for (final exercise in seedExercises) {
    await db.execute(
      'INSERT OR IGNORE INTO Exercises (id, name, description) VALUES (?, ?, ?)',
      [exercise.id, exercise.name, exercise.description],
    );
  }
}
