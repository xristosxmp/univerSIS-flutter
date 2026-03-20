import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:universis/classes/info/Course.dart';
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
  final String averageGrade;
  final int totalCourses;
  final int totalPassedCourses;
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
    required this.semesters,
    required this.averageGrade,

    required this.totalCourses,
    required this.totalPassedCourses,
  });

  factory Student.fromJson(Map<String, dynamic> json, List<Semester> semesters) {
    double total = 0;
    int count = 0;
    int totalCourses = 0;
    int totalPassed = 0;
  

    for (var semester in semesters) {
      for (var course in semester.courses) {
        final grade = double.tryParse(course.grade);
        totalCourses+=1;
        if (grade != null) {
          if(course.isPassed) totalPassed+=1;


          total += grade;
          count++;
        }
      }
    }

    final avgGrade = count > 0 ? (total / count).toStringAsFixed(2) : 'N/A';
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
      averageGrade: avgGrade,
      totalCourses: totalCourses,
      totalPassedCourses: totalPassed,
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

// Contains grades-courses
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
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final List<dynamic> data = jsonData['value'];
    // Map<semesterName, List<Course>>
    final Map<String, List<Course>> grouped = {};
    for (var item in data) {
      final String semesterName = item['semester']['name'] ?? 'Unknown';
      final course = Course.fromJson(item);
      if (!grouped.containsKey(semesterName)) grouped[semesterName] = [];
    
      grouped[semesterName]!.add(course);
    }

    // Convert to List<Semester>
    return grouped.entries.map((entry) {
   final courses = entry.value;

      // Calculate average grade for this semester
      double total = 0;
      int count = 0;
      for (var course in courses) {
        final gradeValue = double.tryParse(course.grade);
        if (gradeValue != null) {
          total += gradeValue;
          count++;
        }
      }
      final avg = count > 0 ? (total / count) : 0.0;
      final avgStr = avg > 0 ? avg.toStringAsFixed(2) : '-';

      return Semester(
        name: entry.key,
        courses: courses,
        averageGrade: avgStr,
      );
    }).toList();
  } else {
    throw Exception('Failed to fetch semesters');
  }
}

