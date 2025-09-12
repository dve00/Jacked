import 'package:equatable/equatable.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';

class Workout extends Equatable {
  final int? id;
  final String title;
  final DateTime startTime;
  final DateTime? endTime;
  final String? description;
  final List<ExerciseEntry>? exerciseEntries;

  const Workout({
    this.id,
    required this.title,
    required this.startTime,
    this.endTime,
    this.description,
    this.exerciseEntries,
  });

  Workout copyWith({
    String? title,
    DateTime? stopTime,
    String? description,
    List<ExerciseEntry>? exerciseEntries,
  }) {
    return Workout(
      id: id,
      title: title ?? this.title,
      startTime: startTime,
      endTime: stopTime ?? endTime,
      description: description ?? this.description,
      exerciseEntries: exerciseEntries ?? this.exerciseEntries,
    );
  }

  Workout addExerciseEntry(ExerciseEntry newEntry) {
    final currentEntries = exerciseEntries ?? <ExerciseEntry>[];
    final updatedEntries = List<ExerciseEntry>.from(currentEntries)..add(newEntry);

    return copyWith(exerciseEntries: updatedEntries);
  }

  Workout deleteExerciseEntry(ExerciseEntry exerciseEntry) {
    final currentEntries = exerciseEntries ?? <ExerciseEntry>[];
    final updatedEntries = currentEntries.where((entry) => entry != exerciseEntry).toList();

    return copyWith(exerciseEntries: updatedEntries);
  }

  factory Workout.fromMap(Map<String, Object?> map) {
    return Workout(
      id: map['id'] as int,
      title: map['title'] as String,
      startTime: DateTime.fromMicrosecondsSinceEpoch(map['startTime'] as int),
      endTime: map['endTime'] != null
          ? DateTime.fromMicrosecondsSinceEpoch(map['endTime'] as int)
          : null,
      description: map['description'] != null ? map['description'] as String : null,
    );
  }

  Map<String, Object?> toMap({bool includeId = false}) {
    return {
      if (includeId && id != null) 'id': id,
      'title': title,
      'startTime': startTime.microsecondsSinceEpoch,
      'endTime': endTime?.microsecondsSinceEpoch,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [id, title, startTime, endTime, description, exerciseEntries];
}
