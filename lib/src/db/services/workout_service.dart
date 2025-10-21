import 'package:jacked/src/db/db.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutService {
  WorkoutService({required this.db});

  static WorkoutService? _instance;

  final table = 'Workouts';
  Database db;

  static Future<WorkoutService> get instance async {
    if (_instance != null) return _instance!;
    final db = await JackedDatabase.database;
    _instance = WorkoutService(db: db);
    return _instance!;
  }

  Future<List<Workout>> list() async => (await db.query(table)).map(Workout.fromMap).toList();

  Future<bool> delete(int id) async => await db.delete(table, where: 'id = ?', whereArgs: [id]) > 0;

  Future<Workout?> get(int id) async {
    final maps = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? Workout.fromMap(maps.first) : null;
  }

  Future<int> create(Workout item) async =>
      db.insert(table, item.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);

  Future<bool> update(Workout item) async =>
      await db.update(
        table,
        item.toMap(),
        where: 'id = ?',
        whereArgs: [item.id],
      ) >
      0;
}
