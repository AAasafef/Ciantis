import 'package:flutter/material.dart';
import '../../universal/ambient_motion_engine.dart';
import '../../universal/ambient_sound_engine.dart';
import '../../universal/ambient_haptics_engine.dart';

/// ProfileScreen
/// --------------
/// Luxury adaptive profile surface with:
/// - Smooth entry motion
/// - Soft action taps
/// - Sound + haptics on interactions
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
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
    // 🔊 Soft UI tap sound
    AmbientSoundEngine.instance.quickAction();

    // 🤍 Soft luxury haptic tap
    AmbientHapticsEngine.instance.softTap();

    // Handle action (placeholder)
    debugPrint("Profile action tapped → $action");
  }

  @override
  Widget build(BuildContext context) {
    final motion = AmbientMotionEngine.instance;

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _entryController,
        curve: motion.adaptiveCurve,
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        children: [
          _buildHeader(),

          const SizedBox(height: 30),

          _buildActionTile("Edit Profile", Icons.edit),
          _buildActionTile("Settings", Icons.settings),
          _buildActionTile("Notifications", Icons.notifications),
          _buildActionTile("Privacy", Icons.lock),
          _buildActionTile("Logout", Icons.logout),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 34,
          backgroundColor: Colors.white.withOpacity(0.15),
          child: const Icon(Icons.person, size: 40, color: Colors.white),
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Profile",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            SizedBox(height: 4),
            Text(
              "Manage your account",
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ],
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
