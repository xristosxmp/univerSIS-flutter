import 'package:universis/classes/Teacher.dart';

class Course {
  final String code;
  final String title;
  final String grade;
  final bool isPassed;
  final String type;
  final String ects;

  final List<Teacher> teachers;

  Course({
    required this.code,
    required this.title,
    required this.grade,
    required this.isPassed,
    required this.teachers,
    required this.type,
    required this.ects
  });

  factory Course.fromJson(Map<String, dynamic> json) {
      final gradeExam = json['gradeExam'];

      List<Teacher> teachers = [];

      if (gradeExam != null && gradeExam['instructors'] != null) {
        teachers = (gradeExam['instructors'] as List)
            .map((t) => Teacher.fromJson(t))
            .toList();
      }

    return Course(
      code: json['course']['id'] ?? '',
      title: json['courseTitle'] ?? '',
      grade: json['formattedGrade'] ?? '',
      isPassed: json['isPassed'] == 1,
      teachers: teachers,
      type: json['courseType']?['abbreviation'] ?? '',
      ects: json['ects'] != null ? json['ects'].toString() : '0',
    );
  }
}