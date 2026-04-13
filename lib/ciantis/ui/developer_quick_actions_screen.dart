import 'package:flutter/material.dart';
import '../universal/developer_logger.dart';
import '../universal/ai_state.dart';

/// DeveloperQuickActionsScreen
/// ----------------------------
/// Provides developer-only buttons to:
/// - Clear AI State
/// - Trigger manual tick
/// - Add test adaptive signals
class DeveloperQuickActionsScreen extends StatelessWidget {
  const DeveloperQuickActionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DeveloperLogger.log("Opened Developer Quick Actions Screen");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Developer Quick Actions"),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _button(
            label: "Clear AI State",
            icon: Icons.delete_sweep,
            onTap: () {
              AiState.instance.clear();
              DeveloperLogger.log("Quick Action: AI State cleared");
            },
          ),
          _button(
            label: "Add Test Adaptive Signal",
            icon: Icons.bolt,
            onTap: () {
              AiState.instance.updateAdaptiveSignal(
                "test_signal",
                DateTime.now().millisecondsSinceEpoch,
              );
              DeveloperLogger.log("Quick Action: Test adaptive signal added");
            },
          ),
        ],
      ),
    );
  }

  Widget _button({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
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
        onTap: onTap,
      ),
    );
  }
}
