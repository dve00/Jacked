import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final int? id;
  final String name;
  final String? description;

  const Exercise({this.id, required this.name, this.description});

  Exercise copyWith(String? name, String? description) {
    return Exercise(
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  factory Exercise.fromMap(Map<String, Object?> map) {
    return Exercise(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String?,
    );
  }

  Map<String, Object?> toMap({bool includeId = false}) {
    return {
      if (includeId && id != null) 'id': id,
      'name': name,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [id, name, description];
}
