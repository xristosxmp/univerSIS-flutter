import 'package:flutter/material.dart';
import 'package:universis/classes/info/Course.dart';

class CurrentRegistrationWidget extends StatelessWidget {
  final String period;
  final List<Course> courses;
  const CurrentRegistrationWidget({super.key,required this.period,required this.courses});

  @override Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Τα μαθήματα μου",
            style: TextStyle(
              color: Color(0xFF3E515B),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            period,
            style: TextStyle(
              color: Color(0xFF3E515B),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 8),

          ...courses.map((course) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left side
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.code,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          course.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight(600)
                          ),
                        ),

                        ...course.teachers.map((teacher){
                            return Text(teacher.name, style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight(300),
                              ));
                        }).toList()

                      ],
                    ),
                  ),

                  // Right side (grade)
                  Container(
                    alignment: Alignment.center,
                    width: 60,
                    child: Text(
                      course.grade,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: course.isPassed ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}