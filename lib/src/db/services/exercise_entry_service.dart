import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseEntryService {
  final table = 'ExerciseEntries';
  Database db;

  ExerciseEntryService({required this.db});

  Future<List<ExerciseEntry>> list() async =>
      (await db.query(table)).map(ExerciseEntry.fromMap).toList();

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
