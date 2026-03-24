import 'package:flutter/material.dart';
import 'package:universis/classes/Student.dart';
import 'package:universis/main/CourseDetailsPage.dart';
import 'package:universis/services/PdfService.dart';

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
        child: semesters.isEmpty
      ? Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            height: 160,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                "Δεν βρέθηκαν καταχωρημένες βαθμολογίες.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF536C79),
                ),
              ),
            ),
          ),
        )
      : Column(
          children: [
                        // 🔘 BUTTON
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const Center(child: CircularProgressIndicator()),
                    );

                    final file = await PdfService.generateGradesPdf(semesters);

                    Navigator.pop(context); // close loading

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 10),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                        padding: EdgeInsets.zero, // important for custom layout
                        elevation: 8,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),

                        content: Stack(
                          children: [
                            // 🔲 Main Content
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Center(
                                    child: Text(
                                      "Το PDF δημιουργήθηκε επιτυχώς",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  Center(
                                    child: TextButton(
                                      onPressed: () {
                                        PdfService.openFile(file);
                                      },
                                      child: const Text("Ανοιγμα αρχειου PDF"),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ❌ Close Button (top right)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                icon: const Icon(Icons.close,color: Colors.white),
                                splashRadius: 20,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Εκτύπωση Αναλυτικής",
                    style: TextStyle(
                      color: Color(0xFF151B1E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
           Expanded(
              child: ListView.builder(
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
           )),
      ])),
    );
  }
}