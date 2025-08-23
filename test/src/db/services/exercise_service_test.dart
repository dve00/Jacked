import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:jacked/src/db/services/exercise_service.dart';
import 'package:sqflite/sqflite.dart';

import '../../../test_config.dart';

Future<void> _onCreate(Database db, int version) async {
  await db.execute('''
    CREATE TABLE Exercises (
      id SERIAL PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      description TEXT
    );
  ''');
  for (final exercise in seedExercises) {
    await db.execute(
      'INSERT OR IGNORE INTO Exercises (id, name, description) VALUES (?, ?, ?)',
      [exercise.id, exercise.name, exercise.description],
    );
  }
}

const seedExercises = <Exercise>[
  Exercise(id: 1, name: 'Bench Press', description: 'Chest'),
  Exercise(id: 2, name: 'Lat Pulldown', description: 'Back'),
  Exercise(id: 3, name: 'Overhead Press', description: 'Shoulders'),
  Exercise(id: 4, name: 'Seated Row', description: 'Back'),
  Exercise(id: 5, name: 'Back Squat', description: 'Legs'),
];

void main() {
  late Database db;
  late ExerciseService svc;

  setupTestDatabase();

  setUp(() async {
    db = await openDatabase(inMemoryDatabasePath, version: 1, onCreate: _onCreate);
    svc = ExerciseService(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('exercise service', () {
    test('get all', () async {
      expect(await svc.getAll(), equals(seedExercises));
    });

    group('delete', () {
      test('delete - success', () async {
        final got = await svc.delete(1);
        expect(
          await svc.getAll(),
          equals(seedExercises.slice(1)),
        );
        expect(got, equals(true));
      });
      test('delete - nothing deleted', () async {
        final got = await svc.delete(999);
        expect(
          await svc.getAll(),
          equals(seedExercises),
        );
        expect(got, equals(false));
      });
    });
  });
}
