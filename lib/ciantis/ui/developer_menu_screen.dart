import 'package:flutter/material.dart';
import '../universal/developer_logger.dart';
import 'ai_explainability_screen.dart';
import 'developer_quick_actions_screen.dart';
import 'developer_diagnostics_screen.dart';
import 'developer_logs_screen.dart';

/// DeveloperMenuScreen
/// --------------------
/// Central hub for all developer tools:
/// - AI Explainability
/// - Quick Actions
/// - Diagnostics
/// - Logs
class DeveloperMenuScreen extends StatelessWidget {
  const DeveloperMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DeveloperLogger.log("Opened Developer Menu Screen");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Developer Menu"),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _item(
            context,
            label: "AI Explainability",
            icon: Icons.psychology,
            screen: const AiExplainabilityScreen(),
          ),
          _item(
            context,
            label: "Quick Actions",
            icon: Icons.flash_on,
            screen: const DeveloperQuickActionsScreen(),
          ),
          _item(
            context,
            label: "Diagnostics",
            icon: Icons.monitor_heart,
            screen: const DeveloperDiagnosticsScreen(),
          ),
          _item(
            context,
            label: "Logs",
            icon: Icons.list_alt,
            screen: const DeveloperLogsScreen(),
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Widget screen,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.tealAccent),
        title: Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white38),
        onTap: () {
          DeveloperLogger.log("Developer Menu → $label");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        },
      ),
    );
  }
}
