import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/developer_logger.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';

/// DeveloperLogOverlay
/// --------------------
/// Luxury adaptive log overlay with:
/// - Fade + slide entry
/// - Pulse on new logs
/// - Parallax scroll
/// - Ambient motion + sound + haptics identity
class DeveloperLogOverlay extends StatefulWidget {
  const DeveloperLogOverlay({super.key});

  @override
  State<DeveloperLogOverlay> createState() => _DeveloperLogOverlayState();
}

class _DeveloperLogOverlayState extends State<DeveloperLogOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    final motion = AmbientMotionEngine.instance;

    _entryController = AnimationController(
      vsync: this,
      duration: motion.adaptiveDuration,
    );

    _fade = CurvedAnimation(
      parent: _entryController,
      curve: motion.adaptiveCurve,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: motion.adaptiveCurve,
      ),
    );

    _entryController.forward();

    DeveloperLogger.addListener(_onNewLog);
  }

  @override
  void dispose() {
    DeveloperLogger.removeListener(_onNewLog);
    _entryController.dispose();
    super.dispose();
  }

  void _onNewLog() {
    // 🔊 Play subtle log pulse sound
    AmbientSoundEngine.instance.logPulse();

    // 🤍 Soft luxury haptic pulse
    AmbientHapticsEngine.instance.pulse();

    // Trigger pulse animation
    _entryController.forward(from: 0.0);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final logs = DeveloperLogger.logs;

    return IgnorePointer(
      ignoring: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: Container(
              height: 220,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.10),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: NotificationListener<ScrollNotification>(
                onNotification: (scroll) {
                  setState(() {});
                  return false;
                },
                child: ListView.builder(
                  reverse: true,
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[logs.length - 1 - index];

                    return AnimatedBuilder(
                      animation: _entryController,
                      builder: (context, child) {
                        final scale = Tween<double>(begin: 1.0, end: 1.015)
                            .chain(CurveTween(
                                curve: AmbientMotionEngine.instance.adaptiveCurve))
                            .evaluate(_entryController);

                        return Transform.scale(
                          scale: scale,
                          child: child,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          log,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
