import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperCognitiveRejuvenationPanel
/// -----------------------------------
/// Shows Ciantis' rejuvenation metrics with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - Rejuvenation pulse animations
class DeveloperCognitiveRejuvenationPanel extends StatefulWidget {
  const DeveloperCognitiveRejuvenationPanel({super.key});

  @override
  State<DeveloperCognitiveRejuvenationPanel> createState() =>
      _DeveloperCognitiveRejuvenationPanelState();
}

class _DeveloperCognitiveRejuvenationPanelState
    extends State<DeveloperCognitiveRejuvenationPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _rejuvenationMetrics = [
    {"label": "Reasoning Rejuvenation", "value": 0.95, "icon": Icons.psychology},
    {"label": "Emotional Rejuvenation", "value": 0.91, "icon": Icons.favorite},
    {"label": "Mode Rejuvenation", "value": 0.88, "icon": Icons.bubble_chart},
    {"label": "Prediction Rejuvenation", "value": 0.93, "icon": Icons.auto_awesome},
    {"label": "Memory Rejuvenation", "value": 0.97, "icon": Icons.storage},
    {"label": "System Rejuvenation Index", "value": 0.94, "icon": Icons.settings},
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

  void _onRejuvenationTap(String label, double value) {
    DeveloperLogger.log(
      "Cognitive Rejuvenation Panel → $label tapped (${(value * 100).toStringAsFixed(0)}%)",
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
          children: _rejuvenationMetrics.map((metric) {
            final label = metric["label"] as String;
            final value = metric["value"] as double;
            final icon = metric["icon"] as IconData;

            return GestureDetector(
              onTap: () => _onRejuvenationTap(label, value),
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
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
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
