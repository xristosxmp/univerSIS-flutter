import 'package:flutter/material.dart';
import 'package:universis/classes/Student.dart';
import 'package:universis/main/CourseDetailsPage.dart';

class CoursesAndGradesPage extends StatelessWidget {
  final Student student;

  const CoursesAndGradesPage({super.key,required this.student});

  @override Widget build(final BuildContext context) {
    // Create a sorted copy (IMPORTANT)
    final semesters = [...student.semesters];
    semesters.sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        elevation: 0,
      ),
      body: SafeArea(
        child: semesters.length == 0 ? 
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,height: 160,
            padding: const EdgeInsets.all(16), // inner padding for the text
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12), // rounded corners
            ),
            child: Center(
              child: Text(
                "Δεν βρέθηκαν καταχωρημένες βαθμολογίες.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500, // medium weight
                  color: Color(0xFF536C79), // hex color 536c79
                ),
              ),
            ),
          ),
        )
        
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: semesters.length,
          itemBuilder: (context, semIndex) {
            final semester = semesters[semIndex];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📚 Semester Title
                Container(
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
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Μ.Ο Εξαμηνου',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              semester.averageGrade,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // 📖 Courses (ListView.builder)
                ListView.builder(
                  shrinkWrap: true, // important to make nested ListView work
                  physics: const NeverScrollableScrollPhysics(), // disable inner scrolling
                  itemCount: semester.courses.length,
                  itemBuilder: (context, courseIndex) {
                    final course = semester.courses[courseIndex];
                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseDetailsPage(course: course, token: student.authToken),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Left side: code, title, type
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
                                if(!course.gradePeriod.trim().isEmpty)
                                const SizedBox(height: 2),
                                if(!course.gradePeriod.trim().isEmpty)                      
                                Text(
                                  course.gradePeriod.trim().isEmpty ? '' : course.gradePeriod,
                                  style: const TextStyle(
                                    fontSize: 12
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Right side: grade
                          Container(
                            alignment: Alignment.center,
                            width: 60,
                            child: Text(
                              course.grade != null && course.grade.isNotEmpty ? "${course.grade}" : "-",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: course.grade.isEmpty ? Colors.black : course.isPassed ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ));
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}