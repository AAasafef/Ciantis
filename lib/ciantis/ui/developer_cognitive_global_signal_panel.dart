import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperCognitiveGlobalSignalPanel
/// -----------------------------------
/// Macro-level signal diagnostics for the entire Ciantis Cognitive Engine.
/// Shows global signal strength, subsystem signal contributions, signal stability,
/// signal purity, and signal-noise separation efficiency.
class DeveloperCognitiveGlobalSignalPanel extends StatefulWidget {
  const DeveloperCognitiveGlobalSignalPanel({super.key});

  @override
  State<DeveloperCognitiveGlobalSignalPanel> createState() =>
      _DeveloperCognitiveGlobalSignalPanelState();
}

class _DeveloperCognitiveGlobalSignalPanelState
    extends State<DeveloperCognitiveGlobalSignalPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _signalMetrics = [
    {"label": "Global Signal Strength", "value": 0.96, "icon": Icons.signal_cellular_alt},
    {"label": "Reasoning Signal", "value": 0.94, "icon": Icons.psychology},
    {"label": "Predictive Signal", "value": 0.93, "icon": Icons.visibility},
    {"label": "Emotional Signal", "value": 0.92, "icon": Icons.favorite},
    {"label": "Drift-Signal", "value": 0.90, "icon": Icons.waves},
    {"label": "Load-Signal", "value": 0.89, "icon": Icons.speed},
    {"label": "Coherence-Signal", "value": 0.95, "icon": Icons.hub},
    {"label": "Resonance-Signal", "value": 0.97, "icon": Icons.graphic_eq},
    {"label": "Signal Stability Score", "value": 0.95, "icon": Icons.balance},
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
      "Global Signal Panel → $label tapped (${(value * 100).toStringAsFixed(0)}%)",
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
          children: _signalMetrics.map((metric) {
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
