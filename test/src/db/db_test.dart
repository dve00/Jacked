import 'package:flutter_test/flutter_test.dart';
import 'package:jacked/src/db/db.dart';
import 'package:jacked/src/db/seeds.dart';
import 'package:jacked/src/db/services/exercise_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  Database? db;
  late ExerciseService service;

  // Initialize FFI
  sqfliteFfiInit();

  // Override the global databaseFactory to the ffi one
  databaseFactory = databaseFactoryFfi;

  setUp(() async {
    db = await openDatabase(inMemoryDatabasePath, version: 1, onCreate: onCreate);
    service = ExerciseService(db: db!);
  });

  tearDown(() async {
    await db?.close();
  });

  test('db is seeded correctly', () async {
    final exercises = await service.getAll();
    expect(exercises, containsAll(seedExercises));
  });
}
