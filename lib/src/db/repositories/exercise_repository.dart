import 'package:jacked/src/db/db.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseRepository {
  ExerciseRepository._({required this.db});

  static ExerciseRepository? _instance;

  final table = 'Exercises';
  Database db;

  static Future<ExerciseRepository> get instance async {
    if (_instance != null) return _instance!;
    final db = await JackedDb.database;
    _instance = ExerciseRepository._(db: db);
    return _instance!;
  }

  // Reset the singleton. Use only in tests.
  static void resetForTests() {
    _instance = null;
  }

  Future<List<Exercise>> list() async => (await db.query(table)).map(Exercise.fromMap).toList();

  Future<bool> delete(int id) async => await db.delete(table, where: 'id = ?', whereArgs: [id]) > 0;

  Future<Exercise?> get(int id) async {
    final maps = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? Exercise.fromMap(maps.first) : null;
  }

  Future<int> create(NewExercise item) async => db.insert(table, item.toMap());

  Future<bool> update(Exercise item) async =>
      await db.update(
        table,
        item.toMap(),
        where: 'id = ?',
        whereArgs: [item.id],
      ) >
      0;
}
