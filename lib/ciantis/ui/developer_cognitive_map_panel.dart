import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperCognitiveMapPanel
/// ---------------------------
/// Shows Ciantis' cognitive architecture map with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - Node pulse animations
class DeveloperCognitiveMapPanel extends StatefulWidget {
  const DeveloperCognitiveMapPanel({super.key});

  @override
  State<DeveloperCognitiveMapPanel> createState() =>
      _DeveloperCognitiveMapPanelState();
}

class _DeveloperCognitiveMapPanelState
    extends State<DeveloperCognitiveMapPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _nodes = [
    {"label": "Reasoning", "icon": Icons.psychology},
    {"label": "Emotion", "icon": Icons.favorite},
    {"label": "Mode", "icon": Icons.bubble_chart},
    {"label": "Load", "icon": Icons.speed},
    {"label": "Opportunity", "icon": Icons.lightbulb},
    {"label": "Prediction", "icon": Icons.auto_awesome},
    {"label": "Memory", "icon": Icons.storage},
    {"label": "System", "icon": Icons.settings},
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

  void _onNodeTap(String label) {
    DeveloperLogger.log("Cognitive Map Panel → Node tapped: $label");

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
          children: _nodes.map((node) {
            final label = node["label"] as String;
            final icon = node["icon"] as IconData;

            return GestureDetector(
              onTap: () => _onNodeTap(label),
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
                      label,
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
