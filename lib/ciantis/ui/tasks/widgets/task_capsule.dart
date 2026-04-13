import 'package:flutter/material.dart';
import '../../../universal/ambient_motion_engine.dart';

/// TaskCapsule
/// ------------
/// Luxury micro-interactive task capsule.
/// Adaptive motion based on cognitive + emotional state.
class TaskCapsule extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;

  const TaskCapsule({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  State<TaskCapsule> createState() => _TaskCapsuleState();
}

class _TaskCapsuleState extends State<TaskCapsule>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    final motion = AmbientMotionEngine.instance;

    _controller = AnimationController(
      vsync: this,
      duration: motion.adaptiveDuration,
    );

    _scale = Tween<double>(begin: 1.0, end: 0.98)
        .chain(CurveTween(curve: motion.adaptiveCurve))
        .animate(_controller);
  }

  void _pressDown() {
    _controller.forward();
  }

  void _pressUp() {
    _controller.reverse();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressDown(),
      onTapUp: (_) => _pressUp(),
      onTapCancel: () => _controller.reverse(),

      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: child,
          );
        },

        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withOpacity(0.10),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
