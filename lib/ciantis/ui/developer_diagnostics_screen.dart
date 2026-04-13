import 'package:flutter/material.dart';
import '../universal/ciantis_context.dart';
import '../universal/developer_logger.dart';

/// DeveloperDiagnosticsScreen
/// ---------------------------
/// Shows raw context values:
/// - Energy
/// - Stress
/// - Task load
/// - Calendar load
/// - Last updated timestamp
class DeveloperDiagnosticsScreen extends StatelessWidget {
  const DeveloperDiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DeveloperLogger.log("Opened Developer Diagnostics Screen");

    final ctx = CiantisContext.instance;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Developer Diagnostics"),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _item("Energy", ctx.energy.toString()),
          _item("Stress", ctx.stress.toString()),
          _item("Task Load", ctx.taskLoad.toString()),
          _item("Calendar Load", ctx.calendarLoad.toString()),
          _item("Mode", ctx.mode),
          _item("Last Updated", ctx.lastUpdated.toIso8601String()),
        ],
      ),
    );
  }

  Widget _item(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.tealAccent,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
