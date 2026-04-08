import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings',
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
              Icons.settings_rounded,
              size: 60,
              color: Color(0xFF8A4FFF),
            ),
            SizedBox(height: 20),
            Text(
              'Ciantis Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8A4FFF),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'System preferences and controls live here',
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
