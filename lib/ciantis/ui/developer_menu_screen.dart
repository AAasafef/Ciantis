import 'package:flutter/material.dart';
import 'ai_explainability_screen.dart';
import 'developer_quick_actions_screen.dart';
import 'developer_diagnostics_screen.dart';

/// DeveloperMenuScreen
/// --------------------
/// Gives access to internal developer tools:
/// - AI Explainability Panel
/// - Quick Actions
/// - Diagnostics
class DeveloperMenuScreen extends StatelessWidget {
  const DeveloperMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            title: "AI Explainability",
            icon: Icons.psychology_alt,
            screen: const AiExplainabilityScreen(),
          ),
          _item(
            context,
            title: "Quick Actions",
            icon: Icons.flash_on,
            screen: const DeveloperQuickActionsScreen(),
          ),
          _item(
            context,
            title: "Diagnostics",
            icon: Icons.monitor_heart,
            screen: const DeveloperDiagnosticsScreen(),
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required String title,
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
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white38),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        },
      ),
    );
  }
}
