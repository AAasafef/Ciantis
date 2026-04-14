import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperReasoningStrip
/// ------------------------
/// Displays Ciantis' internal reasoning nodes with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - Cognitive pulse animations
class DeveloperReasoningStrip extends StatefulWidget {
  const DeveloperReasoningStrip({super.key});

  @override
  State<DeveloperReasoningStrip> createState() =>
      _DeveloperReasoningStripState();
}

class _DeveloperReasoningStripState extends State<DeveloperReasoningStrip>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<String> _nodes = [
    "Intent",
    "Context",
    "Mode",
    "Emotion",
    "Opportunity",
    "NBA",
    "Prediction",
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

  void _onNodeTap(String node) {
    DeveloperLogger.log("Reasoning Strip → $node tapped");

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
          itemCount: _nodes.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final node = _nodes[index];

            return GestureDetector(
              onTap: () => _onNodeTap(node),
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
                    node,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
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
