import 'package:flutter/material.dart';
import 'package:universis/classes/Student.dart';

class StudentDashboard extends StatefulWidget {
  final Student student;
  const StudentDashboard({Key? key, required this.student}) : super(key: key);
  @override State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {

  @override Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text("test")
          ],
        ),
      ),
    );
  }
}
