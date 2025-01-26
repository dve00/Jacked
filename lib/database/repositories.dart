import 'package:jacked/database/database.dart';
import 'package:jacked/database/models.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseRepository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(int id);
  Future<int> insert(T item);
  Future<bool> update(T item);
  Future<bool> delete(int id);
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
          exerciseId: map['id'] as int,
          name: map['name'] as String,
          entries: List<ExerciseEntry>.empty()); // this is not right
    }).toList();
  }

  @override
  Future<bool> delete(int id) async {
    final db = await _db;

    return await db.delete(table, where: 'id = ?', whereArgs: [id]) > 0;
  }

  @override
  Future<Exercise?> getById(int id) async {
    final db = await _db;

    final maps = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return Exercise(
        exerciseId: maps[0]['id'] as int,
        name: maps[0] as String,
        entries: List<ExerciseEntry>.empty());
  }

  @override
  Future<int> insert(Exercise item) async {
    final db = await _db;

    return db.insert(
        table,
        {
          'id': item.exerciseId,
          'name': item.name,
          'description': item.description,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<bool> update(Exercise item) async {
    final db = await _db;

    return await db.update(
            table,
            {
              'id': item.exerciseId,
              'name': item.name,
              'description': item.description
            },
            where: 'id = ?',
            whereArgs: [item.exerciseId]) >
        0;
  }
}
