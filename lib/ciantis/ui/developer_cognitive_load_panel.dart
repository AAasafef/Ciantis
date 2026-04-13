import 'package:flutter/material.dart';
import '../universal/cognitive_load_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperCognitiveLoadPanel
/// ----------------------------
/// Shows internal cognitive load metrics:
/// - Load score
/// - Load trend
/// - Load stability
/// - Confidence
///
/// This gives developers a real-time view of Ciantis’ cognitive strain.
class DeveloperCognitiveLoadPanel extends StatefulWidget {
  const DeveloperCognitiveLoadPanel({super.key});

  @override
  State<DeveloperCognitiveLoadPanel> createState() =>
      _DeveloperCognitiveLoadPanelState();
}

class _DeveloperCognitiveLoadPanelState
    extends State<DeveloperCognitiveLoadPanel> {
  double _score = 0.0;
  double _trend = 0.0;
  double _stability = 0.0;
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("DeveloperCognitiveLoadPanel initialized");

    CognitiveLoadEngine.instance.addListener(_update);
    _update();
  }

  void _update() {
    final c = CognitiveLoadEngine.instance;

    setState(() {
      _score = c.loadScore;
      _trend = c.loadTrend;
      _stability = c.loadStability;
      _confidence = c.loadConfidence;
    });
  }

  @override
  void dispose() {
    CognitiveLoadEngine.instance.removeListener(_update);
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
            "Load: ${_fmt(_score)}  Trend: ${_fmt(_trend)}",
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
