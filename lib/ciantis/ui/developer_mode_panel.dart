import 'package:flutter/material.dart';
import '../universal/mode_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperModePanel
/// -------------------
/// Shows internal mode engine metrics:
/// - Active mode
/// - Mode intensity
/// - Mode stability
/// - Confidence
///
/// This gives developers a real-time view of Ciantis’ mode interpretation.
class DeveloperModePanel extends StatefulWidget {
  const DeveloperModePanel({super.key});

  @override
  State<DeveloperModePanel> createState() => _DeveloperModePanelState();
}

class _DeveloperModePanelState extends State<DeveloperModePanel> {
  String _mode = "Neutral";
  double _intensity = 0.0;
  double _stability = 0.0;
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("DeveloperModePanel initialized");

    ModeEngine.instance.addListener(_update);
    _update();
  }

  void _update() {
    final m = ModeEngine.instance;

    setState(() {
      _mode = m.activeMode;
      _intensity = m.intensity;
      _stability = m.stability;
      _confidence = m.confidence;
    });
  }

  @override
  void dispose() {
    ModeEngine.instance.removeListener(_update);
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
            "Mode: $_mode  Intensity: ${_fmt(_intensity)}",
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
