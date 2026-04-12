import 'package:flutter/material.dart';
import '../universal/ai_state.dart';
import '../universal/universal_tick_scheduler.dart';
import '../universal/mode_engine.dart';
import '../universal/ciantis_context.dart';

/// DeveloperQuickActionsScreen
/// ----------------------------
/// Provides fast developer actions:
/// - Trigger universal tick
/// - Clear AI state
/// - Force mode change
/// - Refresh context
class DeveloperQuickActionsScreen extends StatefulWidget {
  const DeveloperQuickActionsScreen({super.key});

  @override
  State<DeveloperQuickActionsScreen> createState() =>
      _DeveloperQuickActionsScreenState();
}

class _DeveloperQuickActionsScreenState
    extends State<DeveloperQuickActionsScreen> {
  final _ai = AiState.instance;
  final _context = CiantisContext.instance;
  final _mode = ModeEngine.instance;

  void _runTick() {
    UniversalTickScheduler.instance.tick();
    setState(() {});
  }

  void _clearAi() {
    _ai.clear();
    setState(() {});
  }

  void _forceMode(String mode) {
    _context.updateMode(mode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Developer Quick Actions"),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _button("Run Universal Tick", Icons.access_time, _runTick),
          _button("Clear AI State", Icons.delete_forever, _clearAi),
          const SizedBox(height: 20),
          _label("Force Mode"),
          _button("Focus Mode", Icons.center_focus_strong,
              () => _forceMode("focus")),
          _button("Recovery Mode", Icons.self_improvement,
              () => _forceMode("recovery")),
          _button("Execution Mode", Icons.bolt,
              () => _forceMode("execution")),
          _button("Default Mode", Icons.refresh,
              () => _forceMode("default")),
        ],
      ),
    );
  }

  Widget _button(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.tealAccent),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white38),
        onTap: onTap,
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.tealAccent,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
