import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/db.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/db/services/workout_service.dart';
import 'package:sqflite/sqflite.dart';

import '../../../test_config.dart';

final seedWorkouts = <Workout>[
  Workout(
    id: 1,
    title: 'Test Workout 1',
    startTime: DateTime(2025, 9, 8, 18, 0),
    endTime: DateTime(2025, 9, 8, 19, 0),
    description: 'Desc1',
  ),
  Workout(
    id: 2,
    title: 'Test Workout 2',
    startTime: DateTime(2025, 9, 9, 7, 30),
    endTime: DateTime(2025, 9, 9, 8, 15),
    description: 'Desc2',
  ),
  Workout(
    id: 3,
    title: 'Test Workout 3',
    startTime: DateTime(2025, 9, 10, 12, 0),
    endTime: DateTime(2025, 9, 10, 12, 45),
    description: 'Desc3',
  ),
  Workout(
    id: 4,
    title: 'Test Workout 4',
    startTime: DateTime(2025, 9, 11, 17, 15),
    endTime: DateTime(2025, 9, 11, 18, 0),
    description: 'Desc4',
  ),
  Workout(
    id: 5,
    title: 'Test Workout 5',
    startTime: DateTime(2025, 9, 12, 6, 0),
    endTime: DateTime(2025, 9, 12, 6, 50),
    description: 'Desc5',
  ),
];

void main() {
  late Database testDb;
  late WorkoutService svc;

  setupTestDatabase();

  setUp(() async {
    testDb = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) async {
        await createTables(db);
        await seedWorkoutTable(db, seedWorkouts);
      },
    );
    JackedDb.overrideDatabaseForTests(testDb);
    svc = await WorkoutService.instance;
  });

  tearDown(() async {
    await testDb.close();
    await deleteDatabase(inMemoryDatabasePath);
    WorkoutService.resetForTests();
  });

  group('workout service', () {
    test('list', () async {
      expect(await svc.list(), equals(seedWorkouts));
    });

    test('list with order by', () async {
      expect(await svc.list(orderBy: 'startTime desc'), equals(seedWorkouts.reversed));
    });

    group('delete', () {
      test('delete - success', () async {
        final got = await svc.delete(1);
        expect(
          await svc.list(),
          equals(seedWorkouts.slice(1)),
        );
        expect(got, equals(true));
      });
      test('delete - nothing deleted', () async {
        final got = await svc.delete(999);
        expect(
          await svc.list(),
          equals(seedWorkouts),
        );
        expect(got, equals(false));
      });
    });

    group('getById', () {
      test('getById - success', () async {
        expect(await svc.get(1), equals(seedWorkouts[0]));
      });
      test('getById - nothing found', () async {
        expect(await svc.get(999), equals(null));
      });
    });

    group('insert', () {
      test('insert - success', () async {
        final want = List<Workout>.from(seedWorkouts);
        want.add(Workout(id: 6, title: 'Test123', startTime: DateTime(2025, 9, 8)));
        final got = await svc.create(Workout(title: 'Test123', startTime: DateTime(2025, 9, 8)));
        expect(
          await svc.list(),
          equals(want),
        );
        expect(got, equals(6));
      });
    });

    group('update', () {
      test('update - success', () async {
        final today = DateTime.now();
        final update = Workout(id: 1, title: 'newTitle', startTime: today, endTime: today);
        final got = await svc.update(update);
        expect(await svc.list(), equals([update, ...seedWorkouts.slice(1)]));
        expect(got, equals(true));
      });
      test('update - nothing updated', () async {
        final update = Workout(id: 999, title: 'foo', startTime: DateTime.now());
        final got = await svc.update(update);
        expect(await svc.list(), equals(seedWorkouts));
        expect(got, equals(false));
      });
    });
  });
}
