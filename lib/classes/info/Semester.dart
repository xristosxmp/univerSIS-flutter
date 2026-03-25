import 'package:universis/classes/info/Course.dart';

class Semester {
  final String name;
  final List<Course> courses;
  final String averageGrade;
  final String ects;
  final String totalEcts;

  Semester({
    required this.name,
    required this.courses,
    required this.averageGrade,
    required this.ects,
    required this.totalEcts
  });
}
