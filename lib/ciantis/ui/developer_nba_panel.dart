import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperNbaPanel
/// ------------------
/// Shows Ciantis' current Next Best Action with:
/// - Smooth micro-motion
/// - Soft sound + haptics on interactions
/// - NBA pulse animations
class DeveloperNbaPanel extends StatefulWidget {
  const DeveloperNbaPanel({super.key});

  @override
  State<DeveloperNbaPanel> createState() => _DeveloperNbaPanelState();
}

class _DeveloperNbaPanelState extends State<DeveloperNbaPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<String> _nbaReasons = [
    "Energy Match",
    "Opportunity Alignment",
    "Cognitive Load Balance",
    "Emotional Stability",
    "Task Priority",
    "Calendar Sync",
  ];

  String _currentNba = "Review Today’s Tasks";

  @override
  void initState() {
    super.initState();

    final motion = AmbientMotionEngine.instance;

    _pulseController = AnimationController(
      vsync: this,
      duration: motion.adaptiveDuration,
    );
  }

  void _onNbaTap() {
    DeveloperLogger.log("NBA Panel → Current NBA tapped");

    // 🔊 Soft UI tap sound
    AmbientSoundEngine.instance.quickAction();

    // 🤍 Soft luxury haptic tap
    AmbientHapticsEngine.instance.softTap();

    // Pulse animation
    _pulseController.forward(from: 0.0);
  }

  void _onReasonTap(String reason) {
    DeveloperLogger.log("NBA Panel → Reason tapped: $reason");

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
          children: [
            // CURRENT NBA
            GestureDetector(
              onTap: _onNbaTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.tealAccent, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      _currentNba,
                      style: const TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // REASONS
            SizedBox(
              height: 46,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _nbaReasons.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final reason = _nbaReasons[index];

                  return GestureDetector(
                    onTap: () => _onReasonTap(reason),
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
                          reason,
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
