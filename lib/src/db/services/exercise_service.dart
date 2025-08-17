import 'package:jacked/src/db/db.dart';
import 'package:jacked/src/db/models/exercise.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseService {
  final table = 'Exercises';
  final _db = AppDatabase.database;

  Future<List<Exercise>> getAll() async {
    final db = await _db;

    final List<Map<String, Object?>> exerciseMaps = await db.query(table);

    return exerciseMaps.map((map) {
      return Exercise(
        id: map['id'] as int,
        name: map['name'] as String,
      ); // this is not right
    }).toList();
  }

  Future<bool> delete(int exerciseId) async {
    final db = await _db;

    return await db.delete(table, where: 'exerciseId = ?', whereArgs: [exerciseId]) > 0;
  }

  Future<Exercise?> getById(int exerciseId) async {
    final db = await _db;

    final maps = await db.query(table, where: 'exerciseId = ?', whereArgs: [exerciseId]);
    return Exercise(
      id: maps[0]['exerciseId'] as int,
      name: maps[0] as String,
    );
  }

  Future<int> insert(Exercise item) async {
    final db = await _db;

    return db.insert(table, {
      'exerciseId': item.id,
      'name': item.name,
      'description': item.description,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> update(Exercise item) async {
    final db = await _db;

    return await db.update(
          table,
          {'exerciseId': item.id, 'name': item.name, 'description': item.description},
          where: 'exerciseId = ?',
          whereArgs: [item.id],
        ) >
        0;
  }
}
