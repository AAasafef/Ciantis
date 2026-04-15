import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperCognitiveHealthDeltaPanel
/// ----------------------------------
/// Shows Ciantis' cognitive health deltas with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - Health delta pulse animations
class DeveloperCognitiveHealthDeltaPanel extends StatefulWidget {
  const DeveloperCognitiveHealthDeltaPanel({super.key});

  @override
  State<DeveloperCognitiveHealthDeltaPanel> createState() =>
      _DeveloperCognitiveHealthDeltaPanelState();
}

class _DeveloperCognitiveHealthDeltaPanelState
    extends State<DeveloperCognitiveHealthDeltaPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _healthDeltas = [
    {"label": "Reasoning Health ↑", "value": 0.14, "icon": Icons.psychology},
    {"label": "Emotional Health ↓", "value": -0.09, "icon": Icons.favorite},
    {"label": "Mode Health ↑", "value": 0.11, "icon": Icons.bubble_chart},
    {"label": "Prediction Health ↑", "value": 0.13, "icon": Icons.auto_awesome},
    {"label": "Memory Health ↓", "value": -0.07, "icon": Icons.storage},
    {"label": "System Health Shift", "value": 0.10, "icon": Icons.settings},
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

  void _onHealthTap(String label, double value) {
    DeveloperLogger.log(
      "Cognitive Health Delta Panel → $label tapped (${(value * 100).toStringAsFixed(0)}%)",
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
        final scale = Tween<double>(begin: 1.0, end: 1.04)
            .chain(CurveTween(curve: motion.adaptiveCurve))
            .evaluate(_pulseController);

        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.10),
              width: 1.2,
            ),
          ),
        ),
        child: Column(
          children: _healthDeltas.map((metric) {
            final label = metric["label"] as String;
            final value = metric["value"] as double;
            final icon = metric["icon"] as IconData;

            return GestureDetector(
              onTap: () => _onHealthTap(label, value),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.10),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: Colors.white70, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "$label ${(value * 100).toStringAsFixed(0)}%",
                        style: TextStyle(
                          color: value >= 0
                              ? Colors.tealAccent.withOpacity(0.85)
                              : Colors.redAccent.withOpacity(0.85),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
