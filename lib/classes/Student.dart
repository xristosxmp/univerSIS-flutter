import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universis/classes/info/Semester.dart';

// ------------------------
// Student Model
// ------------------------
class Student {
  final String name;
  final String studentIdentifier;
  final String departmentName;
  final String departmentCity;
  final String programName;
  final String email;
  final String gender;
  final int semester;
  final String entryYear;
  final List<Semester> semesters;
  Student({
    required this.name,
    required this.studentIdentifier,
    required this.departmentName,
    required this.departmentCity,
    required this.programName,
    required this.email,
    required this.gender,
    required this.semester,
    required this.entryYear,
    required this.semesters
  });

  factory Student.fromJson(Map<String, dynamic> json, List<Semester> semesters) {
    return Student(
      name: json['person']['name'] ?? '',
      studentIdentifier: json['studentIdentifier'] ?? '',
      departmentName: json['department']['name'] ?? '',
      departmentCity: json['department']['city'] ?? '',
      programName: json['studyProgram']['name'] ?? '',
      email: json['person']['email'] ?? '',
      gender: json['person']['gender']['identifier'] ?? 'Α',
      semester: json['semester'] ?? -1,
      entryYear: json['inscriptionYear']['alternateName'] ?? '',
      semesters: semesters,
    );
  }
}

// ------------------------
// Fetch Student Info
// ------------------------
Future<Student> getStudentInfo(final String token) async {
  final String url = 'https://uniapi.uop.gr/api/students/me?\$expand=user,department,studyProgram,inscriptionMode,studentSeries,person(\$expand=gender,locale)&\$top=1&\$skip=0&\$count=false';
  final response = await http.get(Uri.parse(url),headers: {'Authorization': 'Bearer $token','Accept': 'application/json'});
  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    // Fetch semesters
    final List<Semester> semesters = await getSemesters(token);
    return Student.fromJson(jsonData,semesters);
  } else {
    throw Exception('Failed to fetch student data');
  }
}

Future<List<Semester>> getSemesters(String token) async {
  final String url = r"https://uniapi.uop.gr/api/students/me/courses?$expand=course($expand=locale),courseType($expand=locale),gradeExam($expand=instructors($expand=instructor($select=InstructorSummary)))&$orderby=semester%20desc,gradeYear%20desc&$top=-1&$count=false";
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Semester.fromJson(json)).toList();
  } else {
    throw Exception('Failed to fetch semesters');
  }
}

