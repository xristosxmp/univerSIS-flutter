import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SheetRow extends StatelessWidget {
  final String? icon;
  final String value;
  final Color textColor;
  final bool isTextCenter;

  // New flags for sheet position
  final bool topSheetRow;
  final bool middleSheetRow;
  final bool bottomSheetRow;

  const SheetRow({
    Key? key,
    this.icon,
    required this.value,
    required this.textColor,
    this.isTextCenter = false,
    this.topSheetRow = false,
    this.middleSheetRow = false,
    this.bottomSheetRow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(0);
    borderRadius = BorderRadius.circular(16);
    if (topSheetRow) {
      borderRadius = const BorderRadius.only(
        topRight: Radius.circular(12),
      );
    } else if (middleSheetRow) {
      borderRadius = BorderRadius.zero;
    } else if (bottomSheetRow) {
      borderRadius = const BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            SvgPicture.asset(
              icon!,
              width: 26,
              height: 26,
              color: const Color(0xFF5C6BC0),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Text(
              value,
              textAlign:
                  isTextCenter ? TextAlign.center : TextAlign.start,
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}