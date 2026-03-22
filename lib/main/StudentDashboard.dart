import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:universis/classes/Auth.dart';
import 'package:universis/classes/Student.dart';
import 'package:universis/loginWidgets/LoginPage.dart';
import 'package:universis/main/CoursesAndGradesPage.dart';
import 'package:universis/main/ProgressIndicatorHomeWidget.dart';
import 'package:universis/main/RecentGradesWidget.dart';
import 'package:universis/widgets/studentSheet/WelcomeWidget.dart';
import 'package:universis/widgets/studentSheet/SheetWelcomeWidget.dart';
import 'package:universis/widgets/studentSheet/SheetRow.dart';
import 'package:universis/widgets/studentSheet/LogoutWidget.dart';

class StudentDashboard extends StatefulWidget {
  final Student student;
  const StudentDashboard({Key? key, required this.student}) : super(key: key);
  @override State<StudentDashboard> createState() => _StudentDashboardState();
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


    @override Widget build(BuildContext context) {
        final items = <Widget>[
          WelcomeWidget(
            student: widget.student,
            onTap: () => _studentDetailsSheet(widget.student),
          ),

          const SizedBox(height: 16),

          ProgressIndicatorHomeWidget(student: widget.student),

          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CoursesAndGradesPage(student: widget.student)
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                //border: Border.all(color: const Color(0xFF5C6BC0), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Left side (icon + text)
                  SvgPicture.asset(
                    "assets/icons/puzzle.svg",
                    width: 26,
                    height: 26,
                    color: const Color(0xFF73818e),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Αναλυτικη Βαθμολογια",
                    style: TextStyle(
                      color: Color(0xFF73818e),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Spacer(),

                  // Right side arrow
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF73818e),
                  ),
                ],
              ),
            ),
          ),


          const SizedBox(height: 16),

          if (widget.student.recentCoursesGraded.isNotEmpty) ...[
            const SizedBox(height: 32),
            RecentGradesWidget(student: widget.student),
          ],
        ];


        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          body: SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return items[index];
              },
            ),
          ),
        );
    }
}