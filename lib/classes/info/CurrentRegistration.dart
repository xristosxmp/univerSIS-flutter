import 'package:universis/classes/info/Course.dart';

class CurrentRegistration {
  final String period;
  final List<Course> currentRegistrationCourses;

  CurrentRegistration({
    required this.period,
    required this.currentRegistrationCourses
  });

  factory CurrentRegistration.fromJson(final Map<String, dynamic> json, final List<Course> courses) {
    return CurrentRegistration(
      period: json['examGrade'],
      currentRegistrationCourses: courses
    );
  }
}