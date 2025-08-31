import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final int? id;
  final String key;

  const Exercise({
    this.id,
    required this.key,
  });

  Exercise copyWith(String? name, String? description) {
    return Exercise(
      key: name ?? key,
    );
  }

  factory Exercise.fromMap(Map<String, Object?> map) {
    return Exercise(
      id: map['id'] as int,
      key: map['key'] as String,
    );
  }

  Map<String, Object?> toMap({bool includeId = false}) {
    return {
      if (includeId && id != null) 'id': id,
      'key': key,
    };
  }

  @override
  List<Object?> get props => [
    id,
    key,
  ];
}
