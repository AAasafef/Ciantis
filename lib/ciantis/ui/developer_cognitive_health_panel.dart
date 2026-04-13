import 'package:flutter/material.dart';
import '../universal/cognitive_health_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperCognitiveHealthPanel
/// ------------------------------
/// Shows global cognitive engine health metrics:
/// - Health score
/// - Health trend
/// - Health stability
/// - Confidence
///
/// This gives developers a real-time view of Ciantis’ overall cognitive integrity.
class DeveloperCognitiveHealthPanel extends StatefulWidget {
  const DeveloperCognitiveHealthPanel({super.key});

  @override
  State<DeveloperCognitiveHealthPanel> createState() =>
      _DeveloperCognitiveHealthPanelState();
}

class _DeveloperCognitiveHealthPanelState
    extends State<DeveloperCognitiveHealthPanel> {
  double _score = 0.0;
  double _trend = 0.0;
  double _stability = 0.0;
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("DeveloperCognitiveHealthPanel initialized");

    CognitiveHealthEngine.instance.addListener(_update);
    _update();
  }

  void _update() {
    final h = CognitiveHealthEngine.instance;

    setState(() {
      _score = h.healthScore;
      _trend = h.healthTrend;
      _stability = h.healthStability;
      _confidence = h.healthConfidence;
    });
  }

  @override
  void dispose() {
    CognitiveHealthEngine.instance.removeListener(_update);
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Health: ${_fmt(_score)}  Trend: ${_fmt(_trend)}",
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 10.5,
            ),
          ),
          Text(
            "Stability: ${_fmt(_stability)}  Conf: ${_fmt(_confidence)}",
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }
}
