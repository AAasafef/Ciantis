import 'package:flutter/material.dart';
import '../universal/ai_state.dart';
import '../universal/developer_logger.dart';

/// DeveloperNbaPanel
/// ------------------
/// Shows the current Next Best Action (NBA):
/// - Action label
/// - Reason summary
/// - Confidence
///
/// This gives developers a real-time view of what Ciantis believes
/// the user should do next.
class DeveloperNbaPanel extends StatefulWidget {
  const DeveloperNbaPanel({super.key});

  @override
  State<DeveloperNbaPanel> createState() => _DeveloperNbaPanelState();
}

class _DeveloperNbaPanelState extends State<DeveloperNbaPanel> {
  String _action = "None";
  String _reason = "";
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("DeveloperNbaPanel initialized");

    AiState.instance.addListener(_update);
    _update();
  }

  void _update() {
    final ai = AiState.instance;

    setState(() {
      _action = ai.nextBestActionLabel;
      _reason = ai.nextBestActionReason;
      _confidence = ai.nextBestActionConfidence;
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
            "Next Best Action: $_action",
            style: const TextStyle(
              color: Colors.tealAccent,
              fontSize: 10.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _reason.isEmpty ? "(no reasoning available)" : _reason,
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
