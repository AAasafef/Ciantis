import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperCognitiveHealthPanel
/// ------------------------------
/// Shows Ciantis' cognitive health state with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - Health pulse animations
class DeveloperCognitiveHealthPanel extends StatefulWidget {
  const DeveloperCognitiveHealthPanel({super.key});

  @override
  State<DeveloperCognitiveHealthPanel> createState() =>
      _DeveloperCognitiveHealthPanelState();
}

class _DeveloperCognitiveHealthPanelState
    extends State<DeveloperCognitiveHealthPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  double _healthScore = 0.78;

  final List<Map<String, dynamic>> _healthSignals = [
    {"label": "Stability", "value": 0.82},
    {"label": "Resilience", "value": 0.76},
    {"label": "Stress", "value": 0.33},
    {"label": "Recovery", "value": 0.69},
    {"label": "Clarity", "value": 0.88},
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

  void _onHealthTap() {
    DeveloperLogger.log("Cognitive Health Panel → Health tapped");

    // 🔊 Soft UI tap sound
    AmbientSoundEngine.instance.quickAction();

    // 🤍 Soft luxury haptic tap
    AmbientHapticsEngine.instance.softTap();

    _pulseController.forward(from: 0.0);
  }

  void _onSignalTap(String label, double value) {
    DeveloperLogger.log(
        "Cognitive Health Panel → Signal tapped: $label (${(value * 100).toStringAsFixed(0)}%)");

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
            // CURRENT HEALTH SCORE
            GestureDetector(
              onTap: _onHealthTap,
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.tealAccent, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    "Health: ${( _healthScore * 100 ).toStringAsFixed(0)}%",
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

            // HEALTH SIGNALS
            SizedBox(
              height: 46,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _healthSignals.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final signal = _healthSignals[index];
                  final label = signal["label"] as String;
                  final value = signal["value"] as double;

                  return GestureDetector(
                    onTap: () => _onSignalTap(label, value),
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
          ],
        ),
      ),
    );
  }
}
