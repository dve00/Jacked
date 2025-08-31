import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/db.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/services/exercise_service.dart';
import 'package:sqflite/sqflite.dart';

import '../../../test_config.dart';

const seedExercises = <Exercise>[
  Exercise(id: 1, key: 'bench_press'),
  Exercise(id: 2, key: 'lat_pulldown'),
  Exercise(id: 3, key: 'overhead_press'),
  Exercise(id: 4, key: 'seated_row'),
  Exercise(id: 5, key: 'back_squat'),
];

void main() {
  late Database db;
  late ExerciseService svc;

  setupTestDatabase();

  setUp(() async {
    db = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) async {
        await initExercisesTable(db);
      },
    );
    svc = ExerciseService(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('exercise service', () {
    test('get all', () async {
      expect(await svc.list(), equals(seedExercises));
    });

    group('delete', () {
      test('delete - success', () async {
        final got = await svc.delete(1);
        expect(
          await svc.list(),
          equals(seedExercises.slice(1)),
        );
        expect(got, equals(true));
      });
      test('delete - nothing deleted', () async {
        final got = await svc.delete(999);
        expect(
          await svc.list(),
          equals(seedExercises),
        );
        expect(got, equals(false));
      });
    });

    group('getById', () {
      test('getById - success', () async {
        expect(await svc.get(1), equals(seedExercises[0]));
      });
      test('getById - nothing found', () async {
        expect(await svc.get(999), equals(null));
      });
    });

    group('insert', () {
      test('insert - success', () async {
        final want = List<Exercise>.from(seedExercises);
        want.add(const Exercise(id: 6, key: 'test exercise'));
        final got = await svc.create(const Exercise(key: 'test exercise'));
        expect(
          await svc.list(),
          equals(want),
        );
        expect(got, equals(6));
      });
      test('insert - already exists', () async {
        final got = await svc.create(const Exercise(key: 'bench_press'));
        expect(got, equals(0));
        expect(await svc.list(), equals(seedExercises));
      });
    });

    group('update', () {
      test('update - success', () async {
        const update = Exercise(id: 1, key: 'Bench Press 2');
        final got = await svc.update(update);
        expect(await svc.list(), equals([update, ...seedExercises.slice(1)]));
        expect(got, equals(true));
      });
      test('update - nothing updated', () async {
        const update = Exercise(id: 999, key: 'Bench Press 2');
        final got = await svc.update(update);
        expect(await svc.list(), equals(seedExercises));
        expect(got, equals(false));
      });
    });
  });
}
