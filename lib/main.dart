import 'package:flutter/material.dart';
import 'ui/home/ciantis_home_screen.dart';

void main() {
  runApp(const CiantisApp());
}

class CiantisApp extends StatelessWidget {
  const CiantisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CiantisHomeScreen(),
    );
  }
}
