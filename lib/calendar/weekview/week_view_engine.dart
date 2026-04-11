import 'package:flutter/foundation.dart';

import '../models/calendar_event.dart';

/// WeekViewEngine transforms raw calendar events into a
/// UI-friendly structure for the Week View screen.
///
/// It:
/// - Groups events by day
/// - Sorts events within each day
/// - Marks heavy / deep-work / recovery days
/// - Produces a clean weekly overview model
class WeekViewEngine {
  // Singleton
  static final WeekViewEngine instance = WeekViewEngine._internal();
  WeekViewEngine._internal();

  // -----------------------------
  // MAIN ENTRY
  // -----------------------------
  WeekViewModel buildWeekView({
    required DateTime weekStart,
    required List<CalendarEvent> events,
  }) {
    final days = <WeekDayModel>[];

    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));

      final dayEvents = events.where((e) {
        return e.start.year == day.year &&
            e.start.month == day.month &&
            e.start.day == day.day;
      }).toList()
        ..sort((a, b) => a.start.compareTo(b.start));

      days.add(
        WeekDayModel(
          date: day,
          events: dayEvents,
          isHeavyDay: _isHeavyDay(dayEvents),
          isDeepWorkDay: _isDeepWorkDay(dayEvents),
          isRecoveryDay: _isRecoveryDay(dayEvents),
        ),
      );
    }

    return WeekViewModel(
      weekStart: weekStart,
      days: days,
    );
  }

  // -----------------------------
  // HEAVY DAY DETECTION
  // -----------------------------
  bool _isHeavyDay(List<CalendarEvent> events) {
    // Heavy if 4+ events or any heavy block
    if (events.length >= 4) return true;
    return events.any((e) => e.isEnergyHeavy);
  }

  // -----------------------------
  // DEEP WORK DAY DETECTION
  // -----------------------------
  bool _isDeepWorkDay(List<CalendarEvent> events) {
    return events.any((e) => e.type == CalendarEventType.deepWork);
  }

  // -----------------------------
  // RECOVERY DAY DETECTION
  // -----------------------------
  bool _isRecoveryDay(List<CalendarEvent> events) {
    return events.any((e) => e.type == CalendarEventType.recovery);
  }
}

// -----------------------------
// WEEK VIEW MODEL
// -----------------------------
@immutable
class WeekViewModel {
  final DateTime weekStart;
  final List<WeekDayModel> days;

  const WeekViewModel({
    required this.weekStart,
    required this.days,
  });
}

// -----------------------------
// WEEK DAY MODEL
// -----------------------------
@immutable
class WeekDayModel {
  final DateTime date;
  final List<CalendarEvent> events;

  final bool isHeavyDay;
  final bool isDeepWorkDay;
  final bool isRecoveryDay;

  const WeekDayModel({
    required this.date,
    required this.events,
    required this.isHeavyDay,
    required this.isDeepWorkDay,
    required this.isRecoveryDay,
  });
}
