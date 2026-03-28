import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:universis/classes/info/Course.dart';
import 'package:universis/classes/info/CurrentRegistration.dart';
import 'package:universis/classes/info/Department.dart';
import 'package:universis/classes/info/GraduationRule.dart';
import 'package:universis/classes/info/Semester.dart';
import 'package:universis/classes/info/Theses.dart';
import 'package:universis/classes/info/ThesesInstructor.dart';
import 'package:universis/classes/info/registrationHistory/RegistrationHistoryItem.dart';

/// ------------------------
/// Shared HTTP Client
/// ------------------------
final http.Client _client = http.Client();

Map<String, String> _headers(String token) => {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

/// ------------------------
/// Student Model
/// ------------------------
class Student {
  final String authToken;
  final String name;
  final String inscriptionName;
  final String studentIdentifier;
  final String email;
  final String gender;
  final int semester;
  final String entryYear;
  final String homeAddress;

  final List<Semester> semesters;
  final List<Course> recentCoursesGraded;

  final String averageGrade;
  final String averageGradeBasedOnEcts;
  final int totalCourses;
  final int totalPassedCourses;
  final String totalEctsGathered;

  final CurrentRegistration currentRegistration;
  final List<GraduationRule> graduationRules;
  final Department department;

  final List<Theses> theses;
  final List<RegistrationHistoryItem> registrationHistoryitem;

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
    required this.averageGradeBasedOnEcts,
    required this.totalCourses,
    required this.totalPassedCourses,
    required this.recentCoursesGraded,
    required this.currentRegistration,
    required this.graduationRules,
    required this.inscriptionName,
    required this.homeAddress,
    required this.totalEctsGathered,
    required this.theses,
    required this.registrationHistoryitem,
  });

  factory Student.fromJson(
    Map<String, dynamic> json,
    List<Semester> semesters,
    List<Course> recentCoursesGraded,
    CurrentRegistration currentRegistration,
    List<GraduationRule> graduationRules,
    List<Theses> theses,
    List<RegistrationHistoryItem> registrationHistoryitem,
    String token,
  ) {
    double totalGrade = 0;
    double totalEcts = 0;
    double weightedGrade = 0;

    int gradedCount = 0;
    int totalCourses = 0;
    int totalPassed = 0;

    for (final semester in semesters) {
      for (final course in semester.courses) {
        totalCourses++;

        final grade = double.tryParse(course.grade);
        if (grade == null) continue;

        final ects = double.tryParse(course.ects) ?? 0;

        totalGrade += grade;
        gradedCount++;

        if (course.isPassed) {
          totalPassed++;
          totalEcts += ects;
          weightedGrade += grade * ects;
        }
      }
    }

    // ✅ Safe calculations
    final averageGrade = gradedCount > 0
        ? (totalGrade / gradedCount).toStringAsFixed(2)
        : 'N/A';

    final averageGradeBasedOnEcts = totalEcts > 0
        ? (weightedGrade / totalEcts).toStringAsFixed(2)
        : '0.00';

    return Student(
      name: json['person']?['name'] ?? '',
      studentIdentifier: json['studentIdentifier'] ?? '',
      department: Department.fromJson(json),
      email: json['person']?['email'] ?? '',
      gender: json['person']?['gender']?['identifier'] ?? 'Α',
      semester: json['semester'] ?? -1,
      entryYear: json['inscriptionYear']?['alternateName'] ?? '',
      semesters: semesters,

      averageGrade: averageGrade,
      averageGradeBasedOnEcts: averageGradeBasedOnEcts,
      totalCourses: totalCourses,
      totalPassedCourses: totalPassed,
      totalEctsGathered: totalEcts.toStringAsFixed(1),

      recentCoursesGraded: recentCoursesGraded,
      authToken: token,
      currentRegistration: currentRegistration,
      graduationRules: graduationRules,

      inscriptionName:
          json["category"]?["name"] ??
          json["inscriptionMode"]?["name"] ??
          "ΦΟΙΤΗΤΗΣ",

      homeAddress: json["person"]?["homeAddress"] ?? "",
      theses: theses,
      registrationHistoryitem: registrationHistoryitem
    );
  }
}

