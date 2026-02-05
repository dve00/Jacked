import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/db.dart';
import 'package:jacked/src/db/models/exercise_set.dart';
import 'package:jacked/src/db/repositories/exercise_set_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../../../test_config.dart';

const seedExerciseSets = <ExerciseSet>[
  ExerciseSet(id: 1, exerciseEntryId: 1, reps: 1, weight: 1.0),
  ExerciseSet(id: 2, exerciseEntryId: 2, reps: 2, weight: 2.0),
  ExerciseSet(id: 3, exerciseEntryId: 3, reps: 3, weight: 3.0),
  ExerciseSet(id: 4, exerciseEntryId: 4, duration: Duration(seconds: 4)),
];

void main() {
  late Database testDb;
  late ExerciseSetRepository repo;

  setupTestDatabase();

  setUp(() async {
    testDb = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) async {
        await createTables(db);
        await seedExerciseSetsTable(db, seedExerciseSets);
      },
    );
    JackedDb.overrideDatabaseForTests(testDb);
    repo = await ExerciseSetRepository.instance;
  });

  tearDown(() async {
    await testDb.close();
    await deleteDatabase(inMemoryDatabasePath);
    ExerciseSetRepository.resetForTests();
  });

  group('exercise entry service', () {
    test('list', () async {
      expect(await repo.list(), equals(seedExerciseSets));
    });

    test('listByWorkoutId', () async {
      expect(await repo.listByExerciseEntryId(1), equals(seedExerciseSets.slice(0, 1)));
    });

    group('delete', () {
      test('delete - success', () async {
        final got = await repo.delete(1);
        expect(
          await repo.list(),
          equals(seedExerciseSets.slice(1)),
        );
        expect(got, equals(true));
      });
      test('delete - nothing deleted', () async {
        final got = await repo.delete(999);
        expect(
          await repo.list(),
          equals(seedExerciseSets),
        );
        expect(got, equals(false));
      });
    });

    group('getById', () {
      test('getById - success', () async {
        expect(await repo.get(1), equals(seedExerciseSets[0]));
      });
      test('getById - nothing found', () async {
        expect(await repo.get(999), equals(null));
      });
    });

    group('insert', () {
      test('insert - success', () async {
        final want = List<ExerciseSet>.from(seedExerciseSets);
        want.add(const ExerciseSet(id: 5, exerciseEntryId: 5, reps: 5));
        final got = await repo.create(const NewExerciseSet(exerciseEntryId: 5, reps: 5));
        expect(
          await repo.list(),
          equals(want),
        );
        expect(got, equals(5));
      });
    });

    group('update', () {
      test('update - success', () async {
        const update = ExerciseSet(id: 1, exerciseEntryId: 2, reps: 2);
        final got = await repo.update(update);
        expect(await repo.list(), equals([update, ...seedExerciseSets.slice(1)]));
        expect(got, equals(true));
      });
      test('update - nothing updated', () async {
        const update = ExerciseSet(
          id: 999,
          exerciseEntryId: 2,
        );
        final got = await repo.update(update);
        expect(await repo.list(), equals(seedExerciseSets));
        expect(got, equals(false));
      });
    });
  });
}
