import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperDailyBriefingPanel
/// ----------------------------
/// Shows Ciantis' daily cognitive briefing with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - Briefing pulse animations
class DeveloperDailyBriefingPanel extends StatefulWidget {
  const DeveloperDailyBriefingPanel({super.key});

  @override
  State<DeveloperDailyBriefingPanel> createState() =>
      _DeveloperDailyBriefingPanelState();
}

class _DeveloperDailyBriefingPanelState
    extends State<DeveloperDailyBriefingPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _briefingItems = [
    {"label": "Morning Mode: Reflective", "icon": Icons.bubble_chart},
    {"label": "Emotional Baseline: Calm", "icon": Icons.favorite},
    {"label": "Cognitive Load Forecast: Light → Moderate", "icon": Icons.speed},
    {"label": "Primary Opportunity: Task Alignment", "icon": Icons.lightbulb},
    {"label": "Recommended Flow: Tasks → Calendar → Review", "icon": Icons.auto_awesome},
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

  void _onBriefingTap(String label) {
    DeveloperLogger.log("Daily Briefing Panel → $label tapped");

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
        child: Column(
          children: _briefingItems.map((item) {
            final label = item["label"] as String;
            final icon = item["icon"] as IconData;

            return GestureDetector(
              onTap: () => _onBriefingTap(label),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
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
                        label,
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
