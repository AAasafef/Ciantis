import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperCognitiveStrainDeltaPanel
/// ----------------------------------
/// Shows Ciantis' cognitive strain deltas with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - Strain pulse animations
class DeveloperCognitiveStrainDeltaPanel extends StatefulWidget {
  const DeveloperCognitiveStrainDeltaPanel({super.key});

  @override
  State<DeveloperCognitiveStrainDeltaPanel> createState() =>
      _DeveloperCognitiveStrainDeltaPanelState();
}

class _DeveloperCognitiveStrainDeltaPanelState
    extends State<DeveloperCognitiveStrainDeltaPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _strainDeltas = [
    {"label": "Stress ↑", "value": 0.12},
    {"label": "Clarity ↓", "value": -0.08},
    {"label": "Load ↑", "value": 0.05},
    {"label": "Resilience ↓", "value": -0.04},
    {"label": "Stability ↑", "value": 0.03},
  ];

  @override
  void initState() {
    super.initState();

    final motion = AmbientMotionEngine.instance;

    _pulseController = AnimationController(
      vsync: this,
      duration: motion.adaptiveDuration,
    );
  }

  void _onDeltaTap(String label, double value) {
    DeveloperLogger.log(
      "Cognitive Strain Delta Panel → $label tapped (${(value * 100).toStringAsFixed(0)}%)",
    );

    // 🔊 Soft UI tap sound
    AmbientSoundEngine.instance.quickAction();

    // 🤍 Soft luxury haptic tap
    AmbientHapticsEngine.instance.softTap();

    // Pulse animation
    _pulseController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final motion = AmbientMotionEngine.instance;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = Tween<double>(begin: 1.0, end: 1.03)
            .chain(CurveTween(curve: motion.adaptiveCurve))
            .evaluate(_pulseController);

        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.10),
              width: 1.2,
            ),
          ),
        ),
        child: SizedBox(
          height: 46,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _strainDeltas.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final delta = _strainDeltas[index];
              final label = delta["label"] as String;
              final value = delta["value"] as double;

              return GestureDetector(
                onTap: () => _onDeltaTap(label, value),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.10),
                      width: 1.2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "$label ${(value * 100).toStringAsFixed(0)}%",
                      style: TextStyle(
                        color: value >= 0
                            ? Colors.redAccent.withOpacity(0.85)
                            : Colors.tealAccent.withOpacity(0.85),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
