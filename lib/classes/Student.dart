import 'dart:convert';
import 'package:http/http.dart' as http;

// ------------------------
// Student Model
// ------------------------
class Student {
  final int id;
  final String name;
  final String studentIdentifier;
  final String departmentName;
  final String programName;
  final String email;
  final String gender;

  Student({
    required this.id,
    required this.name,
    required this.studentIdentifier,
    required this.departmentName,
    required this.programName,
    required this.email,
    required this.gender
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['person']['name'] ?? '',
      studentIdentifier: json['studentIdentifier'] ?? '',
      departmentName: json['department']['name'] ?? '',
      programName: json['studyProgram']['name'] ?? '',
      email: json['person']['email'] ?? '',
      gender: json['person']['gender']['identifier'] ?? 'Α',
    );
  }
}

// ------------------------
// Fetch Student Info
// ------------------------
Future<Student> getStudentInfo(final String token) async {
  final String url = 'https://uniapi.uop.gr/api/students/me?\$expand=user,department,studyProgram,inscriptionMode,studentSeries,person(\$expand=gender,locale)&\$top=1&\$skip=0&\$count=false';

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    return Student.fromJson(jsonData);
  } else {
    throw Exception('Failed to fetch student data');
  }
}
