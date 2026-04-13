import 'package:flutter/material.dart';
import '../../../universal/ambient_motion_engine.dart';
import '../../../universal/ambient_sound_engine.dart';
import '../../../universal/ambient_haptics_engine.dart';

/// CalendarTimeline
/// ----------------
/// Luxury adaptive calendar timeline with:
/// - Smooth scroll
/// - Soft selection motion
/// - Sound + haptics on date tap
class CalendarTimeline extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarTimeline({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<CalendarTimeline> createState() => _CalendarTimelineState();
}

class _CalendarTimelineState extends State<CalendarTimeline>
    with SingleTickerProviderStateMixin {
  late DateTime _currentDate;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _currentDate = widget.selectedDate;

    final motion = AmbientMotionEngine.instance;

    _pulseController = AnimationController(
      vsync: this,
      duration: motion.adaptiveDuration,
    );
  }

  void _onDateTap(DateTime date) {
    setState(() => _currentDate = date);

    widget.onDateSelected(date);

    // 🔊 Soft calendar tap sound
    AmbientSoundEngine.instance.quickAction();

    // 🤍 Soft luxury haptic tap
    AmbientHapticsEngine.instance.softTap();

    // Animate pulse
    _pulseController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final motion = AmbientMotionEngine.instance;

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 30,
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          final isSelected = date.day == _currentDate.day &&
              date.month == _currentDate.month &&
              date.year == _currentDate.year;

          return GestureDetector(
            onTap: () => _onDateTap(date),
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = isSelected
                    ? Tween<double>(begin: 1.0, end: 1.08)
                        .chain(CurveTween(curve: motion.adaptiveCurve))
                        .evaluate(_pulseController)
                    : 1.0;

                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Container(
                width: 60,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.tealAccent.withOpacity(0.20)
                      : Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? Colors.tealAccent.withOpacity(0.40)
                        : Colors.white.withOpacity(0.10),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${date.day}",
                      style: TextStyle(
                        fontSize: 20,
                        color: isSelected ? Colors.tealAccent : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _weekday(date),
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? Colors.tealAccent.withOpacity(0.9)
                            : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _weekday(DateTime date) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return days[date.weekday - 1];
  }
}
