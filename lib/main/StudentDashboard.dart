import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:linear_progress_bar/ui/circular_percent_indicator.dart';
import 'package:universis/classes/Auth.dart';
import 'package:universis/classes/Student.dart';
import 'package:universis/loginWidgets/LoginPage.dart';
import 'package:universis/main/CoursesAndGradesPage.dart';
import 'package:universis/widgets/studentSheet/WelcomeWidget.dart';
import 'package:universis/widgets/studentSheet/SheetWelcomeWidget.dart';
import 'package:universis/widgets/studentSheet/SheetRow.dart';
import 'package:universis/widgets/studentSheet/LogoutWidget.dart';

class StudentDashboard extends StatefulWidget {
  final Student student;

  const StudentDashboard({Key? key, required this.student}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {

  Future<bool?> showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return CupertinoAlertDialog(
          title: const Text("Αποσύνδεση"),
          content: const Text("Είστε σίγουροι ότι θέλετε να αποσυνδεθείτε;"),
          actions: [
            CupertinoDialogAction(
              child: const Text('Ακύρωση'),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Αποσύνδεση'),
              onPressed: () async {
                await Auth.deleteStudent();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _studentDetailsSheet(final Student student) {
    const Color defaultTextColor = Color(0xFF3E515B);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.95,
          minChildSize: 0.3,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [

                      // ✅ Welcome card
                      SheetWelcomeWidget(
                        gender: student.gender,
                        name: student.name,
                        textColor: defaultTextColor,
                      ),

                      const SizedBox(height: 8),

                      // ✅ Info rows
                      SheetRow(
                        icon: "assets/icons/calendar.svg",
                        value: student.entryYear,
                        textColor: defaultTextColor,
                      ),
                      const SizedBox(height: 8),

                      SheetRow(
                        icon: "assets/icons/id-card.svg",
                        value: student.studentIdentifier,
                        textColor: defaultTextColor,
                      ),
                      const SizedBox(height: 8),

                      SheetRow(
                        icon: "assets/icons/building.svg",
                        value: student.departmentName,
                        textColor: defaultTextColor,
                      ),
                      const SizedBox(height: 8),

                      SheetRow(
                        icon: "assets/icons/programme.svg",
                        value: student.programName,
                        textColor: defaultTextColor,
                      ),
                      const SizedBox(height: 8),

                      SheetRow(
                        icon: "assets/icons/location.svg",
                        value: student.departmentCity,
                        textColor: defaultTextColor,
                      ),

                      const SizedBox(height: 8),

                      // ✅ Logout
                      LogoutWidget(
                        onTap: () => showConfirmationDialog(context),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              WelcomeWidget(
                student: widget.student,
                onTap: () => _studentDetailsSheet(widget.student),
              ),

              const SizedBox(height: 16),
Container(
  padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
  decoration: BoxDecoration(
    color: Colors.white, // white background
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(46),
      bottomLeft: Radius.circular(46),
      topRight: Radius.circular(16),
      bottomRight: Radius.circular(16),
    ), // rounded corners
  ),
  child: Row(
    children: [
      CircularPercentIndicator(
        percent: 1.0, // (double.tryParse(widget.student.averageGrade) ?? 0) / 10,
        radius: 40,
        lineWidth: 6,
        progressColor: const Color(0xFFc41162),
        backgroundColor: Colors.transparent,
        circularStrokeCap: CircularStrokeCap.round,
        startAngle: CircularStartAngle.bottom,
        spacing: 0.0,
        arcType: ArcType.full,
        center: Text(
          "${widget.student.averageGrade}\nΜ.Ο",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(width: 16), // spacing between circle and text column
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          // First row: label and number
          Text(
            "Δηλωμένα Μαθήματα",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 2),
          Text(
            widget.student.totalCourses?.toString() ?? '0', // example number, replace with your value
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),

          // Example of adding another metric
          Text(
            "Passed Courses",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 2),
          Text(
            widget.student.totalPassedCourses?.toString() ?? '0', // example number
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ],
  ),
)




            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            surfaceTintColor: Colors.transparent,
            color: Colors.transparent,
            child: Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CoursesAndGradesPage(student: widget.student),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset("assets/icons/progress.svg", width: 26, height: 26, color: const Color(0xFF5C6BC0)),
                    Text("Grades"),
                  ],
                ),
              ),
            ),
        ),

      );
    }
}