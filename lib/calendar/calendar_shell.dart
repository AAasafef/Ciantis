import 'package:flutter/material.dart';

import 'navigation/calendar_nav_bar.dart';
import 'dayview/day_view_widget.dart';
import 'weekview/week_view_widget.dart';
import 'monthview/month_view_widget.dart';
import 'calendar_facade.dart';

/// CalendarShell is the top-level container for the entire calendar system.
///
/// It includes:
/// - Navigation bar (Day / Week / Month)
/// - The active view
/// - Smooth transitions
/// - Event loading from CalendarFacade
class CalendarShell extends StatefulWidget {
  const CalendarShell({super.key});

  @override
  State<CalendarShell> createState() => _CalendarShellState();
}

class _CalendarShellState extends State<CalendarShell> {
  CalendarNavSelection _selection = CalendarNavSelection.month;

  @override
  Widget build(BuildContext context) {
    final events = CalendarFacade.instance.events;

    final now = DateTime.now();
    final weekStart =
        now.subtract(Duration(days: now.weekday - 1)); // Monday start

    return Column(
      children: [
        // -----------------------------
        // NAVIGATION BAR
        // -----------------------------
        Padding(
          padding: const EdgeInsets.all(16),
          child: CalendarNavBar(
            selection: _selection,
            onChanged: (s) {
              setState(() => _selection = s);
            },
          ),
        ),

        const SizedBox(height: 10),

        // -----------------------------
        // ACTIVE VIEW
        // -----------------------------
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _buildActiveView(
              selection: _selection,
              events: events,
              now: now,
              weekStart: weekStart,
            ),
          ),
        ),
      ],
    );
  }

  // -----------------------------
  // ACTIVE VIEW BUILDER
  // -----------------------------
  Widget _buildActiveView({
    required CalendarNavSelection selection,
    required List events,
    required DateTime now,
    required DateTime weekStart,
  }) {
    switch (selection) {
      case CalendarNavSelection.day:
        return DayViewWidget(
          key: const ValueKey("day"),
          day: now,
          events: events,
        );

      case CalendarNavSelection.week:
        return WeekViewWidget(
          key: const ValueKey("week"),
          weekStart: weekStart,
          events: events,
        );

      case CalendarNavSelection.month:
      default:
        return MonthViewWidget(
          key: const ValueKey("month"),
          year: now.year,
          month: now.month,
          events: events,
        );
    }
  }
}
