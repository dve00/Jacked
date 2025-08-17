class Exercise {
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Exercise &&
        id == other.id &&
        name == other.name &&
        description == other.description;
  }

  @override
  int get hashCode => Object.hash(id, name, description);
}
