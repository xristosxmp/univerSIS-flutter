class Semester {
  final String name;

  Semester({
    required this.name,
  });

  factory Semester.fromJson(Map<String, dynamic> json) {
    return Semester(
      name: json['name'] ?? '',
    );
  }
}
