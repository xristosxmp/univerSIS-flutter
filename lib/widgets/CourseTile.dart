import 'package:flutter/material.dart';
import 'package:universis/main/pages/CourseDetailsPage.dart';

class CourseTile extends StatelessWidget {
  final dynamic course;
  final String authToken;

  const CourseTile({
    super.key,
    required this.course,
    required this.authToken,
  });

  @override
  Widget build(BuildContext context) {
    final hasGradePeriod = course.gradePeriod.trim().isNotEmpty;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsPage(
              course: course,
              token: authToken,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Left side
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.code,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (hasGradePeriod) const SizedBox(height: 2),
                  if (hasGradePeriod)
                    Text(
                      course.gradePeriod,
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
            ),

            // Right side (grade)
            SizedBox(
              width: 60,
              child: Text(
                (course.grade != null && course.grade.isNotEmpty)
                    ? "${course.grade}"
                    : "-",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: course.grade.isEmpty
                      ? Colors.black
                      : course.isPassed
                          ? Colors.green
                          : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}