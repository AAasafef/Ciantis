import 'package:flutter/material.dart';
import '../universal/ai_state.dart';
import '../universal/developer_logger.dart';

/// DeveloperReasoningStrip
/// ------------------------
/// A thin ribbon that displays the most recent AI reasoning line.
/// This gives developers a real-time peek into the AI's thought process.
///
/// It automatically updates whenever any reasoning string changes.
class DeveloperReasoningStrip extends StatefulWidget {
  const DeveloperReasoningStrip({super.key});

  @override
  State<DeveloperReasoningStrip> createState() =>
      _DeveloperReasoningStripState();
}

class _DeveloperReasoningStripState extends State<DeveloperReasoningStrip> {
  String _latest = "";

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("DeveloperReasoningStrip initialized");

    // Listen for changes in AI State
    AiState.instance.addListener(_update);
    _update();
  }

  void _update() {
    final ai = AiState.instance;

    // Pick the most recently updated reasoning string
    final candidates = [
      ai.modeReason,
      ai.nextBestActionReason,
      ai.dailyBriefingReason,
      ai.summaryReason,
    ].where((e) => e.isNotEmpty).toList();

    if (candidates.isNotEmpty) {
      setState(() => _latest = candidates.last);
    }
  }

  @override
  void dispose() {
    AiState.instance.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        border: const Border(
          bottom: BorderSide(
            color: Colors.tealAccent,
            width: 0.35,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        child: Text(
          _latest.isEmpty ? "AI Reasoning: (waiting…)" : _latest,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 10.5,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
