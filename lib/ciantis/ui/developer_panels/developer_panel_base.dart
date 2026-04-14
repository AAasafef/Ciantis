import 'package:flutter/material.dart';
import '../../universal/ambient_motion_engine.dart';
import '../../universal/ambient_sound_engine.dart';
import '../../universal/ambient_haptics_engine.dart';

/// DeveloperPanelBase
/// -------------------
/// Shared base class for all developer panels.
/// Provides:
/// - Smooth expand/collapse motion
/// - Soft sound + haptics on interactions
/// - Consistent luxury micro-interactions
class DeveloperPanelBase extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;

  const DeveloperPanelBase({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = true,
  });

  @override
  State<DeveloperPanelBase> createState() => _DeveloperPanelBaseState();
}

class _DeveloperPanelBaseState extends State<DeveloperPanelBase>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();

    _expanded = widget.initiallyExpanded;

    final motion = AmbientMotionEngine.instance;

    _controller = AnimationController(
      vsync: this,
      duration: motion.adaptiveDuration,
      value: _expanded ? 1.0 : 0.0,
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: motion.adaptiveCurve,
    );
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);

    // 🔊 Soft UI tap sound
    AmbientSoundEngine.instance.quickAction();

    // 🤍 Soft luxury haptic tap
    AmbientHapticsEngine.instance.softTap();

    if (_expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _toggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _expanded ? 0.0 : -0.25,
                    duration: AmbientMotionEngine.instance.adaptiveDuration,
                    curve: AmbientMotionEngine.instance.adaptiveCurve,
                    child: const Icon(
                      Icons.expand_more,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
