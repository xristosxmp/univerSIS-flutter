import 'package:flutter/material.dart';
class HalfColoredBall extends StatelessWidget {
  final Color leftColor;
  final Color rightColor;

  const HalfColoredBall({
    Key? key,
    required this.leftColor,
    required this.rightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 12,
              color: rightColor,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 12,
              color: leftColor,
            ),
          ),
        ],
      ),
    );
  }
}