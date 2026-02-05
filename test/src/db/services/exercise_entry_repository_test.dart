import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/db.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/db/repositories/exercise_entry_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../../../fixtures.dart';
import '../../../test_config.dart';

const seedExerciseEntries = <ExerciseEntry>[
  ExerciseEntry(id: 1, workoutId: 1, exerciseId: 1),
  ExerciseEntry(id: 2, workoutId: 2, exerciseId: 2),
  ExerciseEntry(id: 3, workoutId: 3, exerciseId: 3),
  ExerciseEntry(id: 4, workoutId: 4, exerciseId: 4),
  ExerciseEntry(id: 5, workoutId: 5, exerciseId: 5),
  ExerciseEntry(id: 6, workoutId: 3, exerciseId: 2),
];

void main() {
  late Database testDb;
  late ExerciseEntryRepository repo;

  setupTestDatabase();

  setUp(() async {
    testDb = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) async {
        await createTables(db);
        await seedExerciseEntriesTable(db, seedExerciseEntries);
      },
    );
    JackedDb.overrideDatabaseForTests(testDb);
    repo = await ExerciseEntryRepository.instance;
  });

  tearDown(() async {
    await testDb.close();
    await deleteDatabase(inMemoryDatabasePath);
    ExerciseEntryRepository.resetForTests();
  });

  group('exercise entry service', () {
    test('list', () async {
      expect(await repo.list(), equals(seedExerciseEntries));
    });

    test('listByWorkoutId', () async {
      expect(await repo.listByWorkoutId(1), equals(seedExerciseEntries.slice(0, 1)));
    });

    group('getMostRecentExerciseEntry', () {
      setUp(() async {
        await seedWorkoutsTable(testDb, <Workout>[
          fixtureWorkout((w) {
            return w.copyWith(startTime: DateTime(2025, 12, 2));
          }),
          fixtureWorkout((w) {
            return w.copyWith(startTime: DateTime(2025, 12, 1));
          }),
          fixtureWorkout((w) {
            return w.copyWith(startTime: DateTime(2025, 11, 30));
          }),
        ]);
      });

      final inputs = [
        {
          'name': 'returns null',
          'exerciseId': 99,
          'startTime': DateTime(2025, 12, 2),
          'want': null,
        },
        {
          'name': 'returns most recent entry',
          'exerciseId': 2,
          'startTime': DateTime(2025, 12, 2),
          'want': const ExerciseEntry(id: 2, workoutId: 2, exerciseId: 2),
        },
      ];
      for (final {
            'name': name as String,
            'exerciseId': exerciseId as int,
            'startTime': startTime as DateTime,
            'want': want as ExerciseEntry?,
          }
          in inputs) {
        test(name, () async {
          expect(
            await repo.getMostRecentExerciseEntry(exerciseId: exerciseId, startTime: startTime),
            want,
          );
        });
      }
    });

    group('delete', () {
      test('delete - success', () async {
        final got = await repo.delete(1);
        expect(
          await repo.list(),
          equals(seedExerciseEntries.slice(1)),
        );
        expect(got, equals(true));
      });
      test('delete - nothing deleted', () async {
        final got = await repo.delete(999);
        expect(
          await repo.list(),
          equals(seedExerciseEntries),
        );
        expect(got, equals(false));
      });
    });

    group('getById', () {
      test('getById - success', () async {
        expect(await repo.get(1), equals(seedExerciseEntries[0]));
      });
      test('getById - nothing found', () async {
        expect(await repo.get(999), equals(null));
      });
    });

    group('insert', () {
      test('insert - success', () async {
        final want = List<ExerciseEntry>.from(seedExerciseEntries);
        want.add(const ExerciseEntry(id: 7, workoutId: 6, exerciseId: 6));
        final got = await repo.create(const NewExerciseEntry(workoutId: 6, exerciseId: 6));
        expect(
          await repo.list(),
          equals(want),
        );
        expect(got, equals(7));
      });
    });

    group('update', () {
      test('update - success', () async {
        const update = ExerciseEntry(id: 1, workoutId: 99, exerciseId: 99);
        final got = await repo.update(update);
        expect(await repo.list(), equals([update, ...seedExerciseEntries.slice(1)]));
        expect(got, equals(true));
      });
      test('update - nothing updated', () async {
        const update = ExerciseEntry(id: 999, workoutId: 1, exerciseId: 1);
        final got = await repo.update(update);
        expect(await repo.list(), equals(seedExerciseEntries));
        expect(got, equals(false));
      });
    });
  });
}
