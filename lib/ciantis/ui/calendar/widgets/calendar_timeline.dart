import 'package:flutter/material.dart';
import '../../../universal/ambient_motion_engine.dart';

/// CalendarTimeline
/// -----------------
/// Luxury adaptive timeline with:
/// - Ambient motion
/// - Parallax scroll
/// - Soft item entry animations
class CalendarTimeline extends StatefulWidget {
  final List<String> events;

  const CalendarTimeline({
    super.key,
    required this.events,
  });

  @override
  State<CalendarTimeline> createState() => _CalendarTimelineState();
}

class _CalendarTimelineState extends State<CalendarTimeline>
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

    // Trigger entry animation
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
      child: ListView.builder(
        physics: _AmbientScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: widget.events.length,
        itemBuilder: (context, index) {
          final animation = CurvedAnimation(
            parent: _entryController,
            curve: Interval(
              (index * 0.08).clamp(0.0, 1.0),
              1.0,
              curve: motion.adaptiveCurve,
            ),
          );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(animation),
              child: _buildEventCapsule(widget.events[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventCapsule(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
          width: 1.2,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Ambient scroll physics
/// -----------------------
/// Scroll feel adapts to cognitive + emotional state.
class _AmbientScrollPhysics extends ScrollPhysics {
  const _AmbientScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  _AmbientScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _AmbientScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double get minFlingVelocity => 20.0;

  @override
  double get maxFlingVelocity => 2800.0;

  @override
  double get dragStartDistanceMotionThreshold => 3.0;

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final motion = AmbientMotionEngine.instance;

    // Slow down if reflective or high load
    final adjustedVelocity = velocity *
        (motion.adaptiveDuration.inMilliseconds / 420.0);

    return super.createBallisticSimulation(position, adjustedVelocity);
  }
}
