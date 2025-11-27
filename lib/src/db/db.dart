import 'package:flutter/foundation.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/exercise_set.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/db/seeds.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class JackedDb {
  static Database? _db;

  static const int _version = 1;
  static const String _databaseName = 'jacked.db';

  static Future<void> onCreate(Database db, int version) async {
    await createTables(db);
    await seedTables(db: db, debug: kDebugMode);
  }

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), _databaseName);
    if (kDebugMode) deleteDatabase(path);
    _db = await openDatabase(path, version: _version, onConfigure: onConfigure, onCreate: onCreate);
    return _db!;
  }

  /// Overrides the database used by the singleton. Use only in tests.
  static void overrideDatabaseForTests(Database? testDb) {
    _db = testDb;
  }
}

Future<void> onConfigure(Database db) async => db.execute('PRAGMA foreign_keys = ON');

Future<void> seedTables({required Database db, required bool debug}) async {
  await seedExercisesTable(db, seedExercises);

  if (debug) {
    await seedWorkoutTable(db, seedWorkouts);
    await seedExerciseEntriesTable(db, seedExerciseEntries);
    await seedExerciseSetsTable(db, seedExerciseSets);
  }
}

Future<void> createTables(Database db) async {
  await db.execute('''
    CREATE TABLE Exercises (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      key TEXT NOT NULL UNIQUE
    );
  ''');

  await db.execute('''
    CREATE TABLE Workouts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      startTime INTEGER NOT NULL,
      endTime INTEGER,
      description TEXT
    );
  ''');

  await db.execute('''
    CREATE TABLE ExerciseEntries (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      workoutId INTEGER NOT NULL,
      exerciseId INTEGER NOT NULL,
      FOREIGN KEY (workoutId) REFERENCES Workouts(id) ON DELETE CASCADE,
      FOREIGN KEY (exerciseId) REFERENCES Exercises(id) ON DELETE CASCADE
    );
  ''');

  await db.execute('''
    CREATE TABLE ExerciseSets (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      exerciseEntryId INTEGER NOT NULL,
      reps INTEGER,
      weight REAL,
      duration INTEGER,
      rpe INTEGER,
      FOREIGN KEY (exerciseEntryId) REFERENCES ExerciseEntries(id) ON DELETE CASCADE
    );
  ''');
}

Future<void> seedExercisesTable(Database db, List<Exercise> seedExercises) async {
  for (final exercise in seedExercises) {
    await db.execute(
      'INSERT OR IGNORE INTO Exercises (id, key) VALUES (?, ?)',
      [
        exercise.id,
        exercise.key,
      ],
    );
  }
}

Future<void> seedWorkoutTable(Database db, List<Workout> seedWorkouts) async {
  for (final workout in seedWorkouts) {
    await db.execute(
      '''
      INSERT OR IGNORE INTO Workouts (
        title,
        startTime,
        endTime,
        description
      )
      VALUES (?, ?, ?, ?)
      ''',
      [
        workout.title,
        workout.startTime.microsecondsSinceEpoch,
        workout.endTime?.microsecondsSinceEpoch,
        workout.description,
      ],
    );
  }
}

Future<void> seedExerciseEntriesTable(Database db, List<ExerciseEntry> seedExerciseEntries) async {
  for (final exerciseEntry in seedExerciseEntries) {
    await db.execute(
      '''
      INSERT OR IGNORE INTO ExerciseEntries (
        workoutId,
        exerciseId
      )
      VALUES (?, ?)
      ''',
      [
        exerciseEntry.workoutId,
        exerciseEntry.exerciseId,
      ],
    );
  }
}

Future<void> seedExerciseSetsTable(Database db, List<ExerciseSet> seedExerciseSets) async {
  for (final exerciseSet in seedExerciseSets) {
    await db.execute(
      '''
    INSERT OR IGNORE INTO ExerciseSets (
      exerciseEntryId,
      reps,
      weight,
      duration,
      rpe
    )
    VALUES (?, ?, ?, ?, ?)
    ''',
      [
        exerciseSet.exerciseEntryId,
        exerciseSet.reps,
        exerciseSet.weight,
        exerciseSet.duration?.inSeconds,
        exerciseSet.rpe,
      ],
    );
  }
}
