import 'package:flutter/widgets.dart';

class Department {
  final String departmentName;
  final String departmentCity;
  final String programName;
  final String school;
  final String url;
  final String email;
  final String mainPhone;
  final String altPhone;
  Department({
    required this.departmentName,
    required this.departmentCity,
    required this.programName,
    required this.school,
    required this.url,
    required this.email,
    required this.mainPhone,
    required this.altPhone,
  });

  factory Department.fromJson(final Map<String, dynamic> json) {
    debugPrint(json.toString());
    return Department(
      departmentName: json["department"]?['name'] ?? '',
      departmentCity: json["department"]?['city'] ?? '',
      programName: json['studyProgram']?['name'] ?? '',
      school: json["department"]?["facultyName"] ?? '',
      url: json["department"]?["url"] ?? '',
      email: json["department"]?["email"] ?? '',
      mainPhone: json["department"]?["phone1"] ?? '',
      altPhone: json["department"]?["phone2"] ?? '',
    );
  }
}