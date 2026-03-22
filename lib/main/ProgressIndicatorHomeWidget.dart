import 'package:flutter/material.dart';
import 'package:linear_progress_bar/ui/circular_percent_indicator.dart';
import 'package:universis/classes/Student.dart';

class ProgressIndicatorHomeWidget extends StatelessWidget {
  final Student student;

  const ProgressIndicatorHomeWidget({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    final percent = ((double.tryParse(student.averageGrade) ?? 0) / 10).clamp(0.0, 1.0);  
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(46),
          bottomLeft: Radius.circular(46),
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          // 🔵 Circular Progress
          CircularPercentIndicator(
            percent: percent,
            radius: 40,
            lineWidth: 6,
            progressColor: const Color(0xFFc41162),
            backgroundColor: Colors.transparent,
            circularStrokeCap: CircularStrokeCap.round,
            startAngle: CircularStartAngle.bottom,
            spacing: 0.0,
            arcType: ArcType.full,
            center: Text(
              "${student.averageGrade}\nΜ.Ο",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 📊 Stats Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Courses
              const Text(
                "Δηλωμένα Μαθήματα",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3E515B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                student.totalCourses.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Passed Courses
              const Text(
                "Περασμένα Μαθήματα",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3E515B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                student.totalPassedCourses.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}