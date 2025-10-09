import 'package:jacked/src/db/models/workout.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutService {
  final table = 'Workouts';
  Database db;

  WorkoutService({required this.db});

  Future<List<Workout>> list() async {
    return (await db.query(table)).map(Workout.fromMap).toList();
  }

  Future<bool> delete(int id) async {
    return await db.delete(table, where: 'id = ?', whereArgs: [id]) > 0;
  }

  Future<Workout?> get(int id) async {
    final maps = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? Workout.fromMap(maps.first) : null;
  }

  Future<int> create(Workout item) async {
    return db.insert(table, item.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<bool> update(Workout item) async {
    return await db.update(
          table,
          item.toMap(),
          where: 'id = ?',
          whereArgs: [item.id],
        ) >
        0;
  }
}
