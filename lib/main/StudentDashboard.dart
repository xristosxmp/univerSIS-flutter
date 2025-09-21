import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:universis/classes/Auth.dart';
import 'package:universis/classes/Student.dart';
import 'package:universis/loginWidgets/LoginPage.dart';

class StudentDashboard extends StatefulWidget {
  final Student student;
  const StudentDashboard({Key? key, required this.student}) : super(key: key);
  @override State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {

Widget _buildSheetWelcomeWidget(final String gender, final String name, final Color defaultTextColor){
                          return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    gender == 'Α'
                                        ? 'assets/images/male-gender.svg'
                                        : 'assets/images/female-gender.svg',
                                    width: 72,
                                    height: 72,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    name,
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: defaultTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
}
Widget _buildColoredBall(Color color) {
  return Container(
    width: 24,
    height: 24,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 2),
    ),
  );
}
Widget _buildHalfColoredBall(Color leftColor, Color rightColor) {
  return SizedBox(
    width: 24,
    height: 24,
    child: Stack(
      children: [
        // Right half
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 12,
            height: 24,
            decoration: BoxDecoration(
              color: rightColor,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(12),
              ),
            ),
          ),
        ),
        // Left half
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 12,
            height: 24,
            decoration: BoxDecoration(
              color: leftColor,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
Widget _buildSemesterWidget(final String start,final String center,final String end, final int semester) {
  const ballSize = 24.0;
  const lineHeight = 2.0;
  const lineColor = Color(0xFFBDBDBD); // gray line
  const activeColor = Color(0xFF5C6BC0); // purple

  return SizedBox(
    height: 80, // More height to fit all three labels
    child: Stack(
      children: [
        // Horizontal line centered
        Positioned(
          top: (80 - lineHeight) / 2,
          left: 0,
          right: 0,
          child: Container(
            height: lineHeight,
            color: lineColor,
          ),
        ),

        // Balls aligned on the line
        Positioned(
          top: (80 - ballSize) / 2,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if(semester == 1)... [
                _buildHalfColoredBall(activeColor, Colors.grey),
                _buildColoredBall(Colors.grey),
                _buildColoredBall(Colors.grey)
              ]else if(semester != 1) ...[
                _buildColoredBall(activeColor),
                _buildHalfColoredBall(activeColor, Colors.grey),
                _buildColoredBall(Colors.grey),
              ]
            ],
          ),
        ),

        // Labels under each ball
        Positioned(
          top: ((80 - ballSize) / 2) + ballSize + 6,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                start,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Text(
                center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Text(
                end,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
Widget _buildSheetRow(final String iconAsset, final String value, final Color defaultTextColor){
                return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:                         Row(children: [
                          SvgPicture.asset(width:26,height: 26,iconAsset,color: Color(0xFF5C6BC0)),
                          const SizedBox(width: 16),
                          Expanded(child:
                          Text(
                            value,
                            textAlign: TextAlign.start,
                            softWrap: true,
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal, color: defaultTextColor),
                          )),  
                    ])
                  );
}
Future<bool?> showConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) {
      return CupertinoAlertDialog(
        title: Text("Αποσύνδεση"),
        content: Text("Είστε σίγουροι ότι θέλετε να αποσυνδεθείτε;"),
        actions: [
          CupertinoDialogAction(
            child: Text('Ακύρωση'),
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text('Αποσύνδεση'),
            onPressed: () async {
              await Auth.deleteStudent();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ],
      );
    },
  );
}
Widget _buildDisconnectionWidget(final String iconAsset, BuildContext sheetContext) {
  return GestureDetector(
    onTap: () => showConfirmationDialog(sheetContext), // Pass the sheet's context
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
              width: 26,
              height: 26,
              iconAsset,
              color: const Color(0xffDE3163)),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Αποσύνδεση',
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Color(0xffDE3163)),
            ),
          ),
        ],
      ),
    ),
  );
}

void _studentDetailsSheet(final Student student){
    const Color defaultTextColor = const Color(0xFF3E515B);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Enables full height
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
                // Drag marker
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // Content
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                        
                         _buildSheetWelcomeWidget(student.gender,student.name,defaultTextColor),

                        const SizedBox(height: 8),
                        if(student.semester != 1)
                          _buildSemesterWidget((student.semester-1).toString()+'ο Εξάμηνο',(student.semester).toString()+'ο Εξάμηνο',(student.semester+1).toString()+'ο Εξάμηνο',student.semester)
                        else _buildSemesterWidget((student.semester).toString()+'ο Εξάμηνο',(student.semester+1).toString()+'ο Εξάμηνο',(student.semester+2).toString()+'ο Εξάμηνο',student.semester),
                        const SizedBox(height: 8),
                        _buildSheetRow("assets/icons/calendar.svg",student.entryYear,defaultTextColor),
                        const SizedBox(height: 8),
                        _buildSheetRow("assets/icons/id-card.svg",student.studentIdentifier,defaultTextColor),
                        const SizedBox(height: 8),
                        _buildSheetRow("assets/icons/building.svg",student.departmentName,defaultTextColor),
                        const SizedBox(height: 8),
                        _buildSheetRow("assets/icons/programme.svg",student.programName,defaultTextColor),
                        const SizedBox(height: 8),
                        _buildSheetRow("assets/icons/location.svg",student.departmentCity,defaultTextColor),
                        const SizedBox(height: 8),
                        _buildDisconnectionWidget("assets/icons/logout.svg",context)
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
Widget _buildWelcomeWidget() {
  const Color defaultTextColor = const Color(0xFF3E515B);
  return 
    Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start, 
    children: [

            Expanded(child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
              Text(
                  "Πίνακας Ελέγχου",
                  style: const TextStyle(color: defaultTextColor,fontSize: 26,fontWeight: FontWeight.bold),
                ),
                 Text(
                    widget.student.name,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: const TextStyle(fontSize: 16,fontWeight: FontWeight.normal, color: defaultTextColor),
                  ),
            ])),
 
          GestureDetector(
            onTap:() => _studentDetailsSheet(widget.student),
            child: SvgPicture.asset(
              width: 72,
              height: 72,
              widget.student.gender == 'Α'
                  ? 'assets/images/male-gender.svg'
                  : 'assets/images/female-gender.svg',
            ),
          )
        ],
  );
}


  @override Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildWelcomeWidget()
          ],
        ),
      ),
    );
  }
}
