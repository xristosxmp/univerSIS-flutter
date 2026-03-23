import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuTile extends StatelessWidget {
  final String svgPath;
  final String text;
  final Widget navPage;

  const MenuTile({
    Key? key,
    required this.svgPath,
    required this.text,
    required this.navPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => navPage),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              svgPath,
              width: 22,
              height: 22,
              color: const Color(0xFF73818e),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Color(0xFF73818e),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF73818e),
            ),
          ],
        ),
      ),
    );
  }
}