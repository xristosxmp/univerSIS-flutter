class ThesesInstructor {
  final String name;
  final String grade;

  ThesesInstructor({
    required this.name,
    required this.grade,
  });


    factory ThesesInstructor.fromJson(final Map<String, dynamic> json) {
    final String sup = json["instructor"] == null ? '' : json["instructor"]["givenName"] ?? ( '-' + " " + json["instructor"]["familyName"] ) ?? '-';
    final gradeValue = (json["grade"] as num?)?.toDouble() ?? 0.0;
    final String grade = (gradeValue * 10).toStringAsFixed(1);
    return ThesesInstructor(
      name: sup,
      grade: grade,
    );
  }
}