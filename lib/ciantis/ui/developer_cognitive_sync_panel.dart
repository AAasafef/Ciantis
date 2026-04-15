import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperCognitiveSyncPanel
/// ----------------------------
/// Shows Ciantis' internal cognitive sync cycles with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - Sync pulse animations
class DeveloperCognitiveSyncPanel extends StatefulWidget {
  const DeveloperCognitiveSyncPanel({super.key});

  @override
  State<DeveloperCognitiveSyncPanel> createState() =>
      _DeveloperCognitiveSyncPanelState();
}

class _DeveloperCognitiveSyncPanelState
    extends State<DeveloperCognitiveSyncPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _syncEvents = [
    {"label": "Memory Sync Completed", "time": "08:23 AM"},
    {"label": "Prediction Sync Updated", "time": "08:24 AM"},
    {"label": "Mode/Emotion Alignment", "time": "08:25 AM"},
    {"label": "Load Harmonization", "time": "08:26 AM"},
    {"label": "System Recalibration", "time": "08:27 AM"},
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

  void _onSyncTap(String label, String time) {
    DeveloperLogger.log(
      "Cognitive Sync Panel → Sync tapped: $label at $time",
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
          children: _syncEvents.map((event) {
            final label = event["label"] as String;
            final time = event["time"] as String;

            return GestureDetector(
              onTap: () => _onSyncTap(label, time),
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
                    const Icon(Icons.sync, color: Colors.white70, size: 20),
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
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
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
