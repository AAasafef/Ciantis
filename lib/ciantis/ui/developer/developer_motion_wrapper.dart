import 'package:flutter/material.dart';
import '../../universal/ambient_motion_engine.dart';

/// DeveloperMotionWrapper
/// -----------------------
/// Wraps any developer HUD panel with:
/// - Soft entry animation
/// - Subtle update pulse
/// - Adaptive motion
class DeveloperMotionWrapper extends StatefulWidget {
  final Widget child;
  final Key? updateKey;

  const DeveloperMotionWrapper({
    super.key,
    required this.child,
    this.updateKey,
  });

  @override
  State<DeveloperMotionWrapper> createState() => _DeveloperMotionWrapperState();
}

class _DeveloperMotionWrapperState extends State<DeveloperMotionWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    final motion = AmbientMotionEngine.instance;

    _controller = AnimationController(
      vsync: this,
      duration: motion.adaptiveDuration,
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: motion.adaptiveCurve,
    );

    _pulse = Tween<double>(begin: 1.0, end: 1.015)
        .chain(CurveTween(curve: motion.adaptiveCurve))
        .animate(_controller);

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant DeveloperMotionWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.updateKey != oldWidget.updateKey) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulse.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
