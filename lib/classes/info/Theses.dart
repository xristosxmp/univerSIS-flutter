import 'dart:ffi';

import 'package:universis/classes/info/ThesesInstructor.dart';

class Theses {
  final String thesesName;
  final String supervisor;
  final String grade;
  final bool isPassed;
  final List<ThesesInstructor> thesesInstructors;

  Theses({
    required this.thesesName,
    required this.supervisor,
    required this.grade,
    required this.isPassed,
    required this.thesesInstructors
  });


  
  factory Theses.fromJson(final Map<String, dynamic> json) {
    final String sup = json["instructor"] == null ? '' : json["instructor"]["givenName"] ?? ( '-' + " " + json["instructor"]["familyName"] ) ?? '-';
    final List<dynamic> instructorsJson = json['results'] ?? [];
    return Theses(
      thesesName: json['name'] ?? '',
      supervisor: sup,
      grade: json["formattedGrade"] ?? '-',
      isPassed: json["isPassed"] == 1,
      thesesInstructors: instructorsJson.map((e) => ThesesInstructor.fromJson(e)).toList()
    );
  }
}