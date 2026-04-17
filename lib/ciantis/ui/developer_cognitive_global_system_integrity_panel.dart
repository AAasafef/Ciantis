import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperCognitiveGlobalSystemIntegrityPanel
/// --------------------------------------------
/// Macro-level system integrity diagnostics for the entire Ciantis Cognitive Engine.
/// Shows global integrity, subsystem integrity contributions, integrity stability,
/// integrity recovery, and failure-risk indicators.
class DeveloperCognitiveGlobalSystemIntegrityPanel extends StatefulWidget {
  const DeveloperCognitiveGlobalSystemIntegrityPanel({super.key});

  @override
  State<DeveloperCognitiveGlobalSystemIntegrityPanel> createState() =>
      _DeveloperCognitiveGlobalSystemIntegrityPanelState();
}

class _DeveloperCognitiveGlobalSystemIntegrityPanelState
    extends State<DeveloperCognitiveGlobalSystemIntegrityPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _integrityMetrics = [
    {"label": "Global System Integrity", "value": 0.98, "icon": Icons.verified},
    {"label": "Reasoning Integrity", "value": 0.95, "icon": Icons.psychology},
    {"label": "Predictive Integrity", "value": 0.94, "icon": Icons.visibility},
    {"label": "Emotional Integrity", "value": 0.92, "icon": Icons.favorite},
    {"label": "Drift Integrity", "value": 0.91, "icon": Icons.waves},
    {"label": "Load Integrity", "value": 0.90, "icon": Icons.speed},
    {"label": "Coherence Integrity", "value": 0.96, "icon": Icons.hub},
    {"label": "Resonance Integrity", "value": 0.97, "icon": Icons.graphic_eq},
    {"label": "Integrity Stability Score", "value": 0.95, "icon": Icons.balance},
    {"label": "Integrity Recovery Rate", "value": 0.96, "icon": Icons.refresh},
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
      "Global System Integrity Panel → $label tapped (${(value * 100).toStringAsFixed(0)}%)",
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
          children: _integrityMetrics.map((metric) {
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
