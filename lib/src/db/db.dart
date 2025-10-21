import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/exercise_set.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/db/seeds.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class JackedDatabase {
  static Database? _db;

  static const int _version = 1;
  static const String _databaseName = 'jacked.db';

  static Future<Database> get database async {
    if (_db != null) return _db!;

    final path = join(await getDatabasesPath(), _databaseName);

    _db = await openDatabase(path, version: _version, onConfigure: onConfigure, onCreate: onCreate);

    return _db!;
  }

  static Future<void> init() async {
    final path = join(await getDatabasesPath(), _databaseName);
    _db = await openDatabase(path, version: 1, onConfigure: onConfigure, onCreate: onCreate);
  }
}

Future<void> onConfigure(Database db) async => db.execute('PRAGMA foreign_keys = ON');

Future<void> onCreate(Database db, int version) async {
  await initExercisesTable(db, seedExercises);
  await initWorkoutTable(db, seedWorkouts);
  await initExerciseEntriesTable(db, seedExerciseEntries);
  await initExerciseSetsTable(db, seedExerciseSets);
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
    CREATE TABLE Workouts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      startTime INTEGER NOT NULL,  
      endTime INTEGER,            
      description TEXT  
    );
  ''');
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

Future<void> initExerciseEntriesTable(Database db, List<ExerciseEntry> seedExerciseEntries) async {
  await db.execute('''
  CREATE TABLE ExerciseEntries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    workoutId INTEGER NOT NULL,
    exerciseId INTEGER NOT NULL,
    FOREIGN KEY (workoutId) REFERENCES Workouts(id) ON DELETE CASCADE,
    FOREIGN KEY (exerciseId) REFERENCES Exercises(id) ON DELETE CASCADE
  )
  ''');
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

Future<void> initExerciseSetsTable(Database db, List<ExerciseSet> seedExerciseSets) async {
  await db.execute('''
  CREATE TABLE ExerciseSets (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    exerciseEntryId INTEGER NOT NULL,
    reps INTEGER,
    weight REAL,
    duration INTEGER,
    rpe INTEGER,
    FOREIGN KEY (exerciseEntryId) REFERENCES ExerciseEntries(id) ON DELETE CASCADE
  )
  ''');
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
