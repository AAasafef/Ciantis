import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperSystemLoadPanel
/// -------------------------
/// Shows Ciantis' system performance load with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - Load pulse animations
class DeveloperSystemLoadPanel extends StatefulWidget {
  const DeveloperSystemLoadPanel({super.key});

  @override
  State<DeveloperSystemLoadPanel> createState() =>
      _DeveloperSystemLoadPanelState();
}

class _DeveloperSystemLoadPanelState extends State<DeveloperSystemLoadPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _systemMetrics = [
    {"label": "CPU Load", "value": 0.37, "icon": Icons.memory},
    {"label": "RAM Usage", "value": 0.54, "icon": Icons.storage},
    {"label": "I/O Activity", "value": 0.22, "icon": Icons.sync},
    {"label": "GPU Load", "value": 0.41, "icon": Icons.graphic_eq},
    {"label": "Thermals", "value": 0.33, "icon": Icons.thermostat},
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
      "System Load Panel → $label tapped (${(value * 100).toStringAsFixed(0)}%)",
    );

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
        child: SizedBox(
          height: 46,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _systemMetrics.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final metric = _systemMetrics[index];
              final label = metric["label"] as String;
              final value = metric["value"] as double;
              final icon = metric["icon"] as IconData;

              return GestureDetector(
                onTap: () => _onMetricTap(label, value),
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
                  child: Row(
                    children: [
                      Icon(icon, color: Colors.white70, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        "$label ${(value * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
