import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperPredictionPanel
/// -------------------------
/// Shows Ciantis' short-term predictions with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - Prediction pulse animations
class DeveloperPredictionPanel extends StatefulWidget {
  const DeveloperPredictionPanel({super.key});

  @override
  State<DeveloperPredictionPanel> createState() =>
      _DeveloperPredictionPanelState();
}

class _DeveloperPredictionPanelState extends State<DeveloperPredictionPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _predictions = [
    {"label": "User will open Tasks", "confidence": 0.82},
    {"label": "User will check Calendar", "confidence": 0.74},
    {"label": "User will adjust Mode", "confidence": 0.63},
    {"label": "User will review NBA", "confidence": 0.58},
    {"label": "User will open Drawer", "confidence": 0.51},
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

  void _onPredictionTap(String label) {
    DeveloperLogger.log("Prediction Panel → Prediction tapped: $label");

    // 🔊 Soft UI tap sound
    AmbientSoundEngine.instance.quickAction();

    // 🤍 Soft luxury haptic tap
    AmbientHapticsEngine.instance.softTap();

    // Pulse animation
    _pulseController.forward(from: 0.0);
  }

  void _onConfidenceTap(double confidence) {
    DeveloperLogger.log(
        "Prediction Panel → Confidence tapped: ${(confidence * 100).toStringAsFixed(0)}%");

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _predictions.map((p) {
            final label = p["label"] as String;
            final confidence = p["confidence"] as double;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  // PREDICTION TAP
                  GestureDetector(
                    onTap: () => _onPredictionTap(label),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
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
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // CONFIDENCE TAP
                  GestureDetector(
                    onTap: () => _onConfidenceTap(confidence),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.tealAccent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.tealAccent.withOpacity(0.35),
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        "${(confidence * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(
                          color: Colors.tealAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
