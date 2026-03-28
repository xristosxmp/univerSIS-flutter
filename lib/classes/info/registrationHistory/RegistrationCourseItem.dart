
import 'package:universis/classes/info/registrationHistory/RegistrationTeacherItem.dart';

class RegistrationCourseItem {
  final String courseCode;
  final String courseName;
  final List<RegistrationTeacherItem> teachers;

  RegistrationCourseItem({
    required this.courseCode,
    required this.courseName,
    required this.teachers,
  });

  factory RegistrationCourseItem.fromJson(final Map<String, dynamic> json) {
    final List<dynamic> instructorsArray = json["courseClass"]?['instructors'] ?? [];
    return RegistrationCourseItem(
      courseCode: json["courseClass"]?["course"] ?? '',
      courseName: json["courseClass"]?["title"] ?? '',
      teachers: instructorsArray.map((e) => RegistrationTeacherItem.fromJson(e)).toList()
    );
  }
}