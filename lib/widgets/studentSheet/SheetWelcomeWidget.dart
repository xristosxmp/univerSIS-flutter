import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SheetWelcomeWidget extends StatelessWidget {
  final String gender;
  final String name;
  final Color textColor;

  const SheetWelcomeWidget({
    Key? key,
    required this.gender,
    required this.name,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
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
            style: TextStyle(color: textColor),
          ),
        ],
      ),
    );
  }
}