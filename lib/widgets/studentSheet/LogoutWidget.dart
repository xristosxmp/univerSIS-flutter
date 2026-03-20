import 'package:flutter/material.dart';

class LogoutWidget extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutWidget({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: const [
            Icon(Icons.logout, color: Color(0xffDE3163)),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                'Αποσύνδεση',
                style: TextStyle(color: Color(0xffDE3163)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}