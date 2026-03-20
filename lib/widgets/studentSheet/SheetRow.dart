import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SheetRow extends StatelessWidget {
  final String icon;
  final String value;
  final Color textColor;

  const SheetRow({
    Key? key,
    required this.icon,
    required this.value,
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
      child: Row(
        children: [
          SvgPicture.asset(icon, width: 26, height: 26, color: const Color(0xFF5C6BC0)),
          const SizedBox(width: 16),
          Expanded(child: Text(value, style: TextStyle(color: textColor))),
        ],
      ),
    );
  }
}