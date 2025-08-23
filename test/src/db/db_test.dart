import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/db.dart';
import 'package:jacked/src/db/seeds.dart';
import 'package:jacked/src/db/services/exercise_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../test_config.dart';

void main() {
  late Database db;
  late ExerciseService svc;

  setupTestDatabase();

  setUp(() async {
    db = await openDatabase(inMemoryDatabasePath, version: 1, onCreate: onCreate);
    svc = ExerciseService(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  test('db is seeded correctly', () async {
    final exercises = await svc.getAll();
    expect(exercises, equals(seedExercises));
  });
}
