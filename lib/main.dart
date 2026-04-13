import 'package:flutter/material.dart';
import 'ciantis/ui/ciantis_shell.dart';
import 'ciantis/universal/developer_logger.dart';
import 'ciantis/universal/universal_tick_scheduler.dart';

void main() {
  DeveloperLogger.log("App startup: main() invoked");

  WidgetsFlutterBinding.ensureInitialized();

  // Start the universal tick scheduler
  UniversalTickScheduler.instance.start(
    interval: const Duration(seconds: 10),
  );

  DeveloperLogger.log("Launching CiantisShell");

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
