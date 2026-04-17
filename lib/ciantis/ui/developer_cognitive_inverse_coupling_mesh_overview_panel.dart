import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperCognitiveInverseCouplingMeshOverviewPanel
/// --------------------------------------------------
/// The panoramic overview of all inverse cognitive couplings.
/// Each cell shows:
/// - Coupling name
/// - Strength
/// - Stability
/// - Micro-motion + haptics + sound on tap
class DeveloperCognitiveInverseCouplingMeshOverviewPanel extends StatefulWidget {
  const DeveloperCognitiveInverseCouplingMeshOverviewPanel({super.key});

  @override
  State<DeveloperCognitiveInverseCouplingMeshOverviewPanel> createState() =>
      _DeveloperCognitiveInverseCouplingMeshOverviewPanelState();
}

class _DeveloperCognitiveInverseCouplingMeshOverviewPanelState
    extends State<DeveloperCognitiveInverseCouplingMeshOverviewPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _inverseCouplings = [
    {"label": "Emotion → Coherence", "strength": 0.94, "stability": 0.91},
    {"label": "Prediction → Emotion", "strength": 0.92, "stability": 0.89},
    {"label": "Load → Emotion", "strength": 0.90, "stability": 0.88},
    {"label": "Coherence → Prediction", "strength": 0.95, "stability": 0.93},
    {"label": "Drift → Prediction", "strength": 0.91, "stability": 0.87},
    {"label": "Resonance → Drift", "strength": 0.96, "stability": 0.94},
    {"label": "Emotion → Load", "strength": 0.89, "stability": 0.86},
    {"label": "Prediction → Coherence", "strength": 0.93, "stability": 0.90},
    {"label": "Coherence → Emotion", "strength": 0.92, "stability": 0.89},
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

  void _onCellTap(String label, double strength, double stability) {
    DeveloperLogger.log(
      "Inverse Coupling Mesh → $label tapped "
      "(Strength ${(strength * 100).toStringAsFixed(0)}%, "
      "Stability ${(stability * 100).toStringAsFixed(0)}%)",
    );

    AmbientSoundEngine.instance.quickAction();
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

        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.08),
              width: 1.2,
            ),
          ),
        ),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 1.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: _inverseCouplings.map((c) {
            final label = c["label"] as String;
            final strength = c["strength"] as double;
            final stability = c["stability"] as double;

            return GestureDetector(
              onTap: () => _onCellTap(label, strength, stability),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.10),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Strength ${(strength * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "Stability ${(stability * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(
                        color: Colors.white60,
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