List<Theses> getMockTheses() {
  return [
    Theses(
      thesesName: "Design and Implementation of a Mobile App",
      supervisor: "Dr. John Doe",
      grade: "9.5",
      isPassed: true,
      thesesInstructors: [
        ThesesInstructor(
          name: "Dr. John Doe",
          grade: "9.5",
        ),
        ThesesInstructor(
          name: "Prof. Alice Smith",
          grade: "9.0",
        ),
        ThesesInstructor(
          name: "Dr. Bob Johnson",
          grade: "10.0",
        ),
      ],
    ),
    Theses(
      thesesName: "Machine Learning for Predictive Analytics",
      supervisor: "Prof. Maria Papadopoulou",
      grade: "8.7",
      isPassed: true,
      thesesInstructors: [
        ThesesInstructor(
          name: "Prof. Maria Papadopoulou",
          grade: "8.7",
        ),
        ThesesInstructor(
          name: "Dr. Nikos Georgiou",
          grade: "9.0",
        ),
        ThesesInstructor(
          name: "Dr. Elena Kosta",
          grade: "8.5",
        ),
      ],
    ),
  ];
}

/// ------------------------
/// Fetch Student Info (OPTIMIZED)
/// ------------------------
Future<Student> getStudentInfo(String token) async {
  const url ='https://uniapi.uop.gr/api/students/me?\$expand=user,department,studyProgram,inscriptionMode,studentSeries,person(\$expand=gender,locale)&\$top=1&\$skip=0&\$count=false';
  final response = await _client.get(Uri.parse(url), headers: _headers(token));
  if (response.statusCode != 200) throw Exception('Failed to fetch getStudentInfo');
  final jsonData = jsonDecode(response.body);
  final results = await Future.wait([
    getSemesters(token),
    getRecentCoursesGraded(token),
    getCurrentRegistration(token),
    getGraduationRules(token),
    getTheses(token),
    getRegistrationHistory(token),
  ]);

  return Student.fromJson(
    jsonData,
    results[0] as List<Semester>,
    results[1] as List<Course>,
    results[2] as CurrentRegistration,
    results[3] as List<GraduationRule>,
    (results[4] as List<Theses>?)?.isNotEmpty == true
    ? results[4] as List<Theses>
    : getMockTheses(),
    results[5] as List<RegistrationHistoryItem>,
    token,
  );
}


Future<List<RegistrationHistoryItem>> getRegistrationHistory(String token) async {
  const url = 'https://uniapi.uop.gr/api/students/me/registrations?\$expand=classes(\$orderby=semester,course/displayCode;\$expand=course(\$expand=locale),courseClass(\$expand=instructors(\$expand=instructor(\$select=InstructorSummary))),courseType(\$expand=locale))&\$orderby=registrationYear%20desc,registrationPeriod%20desc&\$count=false';

  try {
    final response = await _client.get(Uri.parse(url), headers: _headers(token));
    final jsonData = jsonDecode(response.body);
    if (jsonData.isEmpty || response.statusCode != 200) return [];
        final data = jsonDecode(response.body)['value'] as List<dynamic>;
    if(data == null || data is! List || data.isEmpty) return [];
    return data.map((e) => RegistrationHistoryItem.fromJson(e)).toList();
  } catch (e) {
    debugPrint("ERROR getRegistrationHistory: $e");
    return [];
  }
}

/// ------------------------
/// Current Registration
/// ------------------------
Future<CurrentRegistration> getCurrentRegistration(String token) async {
  const url = 'https://uniapi.uop.gr/api/students/me/currentRegistration?\$expand=classes(\$expand=courseType(\$expand=locale),courseClass(\$expand=course(\$expand=locale),instructors(\$expand=instructor(\$select=InstructorSummary)),statistic(\$select=id,eLearningUrl,studyGuideUrl),navigationLinks))&\$top=1&\$skip=0&\$count=false';

  try {
    final response = await _client.get(Uri.parse(url), headers: _headers(token));
    final jsonData = jsonDecode(response.body);
    if (jsonData.isEmpty || response.statusCode != 200) {
      return CurrentRegistration(
        period: "",
        currentRegistrationCourses: [],
      );
    }

    final period =
        "${jsonData["registrationPeriod"]?["name"] ?? ''} "
        "${jsonData["registrationYear"]?["name"] ?? ''}";

    final courses = (jsonData['classes'] as List<dynamic>)
        .map((e) => Course.fromJsonCurrentRegistration(e))
        .toList();

    return CurrentRegistration(
      period: period,
      currentRegistrationCourses: courses,
    );
  } catch (e) {
    debugPrint("ERROR getCurrentRegistration: $e");
    return CurrentRegistration(period: "", currentRegistrationCourses: []);
  }
}


