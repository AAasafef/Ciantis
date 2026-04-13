import 'package:flutter/material.dart';
import '../universal/emotion_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperEmotionPanel
/// ----------------------
/// Shows internal emotion engine metrics:
/// - Emotional valence
/// - Arousal level
/// - Stability index
/// - Confidence
///
/// This gives developers a real-time view of Ciantis’ emotional inference.
class DeveloperEmotionPanel extends StatefulWidget {
  const DeveloperEmotionPanel({super.key});

  @override
  State<DeveloperEmotionPanel> createState() => _DeveloperEmotionPanelState();
}

class _DeveloperEmotionPanelState extends State<DeveloperEmotionPanel> {
  double _valence = 0.0;
  double _arousal = 0.0;
  double _stability = 0.0;
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("DeveloperEmotionPanel initialized");

    EmotionEngine.instance.addListener(_update);
    _update();
  }

  void _update() {
    final e = EmotionEngine.instance;

    setState(() {
      _valence = e.valence;
      _arousal = e.arousal;
      _stability = e.stability;
      _confidence = e.confidence;
    });
  }

  @override
  void dispose() {
    EmotionEngine.instance.removeListener(_update);
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
            "Valence: ${_fmt(_valence)}  Arousal: ${_fmt(_arousal)}",
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
