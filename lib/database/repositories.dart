import 'package:jacked/database/database.dart';
import 'package:jacked/database/models.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseRepository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(int exerciseId);
  Future<int> insert(T item);
  Future<bool> update(T item);
  Future<bool> delete(int exerciseId);
}

class ExerciseRepository implements BaseRepository<Exercise> {
  final table = 'exercises';
  final _db = DatabaseHelper.instance.database;

  @override
  Future<List<Exercise>> getAll() async {
    final db = await _db;

    final List<Map<String, Object?>> exerciseMaps = await db.query(table);

    return exerciseMaps.map((map) {
      return Exercise(
        exerciseId: map['exerciseId'] as int,
        name: map['name'] as String,
      ); // this is not right
    }).toList();
  }

  @override
  Future<bool> delete(int exerciseId) async {
    final db = await _db;

    return await db.delete(table, where: 'exerciseId = ?', whereArgs: [exerciseId]) > 0;
  }

  @override
  Future<Exercise?> getById(int exerciseId) async {
    final db = await _db;

    final maps = await db.query(table, where: 'exerciseId = ?', whereArgs: [exerciseId]);
    return Exercise(
      exerciseId: maps[0]['exerciseId'] as int,
      name: maps[0] as String,
    );
  }

  @override
  Future<int> insert(Exercise item) async {
    final db = await _db;

    return db.insert(table, {
      'exerciseId': item.exerciseId,
      'name': item.name,
      'description': item.description,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<bool> update(Exercise item) async {
    final db = await _db;

    return await db.update(
          table,
          {'exerciseId': item.exerciseId, 'name': item.name, 'description': item.description},
          where: 'exerciseId = ?',
          whereArgs: [item.exerciseId],
        ) >
        0;
  }
}
