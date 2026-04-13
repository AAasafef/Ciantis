import 'package:flutter/material.dart';
import '../universal/ai_state.dart';
import '../universal/developer_logger.dart';

/// DeveloperDailyBriefingPanel
/// ----------------------------
/// Shows the current Daily Briefing summary:
/// - Briefing line
/// - Emotional tone
/// - Confidence
///
/// This gives developers a real-time view of Ciantis’ narrative synthesis.
class DeveloperDailyBriefingPanel extends StatefulWidget {
  const DeveloperDailyBriefingPanel({super.key});

  @override
  State<DeveloperDailyBriefingPanel> createState() =>
      _DeveloperDailyBriefingPanelState();
}

class _DeveloperDailyBriefingPanelState
    extends State<DeveloperDailyBriefingPanel> {
  String _briefing = "";
  String _tone = "Neutral";
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("DeveloperDailyBriefingPanel initialized");

    AiState.instance.addListener(_update);
    _update();
  }

  void _update() {
    final ai = AiState.instance;

    setState(() {
      _briefing = ai.dailyBriefingSummary;
      _tone = ai.dailyBriefingTone;
      _confidence = ai.dailyBriefingConfidence;
    });
  }

  @override
  void dispose() {
    AiState.instance.removeListener(_update);
    super.dispose();
  }

  String _fmt(double v) => v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.40),
        border: const Border(
          bottom: BorderSide(
            color: Colors.tealAccent,
            width: 0.35,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Daily Briefing:",
            style: const TextStyle(
              color: Colors.tealAccent,
              fontSize: 10.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _briefing.isEmpty ? "(no briefing available)" : _briefing,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 10,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "Tone: $_tone   Confidence: ${_fmt(_confidence)}",
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
