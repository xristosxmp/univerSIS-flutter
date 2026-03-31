// CourseDetailsPage.dart
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:linear_progress_bar/ui/circular_percent_indicator.dart';
import 'package:universis/classes/info/Course.dart';
import 'package:universis/main/pages/CourseStatisticsWidget.dart';

class CourseDetailsPage extends StatelessWidget {
  final Course course;
  final String token;
  const CourseDetailsPage({super.key, required this.course, required this.token});

  @override Widget build(BuildContext context) {
    // Define all the sections as strings
    final _items = [
      'gradeIndicator',
      'titleCard',
      'typeAndEcts',
      'teachersCard',
      'examAndCode',
      'statistics', 
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) {
              switch (_items[index]) {
                case 'gradeIndicator':
                  return _buildGradeIndicator();
                case 'titleCard':
                  return _buildTitleCard();
                case 'typeAndEcts':
                  return _buildInfoRow("Τύπος", course.type, "ECTS", course.ects);
                case 'teachersCard':
                  return _buildTeachersCard();
                case 'examAndCode':
                  return _buildInfoRow(
                      "Εξεταστική", course.gradePeriod.trim().isEmpty ? "-" : course.gradePeriod,
                      "Κωδικός", course.code);
                case 'statistics':
                  if(course.gradeExamId != null && course.gradeExamId.trim().isNotEmpty)
                    return CourseStatisticsWidget(
                      token: token,  
                      examPeriodId: course.gradeExamId, // make sure Course has this field as int
                    );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }

  // -------------------- PRIVATE WIDGETS --------------------

Widget _buildGradeIndicator() {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(16), // inner padding
      decoration: BoxDecoration(
        color: Colors.white, // white background
        borderRadius: BorderRadius.circular(120), // rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // subtle shadow
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircularPercentIndicator(
        percent: (double.tryParse(course.grade ?? '0') ?? 0) / 10,
        radius: 60,
        lineWidth: 6,
        progressColor: Colors.green,
        backgroundColor: Colors.grey.shade200,
        circularStrokeCap: CircularStrokeCap.round,
        startAngle: CircularStartAngle.bottom,
        spacing: 0.0,
        arcType: ArcType.half,
        center: Text(
          course.grade.isEmpty ? "-" : course.grade,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            color: course.grade.isEmpty
                ? Colors.black
                : course.isPassed
                    ? Colors.green
                    : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

  Widget _buildTitleCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            course.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String leftLabel, String leftValue, String rightLabel, String rightValue) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          // Left container
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    leftLabel,
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                    minFontSize: 11,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 6),
                  AutoSizeText(
                    textAlign: TextAlign.left,
                    leftValue,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    minFontSize: 11,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),

          // Right container
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(left: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    rightLabel,
                    style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                    minFontSize: 11,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 6),
                  AutoSizeText(
                    rightValue,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    minFontSize: 11,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeachersCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AutoSizeText(
              "Καθηγητής",
              style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
              minFontSize: 11,
              maxLines: 1,
            ),
            const SizedBox(height: 6),
            if (course.teachers.isNotEmpty)
              ...course.teachers.map(
                (teacher) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: AutoSizeText(
                    teacher.name,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    minFontSize: 11,
                    maxLines: 1,
                  ),
                ),
              )
            else
              const AutoSizeText(
                "-",
                style: TextStyle(fontSize: 14, color: Colors.black),
                minFontSize: 11,
                maxLines: 1,
              ),
          ],
        ),
      ),
    );
  }
}