import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/models/workout.dart';
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
  await initExercisesTable(db, seedExercises);
  await initWorkoutTable(db, seedWorkouts);
}

Future<void> initExercisesTable(Database db, List<Exercise> seedExercises) async {
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

Future<void> initWorkoutTable(Database db, List<Workout> seedWorkouts) async {
  await db.execute('''
    CREATE TABLE Workout (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      startTime INTEGER NOT NULL,  
      endTime INTEGER,            
      description TEXT  
    );
  ''');
  for (final workout in seedWorkouts) {
    await db.execute(
      'INSERT OR IGNORE INTO Workout (title, startTime) VALUES (?, ?)',
      [workout.title, workout.startTime.microsecondsSinceEpoch],
    );
  }
}
