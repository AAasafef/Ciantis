import 'package:flutter/material.dart';

class AiScreen extends StatelessWidget {
  const AiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Ciantis Intelligence',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.auto_awesome_rounded,
              size: 60,
              color: Color(0xFF8A4FFF),
            ),
            SizedBox(height: 20),
            Text(
              'Ciantis AI',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8A4FFF),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your intelligence engine lives here',
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
