import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:universis/classes/info/Course.dart';
import 'package:universis/classes/info/CurrentRegistration.dart';
import 'package:universis/classes/info/Department.dart';
import 'package:universis/classes/info/GraduationRule.dart';
import 'package:universis/classes/info/Semester.dart';

// ------------------------
// Student Model
// ------------------------
class Student {
  final String authToken;
  final String name;
  final String inscriptionName; // Μεταπτυχιακός/Προπτυχιακός κτλπ
  final String studentIdentifier;
  final String email;
  final String gender;
  final int semester;
  final String entryYear;
  final String homeAddress;
  final List<Semester> semesters;
  final List<Course> recentCoursesGraded;
  final String averageGrade;
  final int totalCourses;
  final int totalPassedCourses;
  final CurrentRegistration currentRegistration;
  final List<GraduationRule> graduationRules;
  final Department department;




  Student({
    required this.authToken,
    required this.name,
    required this.studentIdentifier,
    required this.department,
    required this.email,
    required this.gender,
    required this.semester,
    required this.entryYear,
    required this.semesters,
    required this.averageGrade,
    required this.totalCourses,
    required this.totalPassedCourses,
    required this.recentCoursesGraded,
    required this.currentRegistration,
    required this.graduationRules,
    required this.inscriptionName,
    required this.homeAddress,
  });

  factory Student.fromJson(
    final Map<String, dynamic> json, 
    final List<Semester> semesters,
    final List<Course> recentCoursesGraded,
    final CurrentRegistration currentRegistration,
    final List<GraduationRule> graduationRules,
    final String token,
    ) {
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

    final Department dept = Department.fromJson(json);

    final avgGrade = count > 0 ? (total / count).toStringAsFixed(2) : 'N/A';
    return Student(
      name: json['person']?['name'] ?? '',
      studentIdentifier: json['studentIdentifier'] ?? '',
      department: dept,
      email: json['person']?['email'] ?? '',
      gender: json['person']?['gender']['identifier'] ?? 'Α',
      semester: json['semester'] ?? -1,
      entryYear: json['inscriptionYear']?['alternateName'] ?? '',
      semesters: semesters,
      averageGrade: avgGrade,
      totalCourses: totalCourses,
      totalPassedCourses: totalPassed,
      recentCoursesGraded: recentCoursesGraded,
      authToken: token,
      currentRegistration: currentRegistration,
      graduationRules: graduationRules,
      inscriptionName: json["inscriptionMode"]?["name"]?? "ΦΟΙΤΗΤΗΣ",
      homeAddress: json["person"]?["homeAddress"] ?? ""
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
    final List<Semester> semesters = await getSemesters(token) ?? [];
    final List<Course> recentCoursesGraded = await getRecentCoursesGraded(token) ?? [];
    final CurrentRegistration currentRegistration = await getCurrentRegistration(token);
    final List<GraduationRule> graduationRules = await getGraduationRules(token) ?? [];
    return Student.fromJson(jsonData,semesters,recentCoursesGraded,currentRegistration,graduationRules,token);
  } else {
    throw Exception('Failed to fetch student data');
  }
}

Future<CurrentRegistration> getCurrentRegistration(final String token) async {
  final String url = 'https://uniapi.uop.gr/api/students/me/currentRegistration?\$expand=classes(\$expand=courseType(\$expand=locale),courseClass(\$expand=course(\$expand=locale),instructors(\$expand=instructor(\$select=InstructorSummary)),statistic(\$select=id,eLearningUrl,studyGuideUrl),navigationLinks))&\$top=1&\$skip=0&\$count=false';
  final response = await http.get(Uri.parse(url),headers: {'Authorization': 'Bearer $token','Accept': 'application/json'});
  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    debugPrint(jsonData.entries.toString());
    final period =
      (jsonData["registrationPeriod"]?["name"] ?? '') + " " +
      ((jsonData["registrationYear"]?["name"]) ?? '');

    final List<dynamic> data = jsonData['classes'];
    final List<Course> courses = data.map((item) => Course.fromJsonCurrentRegistration(item)).toList();
    return CurrentRegistration(period: period ,currentRegistrationCourses: courses);
  } else {
    throw Exception('Failed to fetch student data');
  }

 
}

// Contains grades-courses
Future<List<Semester>> getSemesters(final String token) async {
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

// Contains grades-courses
Future<List<Course>> getRecentCoursesGraded(final String token) async {
  try {
    String url = r"https://uniapi.uop.gr/api/students/me/grades?$select=courseExam/year%20as%20gradeYear,courseExam/examPeriod%20as%20examPeriod&$orderby=courseExam/year%20desc,courseExam/examPeriod%20desc&$top=1&$skip=0&$count=false";

    final courseExamResponse = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (courseExamResponse.statusCode != 200) return [];

    final Map<String, dynamic> values = jsonDecode(courseExamResponse.body);

    if (values['value'] == null || values['value'].isEmpty) return [];

    final int gradeYear = values['value'][0]['gradeYear'] ?? 0;
    final int examPeriod = values['value'][0]['examPeriod'] ?? 0;

    final url2 = r'https://uniapi.uop.gr/api/students/me/grades?'
        r'$filter=courseExam/year eq ' + gradeYear.toString() +
        r' and courseExam/examPeriod eq ' + examPeriod.toString() +
        r'&$expand=status,course($expand=gradeScale,locale),'
        r'courseClass($expand=instructors($expand=instructor($select=InstructorSummary))),'
        r'courseExam($expand=examPeriod,year)&$top=-1&$count=false';

    final response = await http.get(
      Uri.parse(url2),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) return [];

    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final List<dynamic> data = jsonData['value'] ?? [];

    return data.map((item) => Course.fromJsonRecent(item)).toList();
  } catch (e) {
    debugPrint("ERROR getRecentCoursesGraded: $e");
    return []; // 🔥 ALWAYS RETURN LIST
  }
}

Future<List<GraduationRule>> getGraduationRules(final String token) async {
  try {
    String url = r"https://uniapi.uop.gr/api/students/me/graduationRules?$expand=validationResult&$top=-1&$count=false";

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) return [];
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final List<dynamic> data = jsonData['graduationRules'] ?? [];
    return data.map((item) => GraduationRule.fromJson(item)).toList();
  } catch (e) {
    return []; // 🔥 ALWAYS RETURN LIST
  }
}

