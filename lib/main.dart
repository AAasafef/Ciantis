import 'package:flutter/material.dart';
import 'system/system.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Launch the Ciantis OS
  await CiantisSystem.instance.launch();

  runApp(const CiantisApp());
}

class CiantisApp extends StatelessWidget {
  const CiantisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ciantis OS',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F4F9),
        fontFamily: 'Sans',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8A4FFF),
        ),
      ),
      home: CiantisSystem.instance.buildSystemShell(),
    );
  }
}
