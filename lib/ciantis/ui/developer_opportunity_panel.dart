import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperOpportunityPanel
/// --------------------------
/// Shows Ciantis' detected opportunities with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - Opportunity pulse animations
class DeveloperOpportunityPanel extends StatefulWidget {
  const DeveloperOpportunityPanel({super.key});

  @override
  State<DeveloperOpportunityPanel> createState() =>
      _DeveloperOpportunityPanelState();
}

class _DeveloperOpportunityPanelState extends State<DeveloperOpportunityPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<String> _opportunities = [
    "Navigation",
    "Task Completion",
    "Focus Window",
    "Energy Match",
    "Calendar Sync",
    "Reflection",
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

  void _onOpportunityTap(String opp) {
    DeveloperLogger.log("Opportunity Panel → $opp tapped");

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

    return SizedBox(
      height: 54,
      child: AnimatedBuilder(
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
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _opportunities.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final opp = _opportunities[index];

            return GestureDetector(
              onTap: () => _onOpportunityTap(opp),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                    opp,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
