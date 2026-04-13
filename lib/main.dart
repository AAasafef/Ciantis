import 'package:flutter/material.dart';
import 'ciantis/ui/ciantis_shell.dart';
import 'ciantis/universal/developer_logger.dart';
import 'ciantis/universal/universal_tick_scheduler.dart';
import 'ciantis/ui/developer_hotkey_layer.dart';

void main() {
  DeveloperLogger.log("App startup: main() invoked");

  WidgetsFlutterBinding.ensureInitialized();

  // Start the universal tick scheduler
  UniversalTickScheduler.instance.start(
    interval: const Duration(seconds: 10),
  );

  DeveloperLogger.log("Launching CiantisApp");

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
      home: const DeveloperHotkeyLayer(
        child: CiantisShell(),
      ),
    );
  }
}
