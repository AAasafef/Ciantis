import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperCognitiveGlobalNoisePanel
/// ----------------------------------
/// Macro-level noise diagnostics for the entire Ciantis Cognitive Engine.
/// Shows global noise, subsystem noise contributions, noise stability,
/// noise suppression efficiency, and harmonic distortion.
class DeveloperCognitiveGlobalNoisePanel extends StatefulWidget {
  const DeveloperCognitiveGlobalNoisePanel({super.key});

  @override
  State<DeveloperCognitiveGlobalNoisePanel> createState() =>
      _DeveloperCognitiveGlobalNoisePanelState();
}

class _DeveloperCognitiveGlobalNoisePanelState
    extends State<DeveloperCognitiveGlobalNoisePanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _noiseMetrics = [
    {"label": "Global Noise Index", "value": 0.12, "icon": Icons.noise_control_off},
    {"label": "Reasoning Noise", "value": 0.10, "icon": Icons.psychology},
    {"label": "Predictive Noise", "value": 0.11, "icon": Icons.visibility},
    {"label": "Emotional Noise", "value": 0.13, "icon": Icons.favorite},
    {"label": "Drift Noise", "value": 0.14, "icon": Icons.waves},
    {"label": "Load Noise", "value": 0.12, "icon": Icons.speed},
    {"label": "Coherence Noise", "value": 0.09, "icon": Icons.hub},
    {"label": "Resonance Noise", "value": 0.08, "icon": Icons.graphic_eq},
    {"label": "Noise Stability Score", "value": 0.91, "icon": Icons.balance},
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
      "Global Noise Panel → $label tapped (${(value * 100).toStringAsFixed(0)}%)",
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
          children: _noiseMetrics.map((metric) {
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
