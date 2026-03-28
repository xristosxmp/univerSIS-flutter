import 'package:flutter/material.dart';
import 'package:universis/classes/info/registrationHistory/RegistrationCourseItem.dart';
import 'package:universis/classes/info/registrationHistory/RegistrationHistoryItem.dart';

class RegistrationCourseItemDesign extends StatelessWidget {
  final RegistrationCourseItem course;
  final int index;
  final int total;

  const RegistrationCourseItemDesign({
    super.key,
    required this.course,
    required this.index,
    required this.total,
  });

  BorderRadius _getBorderRadius() {
    if (index == 0) {
      return const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      );
    } else if (index == total - 1) {
      return const BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      );
    } else {
      return BorderRadius.zero;
    }
  }

  @override Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: _getBorderRadius(),
        border: Border(
          top: index == 0
              ? const BorderSide(color: Colors.grey)
              : BorderSide.none,
          bottom: const BorderSide(color: Colors.grey),
          left: const BorderSide(color: Colors.grey),
          right: const BorderSide(color: Colors.grey),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.courseCode,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),

          Text(
            course.courseName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              course.teachers.length,
              (index) {
                final teacher = course.teachers[index];

                return Text(
                  teacher.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                );
              },
            ),
          )




      ])
    );
  }
}