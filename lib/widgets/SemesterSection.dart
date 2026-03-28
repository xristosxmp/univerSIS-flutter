import 'package:flutter/material.dart';
import 'package:universis/classes/info/Semester.dart';
import 'package:universis/widgets/CourseTile.dart';

class SemesterSection extends StatelessWidget {
  final Semester semester;
  final String authToken;

  const SemesterSection({super.key,required this.semester, required this.authToken});

  @override Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 📚 Semester Title
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                semester.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                 Text(
                    'Μαθήματα: ${semester.courses.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    )
                  ),
                  Text(
                    'Μ.Ο Εξαμηνου: ${semester.averageGrade}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    )
                  ),
                  Text(
                  'ECTS: ${semester.ects}/${semester.totalEcts}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    )
                  )
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // 📖 Courses List
        semester.courses.isEmpty
        ? const Padding(
          padding: EdgeInsets.all(6.0),
          child: Text(
            "Δεν βρέθηκαν καταχωρημένες βαθμολογίες.",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        )
        : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: semester.courses.length,
          itemBuilder: (context, index) {
            final course = semester.courses[index];

            return CourseTile(
              course: course,
              authToken: authToken,
            );
          },
        ),
      ],
    );
  }
}