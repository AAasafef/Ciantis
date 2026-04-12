import 'package:flutter/material.dart';
import '../universal/ai_state.dart';

/// AiExplainabilityScreen
/// -----------------------
/// Developer-only screen that shows
/// the internal reasoning state of Ciantis.
class AiExplainabilityScreen extends StatelessWidget {
  const AiExplainabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ai = AiState.instance;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("AI Explainability"),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _section("Mode Reasoning", ai.modeReason),
          _section("Next Best Action Reasoning", ai.nextBestActionReason),
          _section("Daily Briefing Reasoning", ai.dailyBriefingReason),
          _section("Adaptive Signals", ai.adaptiveSignals.toString()),
          _section("Summary Reasoning", ai.summaryReason),
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
