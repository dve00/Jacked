import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/db.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/exercise_set.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/db/seeds.dart';
import 'package:jacked/src/db/repositories/exercise_entry_repository.dart';
import 'package:jacked/src/db/repositories/exercise_repository.dart';
import 'package:jacked/src/db/repositories/exercise_set_repository.dart';
import 'package:jacked/src/db/repositories/workout_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../fixtures.dart';
import '../../test_config.dart';

void main() {
  late Database testDb;
  late ExerciseRepository exerciseRepo;
  late ExerciseEntryRepository exerciseEntryRepo;
  late ExerciseSetRepository exerciseSetRepo;
  late WorkoutRepository workoutRepo;

  setupTestDatabase();

  Future<Database> dbSetUp({required Future<void> Function(Database, int) onCreate}) async {
    testDb = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: onCreate,
    );
    JackedDb.overrideDatabaseForTests(testDb);
    exerciseRepo = await ExerciseRepository.instance;
    exerciseEntryRepo = await ExerciseEntryRepository.instance;
    exerciseSetRepo = await ExerciseSetRepository.instance;
    workoutRepo = await WorkoutRepository.instance;
    return testDb;
  }

  tearDown(() {
    deleteDatabase(inMemoryDatabasePath);
    ExerciseRepository.resetForTests();
    ExerciseEntryRepository.resetForTests();
    ExerciseSetRepository.resetForTests();
    WorkoutRepository.resetForTests();
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
      await exerciseRepo.create(const NewExercise(key: 'bench_press'));
      expect(await exerciseRepo.get(1), equals(fixtureExercise()));

      // then - an exercise entry can be created and queried
      await exerciseEntryRepo.create(const NewExerciseEntry(workoutId: 1, exerciseId: 1));
      expect(
        await exerciseEntryRepo.get(1),
        equals(fixtureExerciseEntry((ee) => ee.copyWith(sets: null))),
      );

      // then - an exercise set can be created and queried
      await exerciseSetRepo.create(const NewExerciseSet(exerciseEntryId: 1));
      expect(await exerciseSetRepo.get(1), equals(fixtureExerciseSet()));

      // then - an exercise set can be created and queried
      await workoutRepo.create(NewWorkout(title: 'Workout 1', startTime: DateTime(2025, 11, 23)));
      expect(await workoutRepo.get(1), equals(fixtureWorkout()));

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
      expect(await exerciseRepo.list(), equals(seedExercises));

      // and - the other tables are empty
      expect(await exerciseEntryRepo.list(), equals([]));
      expect(await exerciseSetRepo.list(), equals([]));
      expect(await workoutRepo.list(), equals([]));

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
      expect(await exerciseRepo.list(), equals(seedExercises));
      expect(await exerciseEntryRepo.list(), equals(seedExerciseEntries));
      expect(await exerciseSetRepo.list(), equals(seedExerciseSets));
      expect(await workoutRepo.list(), equals(seedWorkouts));

      db.close();
    });
  });
}
