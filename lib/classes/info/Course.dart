import 'package:universis/classes/Teacher.dart';

class Course {
  final String code;
  final String title;
  final String grade;
  final bool isPassed;
  final String type;
  final String ects;
  final String gradePeriod;
  final String gradeExamId;
  final String numberOfStudents;
  final List<Teacher> teachers;



  Course({
    required this.code,
    required this.title,
    required this.grade,
    required this.isPassed,
    required this.teachers,
    required this.type,
    required this.ects,
    required this.gradePeriod,
    required this.gradeExamId,
    required this.numberOfStudents
  });

  factory Course.fromJson(final Map<String, dynamic> json) {
      final gradeExam = json['gradeExam'];

      List<Teacher> teachers = [];

      if (gradeExam != null && gradeExam['instructors'] != null) {
        teachers = (gradeExam['instructors'] as List)
            .map((t) => Teacher.fromJson(t))
            .toList();
      }

    final gradePeriod =
      (json["gradePeriodDescription"] ?? '') + " " +
      ((json["gradeYear"]?["name"]) ?? '');

    final gradeExamId = json["gradeExam"]?["id"]?.toString() ?? '';

    return Course(
      code: json['course']['id'] ?? '',
      title: json['courseTitle'] ?? '',
      grade: json['formattedGrade'] ?? '',
      isPassed: json['isPassed'] == 1,
      teachers: teachers,
      type: json['courseType']?['abbreviation'] ?? '',
      ects: json['ects'] != null ? json['ects'].toString() : '0',
      gradePeriod: gradePeriod,
      gradeExamId: gradeExamId,
      numberOfStudents: ''
    );
  }


    factory Course.fromJsonRecent(final Map<String, dynamic> json) {
      final gradeExam = json['courseClass'];

      List<Teacher> teachers = [];

      if (gradeExam != null && gradeExam['instructors'] != null) {
        teachers = (gradeExam['instructors'] as List)
            .map((t) => Teacher.fromJson(t))
            .toList();
      }

    return Course(
      code: json['courseExam']['course'] ?? '',
      title: json['courseClass']['title'] ?? '',
      grade: json['formattedGrade'] ?? '',
      isPassed: json['isPassed'] == 1,
      teachers: teachers,
      type: '',
      ects: json["course"]['ects'] != null ? json['ects'].toString() : '0',
      gradePeriod: '',
      gradeExamId: '',
      numberOfStudents: ''
    );
  }


  
    factory Course.fromJsonCurrentRegistration(final Map<String, dynamic> json) {
      final courseClass = json['courseClass'];

      List<Teacher> teachers = [];

      if (courseClass != null && courseClass['instructors'] != null) {
        teachers = (courseClass['instructors'] as List)
            .map((t) => Teacher.fromJson(t))
            .toList();
      }



    return Course(
      code: courseClass['course']['id'] ?? '',
      title: courseClass['course']['name'] ?? '',
      grade: '',
      isPassed: false,
      teachers: teachers,
      type: json["courseType"]["abbreviation"],
      ects: json['ects'] != null ? json['ects'].toString() : '0',
      gradePeriod: '',
      gradeExamId: '',
      numberOfStudents: courseClass["numberOfStudents"]!= null ? courseClass['numberOfStudents'].toString() : '-',
    );
  }
}