import 'package:flutter/material.dart';
import 'package:universis/classes/Student.dart';
import 'package:universis/classes/info/Semester.dart';
import 'package:universis/widgets/GeneratePdfButton.dart';
import 'package:universis/widgets/InfoRow.dart';
import 'package:universis/widgets/SemesterSection.dart';

class CoursesAndGradesPage extends StatefulWidget {
  final Student student;
  const CoursesAndGradesPage({super.key, required this.student});
  @override State<CoursesAndGradesPage> createState() => _CoursesAndGradesPageState();
}

class _CoursesAndGradesPageState extends State<CoursesAndGradesPage> {
  int selectedButtonIndex = 0;

  @override Widget build(BuildContext context) {
    final semesters = [...widget.student.semesters];
    semesters.sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(surfaceTintColor: Colors.transparent,backgroundColor: const Color.fromARGB(255, 240, 240, 240),elevation: 0),
      body: SafeArea(
        child: semesters.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  height: 160,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(12)),
                  child: const Center(
                    child: Text(
                      "Δεν βρέθηκαν καταχωρημένες βαθμολογίες.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w500,color: Color(0xFF536C79)),
                    ),
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: semesters.length + 1, // +1 for buttons section
                itemBuilder: (context, index) {
                  // 🔘 BUTTONS SECTION (FIRST ITEM)
                  if (index == 0) {
                    return Column(
                      children: [
                        GeneratePdfButton(semesters: semesters),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),width: double.infinity,
                          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InfoRow(label: "Δηλωμένα Μαθήματα",value: widget.student.totalCourses.toString()),
                              InfoRow(label: "Περασμένα Μαθήματα",value: widget.student.totalPassedCourses.toString()),
                              InfoRow(label: "ECTS",value: widget.student.totalEctsGathered),
                              Divider(color: const Color(0xFF536c79),thickness: 1,height: 25),
                              InfoRow(label: "Μέσος Όρος με συντελεστές",value: widget.student.averageGradeBasedOnEcts),
                              InfoRow(label: "Μέσος Όρος",value: widget.student.averageGrade),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // 🔘 Toggle Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedButtonIndex = 0;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      selectedButtonIndex == 0
                                          ? const Color(0xFF20A8D8)
                                          : Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                ),
                                child: Text(
                                  "Όλα τα μαθήματα",
                                  style: TextStyle(
                                      color: selectedButtonIndex == 0
                                          ? Colors.white
                                          : Colors.grey,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedButtonIndex = 1;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      selectedButtonIndex == 1
                                          ? const Color(0xFF20A8D8)
                                          : Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                ),
                                child: Text(
                                  "Μόνο περασμένα",
                                  style: TextStyle(
                                      color: selectedButtonIndex == 1
                                          ? Colors.white
                                          : Colors.grey,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }

                  // 📚 SEMESTERS (shift index by -1)
                  final semester = semesters[index - 1];

                  // 🔹 Filter courses based on selected button
                  final filteredSemester = Semester(
                    name: semester.name,
                    courses: selectedButtonIndex == 0
                        ? semester.courses
                        : semester.courses.where((course) => course.isPassed).toList(),
                    averageGrade: semester.averageGrade,
                    ects: semester.ects,
                    totalEcts: semester.totalEcts,
                  );

                  return SemesterSection(
                    semester: filteredSemester,
                    authToken: widget.student.authToken,
                  );
                },
              ),
      ),
    );
  }
}