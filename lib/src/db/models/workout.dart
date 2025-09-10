import 'package:equatable/equatable.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';

class Workout extends Equatable {
  final int? id;
  final String title;
  final DateTime startTime;
  final DateTime? stopTime;
  final String? description;
  final List<ExerciseEntry>? exerciseEntries;

  const Workout({
    this.id,
    required this.title,
    required this.startTime,
    this.stopTime,
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
      stopTime: stopTime ?? this.stopTime,
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

  @override
  List<Object?> get props => [id, title, startTime, stopTime, description, exerciseEntries];
}
