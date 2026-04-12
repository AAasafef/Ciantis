import 'package:flutter/material.dart';
import 'ui/developer_shell_screen.dart';

/// dev_main.dart
/// --------------
/// Standalone entry point for developers.
/// Launches directly into the Developer Shell.
/// This does NOT replace main.dart.
/// It is optional and used only for debugging.
void main() {
  runApp(const DevCiantisApp());
}

class DevCiantisApp extends StatelessWidget {
  const DevCiantisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ciantis Dev Mode',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.tealAccent,
        ),
      ),
      home: const DeveloperShellScreen(),
    );
  }
}
