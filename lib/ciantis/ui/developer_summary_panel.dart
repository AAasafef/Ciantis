import 'package:flutter/material.dart';
import '../universal/ai_state.dart';
import '../universal/developer_logger.dart';

/// DeveloperSummaryPanel
/// ----------------------
/// Shows the current Summary Engine output:
/// - Summary line
/// - Category
/// - Confidence
///
/// This gives developers a real-time view of Ciantis’ high-level synthesis.
class DeveloperSummaryPanel extends StatefulWidget {
  const DeveloperSummaryPanel({super.key});

  @override
  State<DeveloperSummaryPanel> createState() => _DeveloperSummaryPanelState();
}

class _DeveloperSummaryPanelState extends State<DeveloperSummaryPanel> {
  String _summary = "";
  String _category = "General";
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("DeveloperSummaryPanel initialized");

    AiState.instance.addListener(_update);
    _update();
  }

  void _update() {
    final ai = AiState.instance;

    setState(() {
      _summary = ai.summaryText;
      _category = ai.summaryCategory;
      _confidence = ai.summaryConfidence;
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
            "Summary (${_category}):",
            style: const TextStyle(
              color: Colors.tealAccent,
              fontSize: 10.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _summary.isEmpty ? "(no summary available)" : _summary,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 10,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "Confidence: ${_fmt(_confidence)}",
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
