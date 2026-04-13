import 'package:flutter/material.dart';
import '../../universal/ambient_motion_engine.dart';

/// HomeScreen
/// -----------
/// Luxury adaptive home surface with:
/// - Hero motion
/// - Parallax
/// - Micro-interactions
/// - Staggered module entry
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
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

  @override
  Widget build(BuildContext context) {
    final motion = AmbientMotionEngine.instance;

    return NotificationListener<ScrollNotification>(
      onNotification: (scroll) {
        setState(() {}); // triggers parallax
        return false;
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        children: [
          _buildHeroCard(),

          const SizedBox(height: 30),

          _buildQuickActions(),

          const SizedBox(height: 40),

          _buildSection(
            title: "Today’s Focus",
            index: 1,
            child: const Text(
              "Stay centered. One step at a time.",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),

          const SizedBox(height: 30),

          _buildSection(
            title: "Next Best Action",
            index: 2,
            child: const Text(
              "Review your tasks and upcoming events.",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),

          const SizedBox(height: 30),

          _buildSection(
            title: "Upcoming",
            index: 3,
            child: const Text(
              "You have 3 events today.",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // HERO CARD
  // ------------------------------------------------------------
  Widget _buildHeroCard() {
    final motion = AmbientMotionEngine.instance;

    final fade = CurvedAnimation(
      parent: _entryController,
      curve: Interval(0.0, 0.4, curve: motion.adaptiveCurve),
    );

    final slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Interval(0.0, 0.4, curve: motion.adaptiveCurve),
      ),
    );

    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
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
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Afternoon, Shaverian",
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
              SizedBox(height: 6),
              Text(
                "Here’s your day at a glance.",
                style: TextStyle(fontSize: 15, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // QUICK ACTIONS
  // ------------------------------------------------------------
  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _quickAction("Tasks", Icons.check_circle),
        _quickAction("Calendar", Icons.calendar_month),
        _quickAction("Profile", Icons.person),
      ],
    );
  }

  Widget _quickAction(String label, IconData icon) {
    final motion = AmbientMotionEngine.instance;

    return GestureDetector(
      onTapDown: (_) => _entryController.reverse(),
      onTapUp: (_) => _entryController.forward(),
      onTapCancel: () => _entryController.forward(),

      child: AnimatedBuilder(
        animation: _entryController,
        builder: (context, child) {
          final scale = Tween<double>(begin: 1.0, end: 0.94)
              .chain(CurveTween(curve: motion.adaptiveCurve))
              .evaluate(_entryController);

          return Transform.scale(
            scale: scale,
            child: child,
          );
        },

        child: Container(
          width: 90,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.10),
              width: 1.2,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white70, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SECTIONS
  // ------------------------------------------------------------
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
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
