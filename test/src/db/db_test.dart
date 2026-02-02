import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/db.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/exercise_set.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/db/seeds.dart';
import 'package:jacked/src/db/services/exercise_entry_service.dart';
import 'package:jacked/src/db/services/exercise_service.dart';
import 'package:jacked/src/db/services/exercise_set_service.dart';
import 'package:jacked/src/db/services/workout_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../fixtures.dart';
import '../../test_config.dart';

void main() {
  late Database testDb;
  late ExerciseService exerciseSvc;
  late ExerciseEntryService exerciseEntrySvc;
  late ExerciseSetService exerciseSetSvc;
  late WorkoutService workoutSvc;

  setupTestDatabase();

  Future<Database> dbSetUp({required Future<void> Function(Database, int) onCreate}) async {
    testDb = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: onCreate,
    );
    JackedDb.overrideDatabaseForTests(testDb);
    exerciseSvc = await ExerciseService.instance;
    exerciseEntrySvc = await ExerciseEntryService.instance;
    exerciseSetSvc = await ExerciseSetService.instance;
    workoutSvc = await WorkoutService.instance;
    return testDb;
  }

  tearDown(() {
    deleteDatabase(inMemoryDatabasePath);
    ExerciseService.resetForTests();
    ExerciseEntryService.resetForTests();
    ExerciseSetService.resetForTests();
    WorkoutService.resetForTests();
  });

  group('JackedDb', () {
    test('tables are correctly created', () async {
      // when - the database is set up
      final db = await dbSetUp(
        onCreate: (db, _) async {
          await createTables(db);
        },
      );

      // then - an exercise can be created and queried
      const newExercise = NewExercise(key: 'bench_press');
      await exerciseSvc.create(newExercise);
      expect(await exerciseSvc.get(1), equals(fixtureExercise()));

      // then - an exercise entry can be created and queried
      const exerciseEntry = ExerciseEntry(workoutId: 1, exerciseId: 1);
      await exerciseEntrySvc.create(exerciseEntry);
      expect(await exerciseEntrySvc.get(1), equals(exerciseEntry.copyWith(id: 1)));

      // then - an exercise set can be created and queried
      const exerciseSet = ExerciseSet(exerciseEntryId: 1);
      await exerciseSetSvc.create(exerciseSet);
      expect(await exerciseSetSvc.get(1), equals(exerciseSet.copyWith(id: 1)));

      // then - an exercise set can be created and queried
      final workout = Workout(title: 'W1', startTime: DateTime(2025, 11, 27));
      await workoutSvc.create(workout);
      expect(await workoutSvc.get(1), equals(workout.copyWith(id: 1)));

      db.close();
    });

    test('db is seeded correctly in production', () async {
      // when - the database is set up
      final db = await dbSetUp(
        onCreate: (db, _) async {
          await createTables(db);
          await seedTables(db: db, debug: false);
        },
      );

      // then - the default exercises have been seeded
      expect(await exerciseSvc.list(), equals(seedExercises));

      // and - the other tables are empty
      expect(await exerciseEntrySvc.list(), equals([]));
      expect(await exerciseSetSvc.list(), equals([]));
      expect(await workoutSvc.list(), equals([]));

      db.close();
    });

    test('db is seeded correctly in debug mode', () async {
      // when - the database is set up
      final db = await dbSetUp(
        onCreate: (db, _) async {
          await createTables(db);
          await seedTables(db: db, debug: true);
        },
      );

      // then - all tables have been seeded
      expect(await exerciseSvc.list(), equals(seedExercises));
      expect(await exerciseEntrySvc.list(), equals(seedExerciseEntries));
      expect(await exerciseSetSvc.list(), equals(seedExerciseSets));
      expect(await workoutSvc.list(), equals(seedWorkouts));

      db.close();
    });
  });
}
