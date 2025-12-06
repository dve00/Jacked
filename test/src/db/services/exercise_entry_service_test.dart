import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/db.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/db/services/exercise_entry_service.dart';
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
  late ExerciseEntryService svc;

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
    svc = await ExerciseEntryService.instance;
  });

  tearDown(() async {
    await testDb.close();
    await deleteDatabase(inMemoryDatabasePath);
    ExerciseEntryService.resetForTests();
  });

  group('exercise entry service', () {
    test('list', () async {
      expect(await svc.list(), equals(seedExerciseEntries));
    });

    test('listByWorkoutId', () async {
      expect(await svc.listByWorkoutId(1), equals(seedExerciseEntries.slice(0, 1)));
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
            await svc.getMostRecentExerciseEntry(exerciseId: exerciseId, startTime: startTime),
            want,
          );
        });
      }
    });

    group('delete', () {
      test('delete - success', () async {
        final got = await svc.delete(1);
        expect(
          await svc.list(),
          equals(seedExerciseEntries.slice(1)),
        );
        expect(got, equals(true));
      });
      test('delete - nothing deleted', () async {
        final got = await svc.delete(999);
        expect(
          await svc.list(),
          equals(seedExerciseEntries),
        );
        expect(got, equals(false));
      });
    });

    group('getById', () {
      test('getById - success', () async {
        expect(await svc.get(1), equals(seedExerciseEntries[0]));
      });
      test('getById - nothing found', () async {
        expect(await svc.get(999), equals(null));
      });
    });

    group('insert', () {
      test('insert - success', () async {
        final want = List<ExerciseEntry>.from(seedExerciseEntries);
        want.add(const ExerciseEntry(id: 7, workoutId: 6, exerciseId: 6));
        final got = await svc.create(const ExerciseEntry(workoutId: 6, exerciseId: 6));
        expect(
          await svc.list(),
          equals(want),
        );
        expect(got, equals(7));
      });
    });

    group('update', () {
      test('update - success', () async {
        const update = ExerciseEntry(id: 1, workoutId: 2, exerciseId: 2);
        final got = await svc.update(update);
        expect(await svc.list(), equals([update, ...seedExerciseEntries.slice(1)]));
        expect(got, equals(true));
      });
      test('update - nothing updated', () async {
        const update = ExerciseEntry(id: 999, workoutId: 1, exerciseId: 1);
        final got = await svc.update(update);
        expect(await svc.list(), equals(seedExerciseEntries));
        expect(got, equals(false));
      });
    });
  });
}
