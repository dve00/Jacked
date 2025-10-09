import 'package:jacked/src/db/models/exercise.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseService {
  final table = 'Exercises';
  Database db;

  ExerciseService({required this.db});

  Future<List<Exercise>> list() async => (await db.query(table)).map(Exercise.fromMap).toList();

  Future<bool> delete(int id) async => await db.delete(table, where: 'id = ?', whereArgs: [id]) > 0;

  Future<Exercise?> get(int id) async {
    final maps = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? Exercise.fromMap(maps.first) : null;
  }

  Future<int> create(Exercise item) async =>
      db.insert(table, item.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);

  Future<bool> update(Exercise item) async =>
      await db.update(
        table,
        item.toMap(),
        where: 'id = ?',
        whereArgs: [item.id],
      ) >
      0;
}
