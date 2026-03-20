import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:universis/classes/Student.dart';

class WelcomeWidget extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;

  const WelcomeWidget({
    Key? key,
    required this.student,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color defaultTextColor = Color(0xFF3E515B);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Πίνακας Ελέγχου",
                style: TextStyle(
                  color: defaultTextColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                student.name,
                style: const TextStyle(
                  fontSize: 16,
                  color: defaultTextColor,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: SvgPicture.asset(
            width: 72,
            height: 72,
            student.gender == 'Α'
                ? 'assets/images/male-gender.svg'
                : 'assets/images/female-gender.svg',
          ),
        ),
      ],
    );
  }
}