import 'package:jacked/src/db/models/exercise.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseService {
  final table = 'Exercises';
  Database db;

  ExerciseService({required this.db});

  Future<List<Exercise>> getAll() async {
    return (await db.query(table)).map(Exercise.fromMap).toList();
  }

  Future<bool> delete(int id) async {
    return await db.delete(table, where: 'id = ?', whereArgs: [id]) > 0;
  }

  Future<Exercise?> getById(int id) async {
    final maps = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? Exercise.fromMap(maps.first) : null;
  }

  Future<int> insert(Exercise item) async {
    return db.insert(table, item.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<bool> update(Exercise item) async {
    return await db.update(
          table,
          {'id': item.id, 'name': item.name, 'description': item.description},
          where: 'id = ?',
          whereArgs: [item.id],
        ) >
        0;
  }
}
