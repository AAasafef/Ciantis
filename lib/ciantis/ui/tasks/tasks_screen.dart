import 'package:flutter/material.dart';
import '../../universal/ambient_motion_engine.dart';
import 'widgets/task_capsule.dart';

/// TasksScreen
/// ------------
/// Luxury adaptive task surface with:
/// - Staggered entry animations
/// - Micro-interactions
/// - Ambient scroll physics
/// - Parallax
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;

  final List<String> _tasks = const [
    "Review calendar for the day",
    "Complete LPN coursework module",
    "Prepare salon client notes",
    "Check developer logs for Ciantis",
    "Plan meals for the twins",
    "Organize financial tasks",
  ];

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
    return NotificationListener<ScrollNotification>(
      onNotification: (scroll) {
        setState(() {}); // triggers parallax
        return false;
      },
      child: ListView.builder(
        physics: _AmbientTaskScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        itemCount: _tasks.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildHeader();
          }

          final taskIndex = index - 1;

          return _buildAnimatedTask(taskIndex);
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------
  Widget _buildHeader() {
    final motion = AmbientMotionEngine.instance;

    final fade = CurvedAnimation(
      parent: _entryController,
      curve: Interval(0.0, 0.3, curve: motion.adaptiveCurve),
    );

    final slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Interval(0.0, 0.3, curve: motion.adaptiveCurve),
      ),
    );

    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            "Your Tasks",
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // TASK ENTRY ANIMATION
  // ------------------------------------------------------------
  Widget _buildAnimatedTask(int index) {
    final motion = AmbientMotionEngine.instance;

    final animation = CurvedAnimation(
      parent: _entryController,
      curve: Interval(
        (index * 0.12).clamp(0.0, 1.0),
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
        child: TaskCapsule(title: _tasks[index]),
      ),
    );
  }
}

/// Ambient scroll physics for tasks
/// ---------------------------------
class _AmbientTaskScrollPhysics extends ScrollPhysics {
  const _AmbientTaskScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  _AmbientTaskScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _AmbientTaskScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double get minFlingVelocity => 20.0;

  @override
  double get maxFlingVelocity => 2600.0;

  @override
  double get dragStartDistanceMotionThreshold => 3.0;

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final motion = AmbientMotionEngine.instance;

    final adjustedVelocity = velocity *
        (motion.adaptiveDuration.inMilliseconds / 420.0);

    return super.createBallisticSimulation(position, adjustedVelocity);
  }
}