Future<List<Theses>> getTheses(String token) async {
  const url = 'https://uniapi.uop.gr/api/students/me/theses?\$expand=results(\$orderby=index;\$expand=instructor(\$select=InstructorSummary)),thesis(\$expand=instructor(\$select=InstructorSummary),locale,repositoryAction(\$expand=actionStatus))&\$top=-1&\$count=false';

  try {
    final response = await _client.get(Uri.parse(url), headers: _headers(token));
    final jsonData = jsonDecode(response.body);
    if (jsonData.isEmpty || response.statusCode != 200) return [];
    final data = jsonDecode(response.body)['value'] as List<dynamic>;
    if(data == null || data is! List || data.isEmpty) return [];
    return data.map((e) => Theses.fromJson(e)).toList();
  } catch (e) {
    debugPrint("ERROR getTheses: $e");
    return [];
  }
}

/// ------------------------
/// Semesters (OPTIMIZED)
/// ------------------------
Future<List<Semester>> getSemesters(String token) async {
  const url = r"https://uniapi.uop.gr/api/students/me/courses?$expand=course($expand=locale),courseType($expand=locale),gradeExam($expand=instructors($expand=instructor($select=InstructorSummary)))&$orderby=semester%20desc,gradeYear%20desc&$top=-1&$count=false";

  final response =
      await _client.get(Uri.parse(url), headers: _headers(token));

  if (response.statusCode != 200) {
    throw Exception('Failed to fetch getSemesters');
  }

  final data = jsonDecode(response.body)['value'] as List<dynamic>;

  final Map<String, List<Course>> grouped = {};

  for (final item in data) {
    final semesterName = item['semester']?['name'] ?? 'Unknown';

    grouped.putIfAbsent(semesterName, () => []);
    grouped[semesterName]!.add(Course.fromJson(item));
  }

  return grouped.entries.map((entry) {
    double total = 0;
    int count = 0;

    double ects = 0;
    double totalSemesterEcts = 0;


    for (final course in entry.value) {
      final grade = double.tryParse(course.grade);
      if (grade != null) {
        total += grade;
        if(course.isPassed) ects += double.parse(course.ects);
        count++;
      }
      totalSemesterEcts += double.parse(course.ects);
    }

    return Semester(
      name: entry.key,
      courses: entry.value,
      averageGrade: count > 0 ? (total / count).toStringAsFixed(2) : '-',
      ects: ects.toString(),
      totalEcts: totalSemesterEcts.toString()
    );
  }).toList();
}

/// ------------------------
/// Recent Grades
/// ------------------------
Future<List<Course>> getRecentCoursesGraded(String token) async {
  try {
    const url =
        r"https://uniapi.uop.gr/api/students/me/grades?$select=courseExam/year%20as%20gradeYear,courseExam/examPeriod%20as%20examPeriod&$orderby=courseExam/year%20desc,courseExam/examPeriod%20desc&$top=1&$skip=0&$count=false";

    final firstResponse =
        await _client.get(Uri.parse(url), headers: _headers(token));

    if (firstResponse.statusCode != 200) return [];

    final values = jsonDecode(firstResponse.body);

    if (values['value'] == null || values['value'].isEmpty) return [];

    final gradeYear = values['value'][0]['gradeYear'];
    final examPeriod = values['value'][0]['examPeriod'];

    final url2 =
        'https://uniapi.uop.gr/api/students/me/grades?'
        '\$filter=courseExam/year eq $gradeYear and courseExam/examPeriod eq $examPeriod'
        '&\$expand=status,course(\$expand=gradeScale,locale),'
        'courseClass(\$expand=instructors(\$expand=instructor(\$select=InstructorSummary))),'
        'courseExam(\$expand=examPeriod,year)&\$top=-1&\$count=false';

    final response =
        await _client.get(Uri.parse(url2), headers: _headers(token));

    if (response.statusCode != 200) return [];

    final data = jsonDecode(response.body)['value'] as List<dynamic>;

    return data.map((e) => Course.fromJsonRecent(e)).toList();
  } catch (e) {
    debugPrint("ERROR getRecentCoursesGraded: $e");
    return [];
  }
}

/// ------------------------
/// Graduation Rules
/// ------------------------
Future<List<GraduationRule>> getGraduationRules(String token) async {
  try {
    const url =
        r"https://uniapi.uop.gr/api/students/me/graduationRules?$expand=validationResult&$top=-1&$count=false";

    final response =
        await _client.get(Uri.parse(url), headers: _headers(token));

    if (response.statusCode != 200) return [];

    final data = jsonDecode(response.body)['graduationRules'] ?? [];

    return (data as List)
        .map((e) => GraduationRule.fromJson(e))
        .toList();
  } catch (e) {
    debugPrint("ERROR getGraduationRules: $e");
    return [];
  }
}