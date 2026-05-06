import 'package:flutter/material.dart';

class CiantisHomeScreen extends StatelessWidget {
  const CiantisHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),
      body: Center(
        child: Text(
          "Ciantis Home Screen",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.85),
          ),
        ),
      ),
    );
  }
}
