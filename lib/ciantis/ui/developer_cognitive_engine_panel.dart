import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperCognitiveEnginePanel
/// ------------------------------
/// Shows Ciantis' internal cognitive engines with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - Engine pulse animations
class DeveloperCognitiveEnginePanel extends StatefulWidget {
  const DeveloperCognitiveEnginePanel({super.key});

  @override
  State<DeveloperCognitiveEnginePanel> createState() =>
      _DeveloperCognitiveEnginePanelState();
}

class _DeveloperCognitiveEnginePanelState
    extends State<DeveloperCognitiveEnginePanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _engines = [
    {"label": "Reasoning Engine", "value": 0.87, "icon": Icons.psychology},
    {"label": "Emotion Engine", "value": 0.78, "icon": Icons.favorite},
    {"label": "Mode Engine", "value": 0.74, "icon": Icons.bubble_chart},
    {"label": "Load Engine", "value": 0.69, "icon": Icons.speed},
    {"label": "Opportunity Engine", "value": 0.81, "icon": Icons.lightbulb},
    {"label": "Prediction Engine", "value": 0.83, "icon": Icons.auto_awesome},
    {"label": "Memory Engine", "value": 0.91, "icon": Icons.storage},
    {"label": "System Engine", "value": 0.72, "icon": Icons.settings},
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

  void _onEngineTap(String label, double value) {
    DeveloperLogger.log(
      "Cognitive Engine Panel → $label tapped (${(value * 100).toStringAsFixed(0)}%)",
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
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _engines.map((engine) {
            final label = engine["label"] as String;
            final value = engine["value"] as double;
            final icon = engine["icon"] as IconData;

            return GestureDetector(
              onTap: () => _onEngineTap(label, value),
              child: Container(
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: Colors.white70, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "$label ${(value * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
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
