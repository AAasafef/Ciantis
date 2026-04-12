import 'package:flutter/material.dart';
import '../universal/ciantis_context.dart';
import '../universal/ai_state.dart';

/// DeveloperDiagnosticsScreen
/// ---------------------------
/// Shows real-time internal system values:
/// - Current mode
/// - Context values
/// - AI state snapshot
/// - Last updated time
class DeveloperDiagnosticsScreen extends StatelessWidget {
  const DeveloperDiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctx = CiantisContext.instance;
    final ai = AiState.instance;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Developer Diagnostics"),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _section("Current Mode", ctx.mode),
          _section("Energy", ctx.energy.toString()),
          _section("Stress", ctx.stress.toString()),
          _section("Task Load", ctx.taskLoad.toString()),
          _section("Calendar Load", ctx.calendarLoad.toString()),
          _section("Last Updated", ctx.lastUpdated.toString()),
          const SizedBox(height: 20),
          _section("AI State: Mode Reason", ai.modeReason),
          _section("AI State: NBA Reason", ai.nextBestActionReason),
          _section("AI State: Briefing Reason", ai.dailyBriefingReason),
          _section("AI State: Summary Reason", ai.summaryReason),
          _section("AI State: Adaptive Signals", ai.adaptiveSignals.toString()),
        ],
      ),
    );
  }

  Widget _section(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.tealAccent,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content.isEmpty ? "(no data)" : content,
            style: const TextStyle(
              color: Colors.white70,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
