import 'package:flutter/foundation.dart';

import '../models/calendar_event.dart';

/// MonthViewEngine transforms raw calendar events into a
/// UI-friendly structure for the Month View screen.
///
/// It:
/// - Builds a 6x7 grid for the month
/// - Marks days with events
/// - Marks heavy / deep-work / recovery days
/// - Produces a clean month overview model
class MonthViewEngine {
  // Singleton
  static final MonthViewEngine instance = MonthViewEngine._internal();
  MonthViewEngine._internal();

  // -----------------------------
  // MAIN ENTRY
  // -----------------------------
  MonthViewModel buildMonthView({
    required int year,
    required int month,
    required List<CalendarEvent> events,
  }) {
    final firstDay = DateTime(year, month, 1);
    final firstWeekday = firstDay.weekday; // 1 = Monday, 7 = Sunday

    // Start grid on Monday
    final gridStart = firstDay.subtract(Duration(days: firstWeekday - 1));

    final days = <MonthDayModel>[];

    for (int i = 0; i < 42; i++) {
      final day = gridStart.add(Duration(days: i));

      final dayEvents = events.where((e) {
        return e.start.year == day.year &&
            e.start.month == day.month &&
            e.start.day == day.day;
      }).toList();

      days.add(
        MonthDayModel(
          date: day,
          isInMonth: day.month == month,
          events: dayEvents,
          isHeavyDay: _isHeavyDay(dayEvents),
          isDeepWorkDay: _isDeepWorkDay(dayEvents),
          isRecoveryDay: _isRecoveryDay(dayEvents),
        ),
      );
    }

    return MonthViewModel(
      year: year,
      month: month,
      days: days,
    );
  }

  // -----------------------------
  // HEAVY DAY DETECTION
  // -----------------------------
  bool _isHeavyDay(List<CalendarEvent> events) {
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
// MONTH VIEW MODEL
// -----------------------------
@immutable
class MonthViewModel {
  final int year;
  final int month;
  final List<MonthDayModel> days;

  const MonthViewModel({
    required this.year,
    required this.month,
    required this.days,
  });
}

// -----------------------------
// MONTH DAY MODEL
// -----------------------------
@immutable
class MonthDayModel {
  final DateTime date;
  final bool isInMonth;
  final List<CalendarEvent> events;

  final bool isHeavyDay;
  final bool isDeepWorkDay;
  final bool isRecoveryDay;

  const MonthDayModel({
    required this.date,
    required this.isInMonth,
    required this.events,
    required this.isHeavyDay,
    required this.isDeepWorkDay,
    required this.isRecoveryDay,
  });
}
