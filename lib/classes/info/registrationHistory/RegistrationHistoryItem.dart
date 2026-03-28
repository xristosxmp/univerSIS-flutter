
import 'package:universis/classes/info/registrationHistory/RegistrationCourseItem.dart';

class RegistrationHistoryItem {
  final String period;
  final String semester;
  final List<RegistrationCourseItem> courses;

  RegistrationHistoryItem({
    required this.period,
    required this.semester,
    required this.courses,
  });

  factory RegistrationHistoryItem.fromJson(final Map<String, dynamic> json) {
    final periodName = (json["registrationPeriod"]?["name"] ?? '').toString();
    final yearName = (json["registrationYear"]?["name"] ?? '').toString();
    final String period = '${periodName.toUpperCase()} ΕΞΑΜΗΝΟ ${yearName.toUpperCase()}';
    final List<dynamic> coursesArray = json['classes'] ?? [];
    return RegistrationHistoryItem(
      period: period,
      semester: '${json["semester"] ?? ''} Εξάμηνο',
      courses: coursesArray.map((e) => RegistrationCourseItem.fromJson(e)).toList()
    );
  }
}