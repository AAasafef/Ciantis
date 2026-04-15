import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperModePanel
/// --------------------
/// Shows Ciantis' current mode and mode deltas with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - Mode pulse animations
class DeveloperModePanel extends StatefulWidget {
  const DeveloperModePanel({super.key});

  @override
  State<DeveloperModePanel> createState() => _DeveloperModePanelState();
}

class _DeveloperModePanelState extends State<DeveloperModePanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  String _currentMode = "Reflective";

  final List<Map<String, dynamic>> _modeDeltas = [
    {"label": "Focus ↑", "value": 0.14},
    {"label": "Calm ↓", "value": -0.09},
    {"label": "Energy ↑", "value": 0.11},
    {"label": "Stress ↓", "value": -0.06},
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

  void _onModeTap() {
    DeveloperLogger.log("Mode Panel → Current Mode tapped");

    // 🔊 Soft UI tap sound
    AmbientSoundEngine.instance.quickAction();

    // 🤍 Soft luxury haptic tap
    AmbientHapticsEngine.instance.softTap();

    _pulseController.forward(from: 0.0);
  }

  void _onDeltaTap(String label, double value) {
    DeveloperLogger.log(
      "Mode Panel → Delta tapped: $label (${(value * 100).toStringAsFixed(0)}%)",
    );

    // 🔊 Soft UI tap sound
    AmbientSoundEngine.instance.quickAction();

    // 🤍 Soft luxury haptic tap
    AmbientHapticsEngine.instance.softTap();

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CURRENT MODE
            GestureDetector(
              onTap: _onModeTap,
              child: Row(
                children: [
                  const Icon(Icons.bubble_chart,
                      color: Colors.tealAccent, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    "Mode: $_currentMode",
                    style: const TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // MODE DELTAS
            SizedBox(
              height: 46,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _modeDeltas.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final delta = _modeDeltas[index];
                  final label = delta["label"] as String;
                  final value = delta["value"] as double;

                  return GestureDetector(
                    onTap: () => _onDeltaTap(label, value),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
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
                          "$label ${(value * 100).toStringAsFixed(0)}%",
                          style: TextStyle(
                            color: value >= 0
                                ? Colors.tealAccent.withOpacity(0.85)
                                : Colors.redAccent.withOpacity(0.85),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
