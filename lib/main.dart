import 'package:flutter/material.dart';
import 'ciantis/ui/ciantis_shell.dart';
import 'ciantis/universal/developer_logger.dart';
import 'ciantis/universal/universal_tick_scheduler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  DeveloperLogger.log("App started");

  // Start universal tick (every 1 minute for now)
  UniversalTickScheduler.instance.start(
    interval: const Duration(minutes: 1),
  );

  runApp(const CiantisApp());
}

class CiantisApp extends StatelessWidget {
  const CiantisApp({super.key});

  @override
  Widget build(BuildContext context) {
    DeveloperLogger.log("CiantisApp build triggered");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Ciantis",
      theme: ThemeData.dark(),
      home: const CiantisShell(),
    );
  }
}
