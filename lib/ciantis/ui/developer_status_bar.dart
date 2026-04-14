import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperStatusBar
/// -------------------
/// Displays live system indicators with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - Developer-friendly cognitive feedback
class DeveloperStatusBar extends StatefulWidget {
  const DeveloperStatusBar({super.key});

  @override
  State<DeveloperStatusBar> createState() => _DeveloperStatusBarState();
}

class _DeveloperStatusBarState extends State<DeveloperStatusBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    final motion = AmbientMotionEngine.instance;

    _pulseController = AnimationController(
      vsync: this,
      duration: motion.adaptiveDuration,
    );
  }

  void _onTap(String label) {
    DeveloperLogger.log("Status Bar → $label tapped");

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.10),
              width: 1.2,
            ),
          ),
        ),
        child: Row(
          children: [
            _statusItem("CPU", Icons.memory),
            const SizedBox(width: 18),
            _statusItem("Load", Icons.speed),
            const SizedBox(width: 18),
            _statusItem("Mode", Icons.bubble_chart),
            const SizedBox(width: 18),
            _statusItem("Emotion", Icons.favorite),
          ],
        ),
      ),
    );
  }

  Widget _statusItem(String label, IconData icon) {
    return GestureDetector(
      onTap: () => _onTap(label),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
