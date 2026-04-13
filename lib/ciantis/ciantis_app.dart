import 'package:flutter/material.dart';
import 'ui/ciantis_shell.dart';
import 'universal/developer_logger.dart';
import 'universal/cognitive_engine_orchestrator.dart';

/// CiantisApp
/// -----------
/// Root of the entire application.
/// Starts the Cognitive Engine Orchestrator on launch.
class CiantisApp extends StatefulWidget {
  const CiantisApp({super.key});

  @override
  State<CiantisApp> createState() => _CiantisAppState();
}

class _CiantisAppState extends State<CiantisApp> {
  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("CiantisApp initialized → starting orchestrator");

    /// Start the cognitive engine orchestrator
    CognitiveEngineOrchestrator.instance.start();
  }

  @override
  void dispose() {
    DeveloperLogger.log("CiantisApp disposed → stopping orchestrator");

    /// Stop orchestrator cleanly
    CognitiveEngineOrchestrator.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DeveloperLogger.log("CiantisApp build");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Ciantis",
      theme: ThemeData.dark(),
      home: const CiantisShell(),
    );
  }
}
