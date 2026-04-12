import 'package:flutter/material.dart';
import '../universal/developer_logger.dart';

/// PlaceholderScreen
/// ------------------
/// Temporary screen used until real modules are built.
/// Logs when opened for developer visibility.
class PlaceholderScreen extends StatelessWidget {
  final String label;

  const PlaceholderScreen(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    DeveloperLogger.log("Opened placeholder screen: $label");

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}
