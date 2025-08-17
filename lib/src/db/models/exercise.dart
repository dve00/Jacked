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

  @override
  List<Object?> get props => [id, name, description];
}
