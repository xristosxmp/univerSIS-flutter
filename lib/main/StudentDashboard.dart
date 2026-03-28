import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universis/classes/Auth.dart';
import 'package:universis/classes/Student.dart';
import 'package:universis/loginWidgets/LoginPage.dart';
import 'package:universis/main/pages/CoursesAndGradesPage.dart';
import 'package:universis/main/pages/CurrentRegistrationWidget.dart';
import 'package:universis/main/pages/GraduationRulesPage.dart';
import 'package:universis/main/pages/ProgressIndicatorHomeWidget.dart';
import 'package:universis/main/pages/RecentGradesWidget.dart';
import 'package:universis/main/pages/RegistrationHistoryPage.dart';
import 'package:universis/main/pages/ThesesPage.dart';
import 'package:universis/widgets/MenuTile.dart';
import 'package:universis/widgets/studentSheet/LabelTabContainer.dart';
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
        return SafeArea(child: DraggableScrollableSheet(
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
                      SheetWelcomeWidget(gender: student.gender,name: student.name,textColor: defaultTextColor),
                      const SizedBox(height: 8),
                      SheetRow(value: student.inscriptionName,textColor: defaultTextColor,isTextCenter: true),
                      const SizedBox(height: 8),
                      /* ΠΡΟΦΙΛ */
                      RoundedTextContainer(text: "Το προφίλ μου",textColor: defaultTextColor,alignment: Alignment.centerLeft),
                      SheetRow(icon: "assets/icons/calendar.svg",value: student.entryYear,textColor: defaultTextColor,topSheetRow: true),
                      SheetRow(icon: "assets/icons/id-card.svg",value: student.studentIdentifier,textColor: defaultTextColor,middleSheetRow: true),
                      SheetRow(icon: "assets/icons/email.svg",value: student.email,textColor: defaultTextColor,middleSheetRow: true),
                      SheetRow(icon: "assets/icons/time.svg",value: student.semester.toString()+"ο Εξάμηνο",textColor: defaultTextColor,middleSheetRow: true),
                      SheetRow(icon: "assets/icons/programme.svg",value: student.department.programName,textColor: defaultTextColor,middleSheetRow: true),
                      SheetRow(icon: "assets/icons/student-home.svg",value: student.homeAddress,textColor: defaultTextColor,bottomSheetRow: true),
                      const SizedBox(height: 8),
                      /* ΤΜΗΜΑ */
                      RoundedTextContainer(text: "Τμήμα",textColor: defaultTextColor,alignment: Alignment.centerLeft),
                      if(student.department.school.isNotEmpty) SheetRow(icon: "assets/icons/building.svg",value: student.department.school,textColor: defaultTextColor,topSheetRow: true),
                      if(student.department.departmentName.isNotEmpty) SheetRow(icon: "assets/icons/category.svg",value: student.department.departmentName,textColor: defaultTextColor,middleSheetRow: true),
                      if(student.department.url.isNotEmpty) SheetRow(icon: "assets/icons/url.svg",value: student.department.url,textColor: defaultTextColor,middleSheetRow: true),
                      if(student.department.mainPhone.isNotEmpty) SheetRow(icon: "assets/icons/phone.svg",value: student.department.mainPhone,textColor: defaultTextColor,middleSheetRow: true),
                      if(student.department.altPhone.isNotEmpty) SheetRow(icon: "assets/icons/phone.svg",value: student.department.altPhone,textColor: defaultTextColor,middleSheetRow: true),
                      if(student.department.departmentCity.isNotEmpty) SheetRow(icon: "assets/icons/location.svg",value: student.department.departmentCity,textColor: defaultTextColor,bottomSheetRow: true),
                      const SizedBox(height: 8),

                      // ✅ Logout
                      LogoutWidget(onTap: () => showConfirmationDialog(context)),
                    ],
                  ),
                ),
              ],
            );
          },
        ));
      },
    );
  }


    @override Widget build(BuildContext context) {
        final items = <Widget>[
          WelcomeWidget(student: widget.student,onTap: () => _studentDetailsSheet(widget.student)),
          const SizedBox(height: 16),
          ProgressIndicatorHomeWidget(student: widget.student),
          const SizedBox(height: 16),
          MenuTile(svgPath: "assets/icons/puzzle.svg",text: "Αναλυτικη Βαθμολογια",navPage: CoursesAndGradesPage(student: widget.student)),
          const SizedBox(height: 16),         
          MenuTile(svgPath: "assets/icons/puzzle.svg",text: "Προυποθέσεις Πτυχίου",navPage: GraduationRulesPage(graduationRules: widget.student.graduationRules)),
          const SizedBox(height: 16),
          MenuTile(svgPath: "assets/icons/puzzle.svg",text: "Εργασίες",navPage: ThesesPage(theses: widget.student.theses)),
          const SizedBox(height: 16),
          MenuTile(svgPath: "assets/icons/puzzle.svg",text: "Προηγούμενες Δηλώσεις",navPage: RegistrationHistoryPage(registrationHistoryItem: widget.student.registrationHistoryitem)),
          const SizedBox(height: 16),
          if (widget.student.recentCoursesGraded.isNotEmpty) ...[
            const SizedBox(height: 32),
            RecentGradesWidget(student: widget.student),
          ],
          if(widget.student.currentRegistration.currentRegistrationCourses.isNotEmpty) ...[
            const SizedBox(height: 32),
            CurrentRegistrationWidget(period: widget.student.currentRegistration.period,courses: widget.student.currentRegistration.currentRegistrationCourses)
          ]
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