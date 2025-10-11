import 'package:jacked/src/db/models/exercise_set.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseSetService {
  final table = 'ExerciseSets';
  Database db;

  ExerciseSetService({required this.db});

  Future<List<ExerciseSet>> list() async =>
      (await db.query(table)).map(ExerciseSet.fromMap).toList();

  Future<List<ExerciseSet>> listByExerciseEntryId(int exerciseEntryId) async => (await db.query(
    table,
    where: 'exerciseEntryId = ?',
    whereArgs: [exerciseEntryId],
  )).map(ExerciseSet.fromMap).toList();

  Future<bool> delete(int id) async => await db.delete(table, where: 'id = ?', whereArgs: [id]) > 0;

  Future<ExerciseSet?> get(int id) async {
    final maps = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? ExerciseSet.fromMap(maps.first) : null;
  }

  Future<int> create(ExerciseSet item) async =>
      db.insert(table, item.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);

  Future<bool> update(ExerciseSet item) async =>
      await db.update(
        table,
        item.toMap(),
        where: 'id = ?',
        whereArgs: [item.id],
      ) >
      0;
}
