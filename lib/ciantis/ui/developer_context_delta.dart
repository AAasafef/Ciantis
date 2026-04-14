import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperContextDelta
/// ----------------------
/// Shows changes in Ciantis' cognitive context with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - Delta pulse animations
class DeveloperContextDelta extends StatefulWidget {
  const DeveloperContextDelta({super.key});

  @override
  State<DeveloperContextDelta> createState() => _DeveloperContextDeltaState();
}

class _DeveloperContextDeltaState extends State<DeveloperContextDelta>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<String> _deltas = [
    "User Intent Updated",
    "Mode Shift",
    "Emotion Adjustment",
    "Opportunity Change",
    "NBA Recalculated",
    "Prediction Updated",
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

  void _onDeltaTap(String delta) {
    DeveloperLogger.log("Context Delta → $delta tapped");

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
          itemCount: _deltas.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final delta = _deltas[index];

            return GestureDetector(
              onTap: () => _onDeltaTap(delta),
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
                    delta,
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
