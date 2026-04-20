import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperCognitiveGlobalHarmonicPredictionCoherenceResonanceEmotionInteractionPanel
/// ------------------------------------------------------------------------------------
/// Penta-axis harmonic↔prediction↔coherence↔resonance↔emotion diagnostics for the Ciantis Cognitive Engine.
/// Shows global penta-axis index, subsystem contributions, stability, emotional drift sensitivity,
/// distortion index, and amplification risk.
class DeveloperCognitiveGlobalHarmonicPredictionCoherenceResonanceEmotionInteractionPanel extends StatefulWidget {
  const DeveloperCognitiveGlobalHarmonicPredictionCoherenceResonanceEmotionInteractionPanel({super.key});

  @override
  State<DeveloperCognitiveGlobalHarmonicPredictionCoherenceResonanceEmotionInteractionPanel> createState() =>
      _DeveloperCognitiveGlobalHarmonicPredictionCoherenceResonanceEmotionInteractionPanelState();
}

class _DeveloperCognitiveGlobalHarmonicPredictionCoherenceResonanceEmotionInteractionPanelState
    extends State<DeveloperCognitiveGlobalHarmonicPredictionCoherenceResonanceEmotionInteractionPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _interactionMetrics = [
    {"label": "Global Harmonic↔Prediction↔Coherence↔Resonance↔Emotion Interaction", "value": 0.92, "icon": Icons.sync},
    {"label": "Reasoning Harmonics ↔ Prediction ↔ Coherence ↔ Resonance ↔ Emotion", "value": 0.90, "icon": Icons.psychology},
    {"label": "Drift Harmonics ↔ Prediction ↔ Coherence ↔ Resonance ↔ Emotion", "value": 0.89, "icon": Icons.waves},
    {"label": "Load Harmonics ↔ Prediction ↔ Coherence ↔ Resonance ↔ Emotion", "value": 0.88, "icon": Icons.speed},
    {"label": "Penta-Axis Stability Score", "value": 0.93, "icon": Icons.balance},
    {"label": "Penta-Axis Distortion Index", "value": 0.10, "icon": Icons.warning_amber},
  ];

  @override
  void initState() {
    super.initState();
    final motion = AmbientMotionEngine.instance;
    _pulseController = AnimationController(vsync: this, duration: motion.adaptiveDuration);
  }

  void _onMetricTap(String label, double value) {
    DeveloperLogger.log(
      "Global Harmonic↔Prediction↔Coherence↔Resonance↔Emotion Interaction Panel → $label tapped (${(value * 100).toStringAsFixed(0)}%)",
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
          border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.08), width: 1.2)),
        ),
        child: Column(
          children: _interactionMetrics.map((metric) {
            final label = metric["label"];
            final value = metric["value"];
            final icon = metric["icon"];

            return GestureDetector(
              onTap: () => _onMetricTap(label, value),
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.10), width: 1.2),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: Colors.white70, size: 22),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        "$label ${(value * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
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
