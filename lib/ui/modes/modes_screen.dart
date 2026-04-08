import 'package:flutter/material.dart';

class ModesScreen extends StatelessWidget {
  const ModesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Modes',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.bubble_chart_rounded,
              size: 60,
              color: Color(0xFF8A4FFF),
            ),
            SizedBox(height: 20),
            Text(
              'Ciantis Modes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8A4FFF),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your adaptive OS personality lives here',
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
