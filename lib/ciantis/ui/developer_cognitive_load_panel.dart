import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperCognitiveLoadPanel
/// ----------------------------
/// Shows Ciantis' cognitive load state with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - Load pulse animations
class DeveloperCognitiveLoadPanel extends StatefulWidget {
  const DeveloperCognitiveLoadPanel({super.key});

  @override
  State<DeveloperCognitiveLoadPanel> createState() =>
      _DeveloperCognitiveLoadPanelState();
}

class _DeveloperCognitiveLoadPanelState
    extends State<DeveloperCognitiveLoadPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  double _currentLoad = 0.42;

  final List<Map<String, dynamic>> _loadSources = [
    {"label": "Tasks", "weight": 0.28},
    {"label": "Calendar", "weight": 0.19},
    {"label": "Mode", "weight": 0.14},
    {"label": "Emotion", "weight": 0.11},
    {"label": "Opportunity", "weight": 0.09},
    {"label": "NBA", "weight": 0.07},
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

  void _onLoadTap() {
    DeveloperLogger.log("Cognitive Load Panel → Load tapped");

    // 🔊 Soft UI tap sound
    AmbientSoundEngine.instance.quickAction();

    // 🤍 Soft luxury haptic tap
    AmbientHapticsEngine.instance.softTap();

    _pulseController.forward(from: 0.0);
  }

  void _onSourceTap(String label, double weight) {
    DeveloperLogger.log(
        "Cognitive Load Panel → Source tapped: $label (${(weight * 100).toStringAsFixed(0)}%)");

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
            // CURRENT LOAD
            GestureDetector(
              onTap: _onLoadTap,
              child: Row(
                children: [
                  const Icon(Icons.speed, color: Colors.tealAccent, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    "Load: ${( _currentLoad * 100 ).toStringAsFixed(0)}%",
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

            // LOAD SOURCES
            SizedBox(
              height: 46,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _loadSources.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final source = _loadSources[index];
                  final label = source["label"] as String;
                  final weight = source["weight"] as double;

                  return GestureDetector(
                    onTap: () => _onSourceTap(label, weight),
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
                          "$label ${(weight * 100).toStringAsFixed(0)}%",
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
