import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperCognitiveMemoryEmotionCouplingPanel
/// --------------------------------------------
/// Shows Ciantis' memory-emotion coupling metrics with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - Coupling pulse animations
class DeveloperCognitiveMemoryEmotionCouplingPanel extends StatefulWidget {
  const DeveloperCognitiveMemoryEmotionCouplingPanel({super.key});

  @override
  State<DeveloperCognitiveMemoryEmotionCouplingPanel> createState() =>
      _DeveloperCognitiveMemoryEmotionCouplingPanelState();
}

class _DeveloperCognitiveMemoryEmotionCouplingPanelState
    extends State<DeveloperCognitiveMemoryEmotionCouplingPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _couplingMetrics = [
    {"label": "Memory-Emotion Clarity", "value": 0.94, "icon": Icons.lightbulb},
    {"label": "Memory-Emotion Stability", "value": 0.91, "icon": Icons.balance},
    {"label": "Memory-Emotion Drift", "value": 0.87, "icon": Icons.waves},
    {"label": "Memory-Emotion Load", "value": 0.89, "icon": Icons.speed},
    {"label": "Memory-Emotion Resonance", "value": 0.95, "icon": Icons.graphic_eq},
    {"label": "Memory-Emotion Accuracy", "value": 0.93, "icon": Icons.check_circle},
    {"label": "Memory-Emotion System Index", "value": 0.96, "icon": Icons.settings},
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

  void _onCouplingTap(String label, double value) {
    DeveloperLogger.log(
      "Cognitive Memory-Emotion Coupling Panel → $label tapped (${(value * 100).toStringAsFixed(0)}%)",
    );

    AmbientSoundEngine.instance.quickAction();
    AmbientHapticsEngine.instance.softTap();

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
          children: _couplingMetrics.map((metric) {
            final label = metric["label"] as String;
            final value = metric["value"] as double;
            final icon = metric["icon"] as IconData;

            return GestureDetector(
              onTap: () => _onCouplingTap(label, value),
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
