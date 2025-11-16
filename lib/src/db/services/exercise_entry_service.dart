import 'package:jacked/src/db/db.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseEntryService {
  ExerciseEntryService._({required this.db});

  static ExerciseEntryService? _instance;

  static const table = 'ExerciseEntries';
  final Database db;

  static Future<ExerciseEntryService> get instance async {
    if (_instance != null) return _instance!;
    final db = await JackedDatabase.database;
    _instance = ExerciseEntryService._(db: db);
    return _instance!;
  }

  // Reset the singleton. Use only in tests.
  static void resetForTests() {
    _instance = null;
  }

  Future<List<ExerciseEntry>> list() async =>
      (await db.query(table)).map(ExerciseEntry.fromMap).toList();

  Future<List<ExerciseEntry>> listByWorkoutId(int workoutId) async => (await db.query(
    table,
    where: 'workoutId = ?',
    whereArgs: [workoutId],
  )).map(ExerciseEntry.fromMap).toList();

  Future<bool> delete(int id) async => await db.delete(table, where: 'id = ?', whereArgs: [id]) > 0;

  Future<ExerciseEntry?> get(int id) async {
    final maps = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? ExerciseEntry.fromMap(maps.first) : null;
  }

  Future<int> create(ExerciseEntry item) async =>
      db.insert(table, item.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);

  Future<bool> update(ExerciseEntry item) async =>
      await db.update(
        table,
        item.toMap(),
        where: 'id = ?',
        whereArgs: [item.id],
      ) >
      0;
}
