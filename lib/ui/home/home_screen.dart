import 'package:flutter/material.dart';

class CiantisHomeScreen extends StatelessWidget {
  const CiantisHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.auto_awesome,
              size: 60,
              color: Color(0xFF8A4FFF),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Ciantis OS',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8A4FFF),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your luxury personal operating system',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF5A4A6A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
