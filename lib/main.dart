import 'package:flutter/material.dart';
import 'ciantis/ciantis_shell.dart';
import 'ciantis/universal/universal_tick_scheduler.dart';

void main() {
  // Start Ciantis heartbeat
  UniversalTickScheduler.instance.start(
    interval: const Duration(minutes: 5),
  );

  runApp(const CiantisApp());
}

class CiantisApp extends StatelessWidget {
  const CiantisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ciantis',
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
      home: const CiantisShell(),
    );
  }
}
