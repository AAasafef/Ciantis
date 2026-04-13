import 'package:flutter/material.dart';
import '../universal/cognitive_strain_delta_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperCognitiveStrainDeltaPanel
/// -----------------------------------
/// Shows cognitive strain delta metrics:
/// - ΔLoad
/// - ΔStability
/// - ΔConfidence
/// - Acceleration
///
/// This gives developers a real-time view of Ciantis’ strain-shift dynamics.
class DeveloperCognitiveStrainDeltaPanel extends StatefulWidget {
  const DeveloperCognitiveStrainDeltaPanel({super.key});

  @override
  State<DeveloperCognitiveStrainDeltaPanel> createState() =>
      _DeveloperCognitiveStrainDeltaPanelState();
}

class _DeveloperCognitiveStrainDeltaPanelState
    extends State<DeveloperCognitiveStrainDeltaPanel> {
  double _delta = 0.0;
  double _stability = 0.0;
  double _confidence = 0.0;
  double _acceleration = 0.0;

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("DeveloperCognitiveStrainDeltaPanel initialized");

    CognitiveStrainDeltaEngine.instance.addListener(_update);
    _update();
  }

  void _update() {
    final s = CognitiveStrainDeltaEngine.instance;

    setState(() {
      _delta = s.deltaLoad;
      _stability = s.deltaStability;
      _confidence = s.deltaConfidence;
      _acceleration = s.strainAcceleration;
    });
  }

  @override
  void dispose() {
    CognitiveStrainDeltaEngine.instance.removeListener(_update);
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
            "ΔLoad: ${_fmt(_delta)}  Accel: ${_fmt(_acceleration)}",
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 10.5,
            ),
          ),
          Text(
            "ΔStab: ${_fmt(_stability)}  ΔConf: ${_fmt(_confidence)}",
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
