import 'package:flutter/material.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';
import '../universal/ambient_haptics_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperMenuScreen
/// --------------------
/// Luxury adaptive developer menu with:
/// - Smooth entry motion
/// - Soft action taps
/// - Sound + haptics on interactions
class DeveloperMenuScreen extends StatefulWidget {
  const DeveloperMenuScreen({super.key});

  @override
  State<DeveloperMenuScreen> createState() => _DeveloperMenuScreenState();
}

class _DeveloperMenuScreenState extends State<DeveloperMenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;

  @override
  void initState() {
    super.initState();

    final motion = AmbientMotionEngine.instance;

    _entryController = AnimationController(
      vsync: this,
      duration: motion.adaptiveDuration,
    );

    _entryController.forward();
  }

  void _onActionTap(String action) {
    DeveloperLogger.log("Developer Menu → $action tapped");

    // 🔊 Soft UI tap sound
    AmbientSoundEngine.instance.quickAction();

    // 🤍 Soft luxury haptic tap
    AmbientHapticsEngine.instance.softTap();
  }

  @override
  Widget build(BuildContext context) {
    final motion = AmbientMotionEngine.instance;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Developer Menu"),
        backgroundColor: Colors.black,
      ),
      body: FadeTransition(
        opacity: CurvedAnimation(
          parent: _entryController,
          curve: motion.adaptiveCurve,
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          children: [
            _buildActionTile("View Logs", Icons.list),
            _buildActionTile("System State", Icons.memory),
            _buildActionTile("Emotion Engine", Icons.favorite),
            _buildActionTile("Mode Engine", Icons.bubble_chart),
            _buildActionTile("NBA Engine", Icons.auto_awesome),
            _buildActionTile("Prediction Engine", Icons.timeline),
            _buildActionTile("Cognitive Load", Icons.speed),
            _buildActionTile("Opportunity Engine", Icons.lightbulb),
            _buildActionTile("Developer Panels", Icons.dashboard_customize),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(String label, IconData icon) {
    final motion = AmbientMotionEngine.instance;

    return GestureDetector(
      onTapDown: (_) {
        // 🔊 Sound
        AmbientSoundEngine.instance.quickAction();

        // 🤍 Haptic
        AmbientHapticsEngine.instance.softTap();

        _entryController.reverse();
      },
      onTapUp: (_) {
        _entryController.forward();
        _onActionTap(label);
      },
      onTapCancel: () => _entryController.forward(),

      child: AnimatedBuilder(
        animation: _entryController,
        builder: (context, child) {
          final scale = Tween<double>(begin: 1.0, end: 0.96)
              .chain(CurveTween(curve: motion.adaptiveCurve))
              .evaluate(_entryController);

          return Transform.scale(
            scale: scale,
            child: child,
          );
        },

        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
          margin: const EdgeInsets.only(bottom: 16),
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
              Icon(icon, color: Colors.white70, size: 26),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}
