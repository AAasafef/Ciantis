import 'package:flutter/material.dart';
import '../../universal/ambient_motion_engine.dart';

/// ProfileScreen
/// --------------
/// Luxury identity surface with ambient motion.
/// Calm, elegant, adaptive, neoclassic.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _identityFade;
  late Animation<Offset> _identitySlide;

  @override
  void initState() {
    super.initState();

    final motion = AmbientMotionEngine.instance;

    _entryController = AnimationController(
      vsync: this,
      duration: motion.adaptiveDuration,
    );

    _identityFade = CurvedAnimation(
      parent: _entryController,
      curve: Interval(0.0, 0.4, curve: motion.adaptiveCurve),
    );

    _identitySlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Interval(0.0, 0.4, curve: motion.adaptiveCurve),
      ),
    );

    _entryController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final motion = AmbientMotionEngine.instance;

    return FadeTransition(
      opacity: _identityFade,
      child: SlideTransition(
        position: _identitySlide,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          children: [
            _buildIdentityCapsule(),

            const SizedBox(height: 40),

            _buildSection(
              title: "About You",
              index: 1,
              child: const Text(
                "Ciantis Owner\nLuxury OS Architect\nCreative Director",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),

            const SizedBox(height: 30),

            _buildSection(
              title: "Preferences",
              index: 2,
              child: const Text(
                "Neoclassic Aesthetic\nCalm Motion\nUnified Branding\nPremium Transitions",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),

            const SizedBox(height: 30),

            _buildSection(
              title: "System Identity",
              index: 3,
              child: const Text(
                "Ciantis OS v1.0\nAdaptive Motion Engine\nCognitive Awareness Enabled",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentityCapsule() {
    final motion = AmbientMotionEngine.instance;

    return GestureDetector(
      onTapDown: (_) => _entryController.reverse(),
      onTapUp: (_) => _entryController.forward(),
      onTapCancel: () => _entryController.forward(),

      child: AnimatedBuilder(
        animation: _entryController,
        builder: (context, child) {
          final scale = Tween<double>(begin: 1.0, end: 0.97)
              .chain(CurveTween(curve: motion.adaptiveCurve))
              .evaluate(_entryController);

          return Transform.scale(
            scale: scale,
            child: child,
          );
        },

        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.10),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                ),
                child: const Icon(Icons.person, color: Colors.white70, size: 32),
              ),
              const SizedBox(width: 20),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Shaverian",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Ciantis Owner",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required int index,
    required Widget child,
  }) {
    final motion = AmbientMotionEngine.instance;

    final animation = CurvedAnimation(
      parent: _entryController,
      curve: Interval(
        (index * 0.15).clamp(0.0, 1.0),
        1.0,
        curve: motion.adaptiveCurve,
      ),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(animation),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
