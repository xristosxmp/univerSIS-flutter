import 'package:universis/classes/info/Course.dart';

class Semester {
  final String name;
  final List<Course> courses;
  final String averageGrade;

  Semester({
    required this.name,
    required this.courses,
    required this.averageGrade
  });
}
