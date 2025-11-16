import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/db.dart';
import 'package:jacked/src/db/seeds.dart';
import 'package:jacked/src/db/services/exercise_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../test_config.dart';

void main() {
  late Database testDb;
  late ExerciseService svc;

  setupTestDatabase();

  setUp(() async {
    testDb = await openDatabase(inMemoryDatabasePath, version: 1, onCreate: onCreate);
    JackedDatabase.overrideDatabaseForTests(testDb);
    svc = await ExerciseService.instance;
  });

  tearDown(() async {
    await testDb.close();
  });

  test('db is seeded correctly', () async {
    final exercises = await svc.list();
    expect(exercises, equals(seedExercises));
  });
}
