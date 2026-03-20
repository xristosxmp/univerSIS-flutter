class Teacher {
  final String name;

  Teacher({
    required this.name,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    final instructor = json['instructor'];

    final String firstName = instructor?['givenName'] ?? '';
    final String lastName = instructor?['familyName'] ?? '';

    return Teacher(
      name: '$firstName $lastName',
    );
  }
}