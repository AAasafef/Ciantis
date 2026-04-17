import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperCognitiveEmotionLoadCouplingPanel
/// ------------------------------------------
/// Shows Ciantis' emotion-load coupling metrics with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - Coupling pulse animations
class DeveloperCognitiveEmotionLoadCouplingPanel extends StatefulWidget {
  const DeveloperCognitiveEmotionLoadCouplingPanel({super.key});

  @override
  State<DeveloperCognitiveEmotionLoadCouplingPanel> createState() =>
      _DeveloperCognitiveEmotionLoadCouplingPanelState();
}

class _DeveloperCognitiveEmotionLoadCouplingPanelState
    extends State<DeveloperCognitiveEmotionLoadCouplingPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _couplingMetrics = [
    {"label": "Emotion-Load Clarity", "value": 0.94, "icon": Icons.lightbulb},
    {"label": "Emotion-Load Stability", "value": 0.91, "icon": Icons.balance},
    {"label": "Emotion-Load Drift", "value": 0.87, "icon": Icons.waves},
    {"label": "Emotion-Load Load", "value": 0.89, "icon": Icons.speed},
    {"label": "Emotion-Load Resonance", "value": 0.95, "icon": Icons.graphic_eq},
    {"label": "Emotion-Load Accuracy", "value": 0.93, "icon": Icons.check_circle},
    {"label": "Emotion-Load System Index", "value": 0.96, "icon": Icons.settings},
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
      "Cognitive Emotion-Load Coupling Panel → $label tapped (${(value * 100).toStringAsFixed(0)}%)",
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
