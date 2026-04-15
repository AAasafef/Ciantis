import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperCognitiveSelfRegulationPanel
/// -------------------------------------
/// Shows Ciantis' self-regulation metrics with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - Self-regulation pulse animations
class DeveloperCognitiveSelfRegulationPanel extends StatefulWidget {
  const DeveloperCognitiveSelfRegulationPanel({super.key});

  @override
  State<DeveloperCognitiveSelfRegulationPanel> createState() =>
      _DeveloperCognitiveSelfRegulationPanelState();
}

class _DeveloperCognitiveSelfRegulationPanelState
    extends State<DeveloperCognitiveSelfRegulationPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _regulationMetrics = [
    {"label": "Reasoning Self-Regulation", "value": 0.93, "icon": Icons.psychology},
    {"label": "Emotional Self-Regulation", "value": 0.89, "icon": Icons.favorite},
    {"label": "Mode Self-Regulation", "value": 0.86, "icon": Icons.bubble_chart},
    {"label": "Prediction Self-Regulation", "value": 0.91, "icon": Icons.auto_awesome},
    {"label": "Memory Self-Regulation", "value": 0.95, "icon": Icons.storage},
    {"label": "System Self-Regulation Index", "value": 0.92, "icon": Icons.settings},
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

  void _onRegulationTap(String label, double value) {
    DeveloperLogger.log(
      "Cognitive Self-Regulation Panel → $label tapped (${(value * 100).toStringAsFixed(0)}%)",
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
          children: _regulationMetrics.map((metric) {
            final label = metric["label"] as String;
            final value = metric["value"] as double;
            final icon = metric["icon"] as IconData;

            return GestureDetector(
              onTap: () => _onRegulationTap(label, value),
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
