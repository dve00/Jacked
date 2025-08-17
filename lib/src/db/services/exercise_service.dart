import 'package:jacked/src/db/models/exercise.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseService {
  final table = 'Exercises';
  Database db;

  ExerciseService({required this.db});

  Future<List<Exercise>> getAll() async {
    return (await db.query(table)).map((m) {
      return Exercise(
        id: m['id'] as int,
        name: m['name'] as String,
        description: m['description'] as String,
      ); // this is not right
    }).toList();
  }

  Future<bool> delete(int exerciseId) async {
    return await db.delete(table, where: 'exerciseId = ?', whereArgs: [exerciseId]) > 0;
  }

  Future<Exercise?> getById(int exerciseId) async {
    final maps = await db.query(table, where: 'exerciseId = ?', whereArgs: [exerciseId]);
    return Exercise(
      id: maps[0]['exerciseId'] as int,
      name: maps[0] as String,
    );
  }

  Future<int> insert(Exercise item) async {
    return db.insert(table, {
      'exerciseId': item.id,
      'name': item.name,
      'description': item.description,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> update(Exercise item) async {
    return await db.update(
          table,
          {'exerciseId': item.id, 'name': item.name, 'description': item.description},
          where: 'exerciseId = ?',
          whereArgs: [item.id],
        ) >
        0;
  }
}
