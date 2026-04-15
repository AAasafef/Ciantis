import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperEmotionPanel
/// ----------------------
/// Shows Ciantis' emotional state and deltas with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - Emotion pulse animations
class DeveloperEmotionPanel extends StatefulWidget {
  const DeveloperEmotionPanel({super.key});

  @override
  State<DeveloperEmotionPanel> createState() => _DeveloperEmotionPanelState();
}

class _DeveloperEmotionPanelState extends State<DeveloperEmotionPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  String _currentEmotion = "Calm";

  final List<Map<String, dynamic>> _emotionDeltas = [
    {"label": "Calm ↑", "value": 0.12},
    {"label": "Stress ↓", "value": -0.09},
    {"label": "Focus ↑", "value": 0.07},
    {"label": "Fatigue ↓", "value": -0.05},
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

  void _onEmotionTap() {
    DeveloperLogger.log("Emotion Panel → Current Emotion tapped");

    // 🔊 Soft UI tap sound
    AmbientSoundEngine.instance.quickAction();

    // 🤍 Soft luxury haptic tap
    AmbientHapticsEngine.instance.softTap();

    _pulseController.forward(from: 0.0);
  }

  void _onDeltaTap(String label, double value) {
    DeveloperLogger.log(
      "Emotion Panel → Delta tapped: $label (${(value * 100).toStringAsFixed(0)}%)",
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
            // CURRENT EMOTION
            GestureDetector(
              onTap: _onEmotionTap,
              child: Row(
                children: [
                  const Icon(Icons.favorite,
                      color: Colors.tealAccent, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    "Emotion: $_currentEmotion",
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

            // EMOTION DELTAS
            SizedBox(
              height: 46,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _emotionDeltas.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final delta = _emotionDeltas[index];
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
