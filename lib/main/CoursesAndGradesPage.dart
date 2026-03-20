import 'package:flutter/material.dart';
import 'package:universis/classes/Student.dart';

class CoursesAndGradesPage extends StatelessWidget {
  final Student student;

  const CoursesAndGradesPage({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    // Create a sorted copy (IMPORTANT)
    final semesters = [...student.semesters];

    // Sort by semester name (Α, Β, Γ... works fine in Greek)
    semesters.sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(

        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        elevation: 0,
        title: const Text("Βαθμολογίες"),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: semesters.length,
          itemBuilder: (context, index) {
            final semester = semesters[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📚 Semester Title
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left: Semester name
                      Text(
                        semester.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Right: Average grade container
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

                // 📖 Courses
              ...semester.courses.map((course) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
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
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              course.title,
                              style: const TextStyle(
                                fontSize: 16,
                              )
                            ),
                            const SizedBox(height: 2),
                            Text(
                              course.type,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Right side: grade
                      Container(
                        alignment: Alignment.center,
                        width: 60, // fixed width for grades
                        child: Text(
                          course.grade != null ? "${course.grade}" : "-",
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

                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}