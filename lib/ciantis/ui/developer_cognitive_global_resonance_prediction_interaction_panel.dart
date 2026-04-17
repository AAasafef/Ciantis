import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperCognitiveGlobalResonancePredictionInteractionPanel
/// -----------------------------------------------------------
/// Macro-level resonance↔prediction interaction diagnostics for the Ciantis Cognitive Engine.
/// Shows global interaction index, subsystem contributions, interaction stability,
/// harmonic drift sensitivity, predictive distortion, and amplification risk.
class DeveloperCognitiveGlobalResonancePredictionInteractionPanel extends StatefulWidget {
  const DeveloperCognitiveGlobalResonancePredictionInteractionPanel({super.key});

  @override
  State<DeveloperCognitiveGlobalResonancePredictionInteractionPanel> createState() =>
      _DeveloperCognitiveGlobalResonancePredictionInteractionPanelState();
}

class _DeveloperCognitiveGlobalResonancePredictionInteractionPanelState
    extends State<DeveloperCognitiveGlobalResonancePredictionInteractionPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _interactionMetrics = [
    {"label": "Global Resonance↔Prediction Interaction", "value": 0.92, "icon": Icons.sync},
    {"label": "Reasoning Resonance ↔ Prediction", "value": 0.90, "icon": Icons.psychology},
    {"label": "Emotional Resonance ↔ Prediction", "value": 0.89, "icon": Icons.favorite},
    {"label": "Drift Resonance ↔ Prediction", "value": 0.88, "icon": Icons.waves},
    {"label": "Load Resonance ↔ Prediction", "value": 0.87, "icon": Icons.speed},
    {"label": "Coherence Resonance ↔ Prediction", "value": 0.91, "icon": Icons.hub},
    {"label": "Harmonic Resonance ↔ Prediction", "value": 0.94, "icon": Icons.auto_awesome},
    {"label": "Interaction Stability Score", "value": 0.93, "icon": Icons.balance},
    {"label": "Predictive Distortion Index", "value": 0.08, "icon": Icons.warning_amber},
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

  void _onMetricTap(String label, double value) {
    DeveloperLogger.log(
      "Global Resonance↔Prediction Interaction Panel → $label tapped (${(value * 100).toStringAsFixed(0)}%)",
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
        child: Column(
          children: _interactionMetrics.map((metric) {
            final label = metric["label"] as String;
            final value = metric["value"] as double;
            final icon = metric["icon"] as IconData;

            return GestureDetector(
              onTap: () => _onMetricTap(label, value),
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.10),
                    width: 1.2,
                  ),
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
