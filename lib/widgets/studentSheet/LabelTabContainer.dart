import 'package:flutter/material.dart';

class RoundedTextContainer extends StatelessWidget {
  final String text;
  final Color textColor;
  final Alignment alignment;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;

  const RoundedTextContainer({
    Key? key,
    required this.text,
    this.textColor = Colors.black,
    this.alignment = Alignment.centerLeft,
    this.horizontalPadding = 12,
    this.verticalPadding = 8,
    this.borderRadius = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IntrinsicWidth(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}