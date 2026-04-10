import '../models/calendar_month_model.dart';
import '../models/calendar_week_model.dart';
import '../models/calendar_day_model.dart';
import '../models/calendar_event_model.dart';
import 'calendar_week_builder_engine.dart';
import 'calendar_day_builder_engine.dart';

/// CalendarMonthBuilderEngine constructs CalendarMonthModels from:
/// - Parsed events
/// - Week builder
/// - Day builder
/// - Monthly analytics
/// - Emotional + fatigue heatmaps
/// - Overload detection
/// - AI insights
///
/// This engine powers:
/// - Month View
/// - Heatmaps
/// - Calendar analytics
/// - Smart scheduling
class CalendarMonthBuilderEngine {
  // Singleton
  static final CalendarMonthBuilderEngine instance =
      CalendarMonthBuilderEngine._internal();
  CalendarMonthBuilderEngine._internal();

  final _weekBuilder = CalendarWeekBuilderEngine.instance;
  final _dayBuilder = CalendarDayBuilderEngine.instance;

  // -----------------------------
  // BUILD A FULL MONTH
  // -----------------------------
  CalendarMonthModel buildMonth({
    required int year,
    required int month,
    required List<CalendarEventModel> allEvents,
  }) {
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);

    // Determine the first Monday (or user preference) to start the grid
    final gridStart = _firstGridDay(firstDay);
    final gridEnd = _lastGridDay(lastDay);

    // Build all days in the grid
    final List<CalendarDayModel> allDays = [];
    DateTime cursor = gridStart;

    while (!cursor.isAfter(gridEnd)) {
      final day = _dayBuilder.buildDay(
        date: cursor,
        allEvents: allEvents,
      );
      allDays.add(day);
      cursor = cursor.add(const Duration(days: 1));
    }

    // Build weeks (groups of 7 days)
    final List<CalendarWeekModel> weeks = [];
    for (int i = 0; i < allDays.length; i += 7) {
      final weekDays = allDays.sublist(i, i + 7);
      final week = CalendarWeekModel(
        weekStart: weekDays.first.date,
        days: weekDays,
        totalBusyMinutes: weekDays.fold(0, (s, d) => s + d.totalBusyMinutes),
        avgEmotionalLoad:
            weekDays.fold(0.0, (s, d) => s + d.emotionalLoad) / 7.0,
        avgFatigueLoad:
            weekDays.fold(0.0, (s, d) => s + d.fatigueLoad) / 7.0,
        isOverloaded: (weekDays.fold(0.0, (s, d) => s + d.emotionalLoad) / 7.0 +
                weekDays.fold(0.0, (s, d) => s + d.fatigueLoad) / 7.0) >
            14,
        isHighDensity: weekDays.fold(0, (s, d) => s + d.totalBusyMinutes) >
            (7 * 8 * 60),
        isLightWeek: weekDays.fold(0, (s, d) => s + d.totalBusyMinutes) <
            (7 * 2 * 60),
        aiInsight: null,
      );
      weeks.add(week);
    }

    // Filter only the days that belong to the actual month
    final monthDays = allDays
        .where((d) =>
            d.date.month == month && d.date.year == year)
        .toList();

    final totalEvents =
        monthDays.fold(0, (s, d) => s + d.events.length);
    final totalBusy =
        monthDays.fold(0, (s, d) => s + d.totalBusyMinutes);
    final avgEmotional =
        monthDays.fold(0.0, (s, d) => s + d.emotionalLoad) /
            monthDays.length;
    final avgFatigue =
        monthDays.fold(0.0, (s, d) => s + d.fatigueLoad) /
            monthDays.length;

    final isOverloaded = (avgEmotional + avgFatigue) > 14;
    final isHighDensity = totalBusy > (monthDays.length * 8 * 60);
    final isLightMonth = totalBusy < (monthDays.length * 2 * 60);

    return CalendarMonthModel(
      year: year,
      month: month,
      weeks: weeks,
      days: monthDays,
      totalEvents: totalEvents,
      totalBusyMinutes: totalBusy,
      avgEmotionalLoad: avgEmotional.clamp(0, 10),
      avgFatigueLoad: avgFatigue.clamp(0, 10),
      isOverloaded: isOverloaded,
      isHighDensity: isHighDensity,
      isLightMonth: isLightMonth,
      aiInsight: _generateAIInsight(
        avgEmotional: avgEmotional,
        avgFatigue: avgFatigue,
        totalBusy: totalBusy,
      ),
    );
  }

  // -----------------------------
  // GRID START (FIRST MONDAY)
  // -----------------------------
  DateTime _firstGridDay(DateTime firstDay) {
    int weekday = firstDay.weekday; // Monday = 1
    return firstDay.subtract(Duration(days: weekday - 1));
  }

  // -----------------------------
  // GRID END (LAST SUNDAY)
  // -----------------------------
  DateTime _lastGridDay(DateTime lastDay) {
    int weekday = lastDay.weekday; // Sunday = 7
    return lastDay.add(Duration(days: 7 - weekday));
  }

  // -----------------------------
  // AI INSIGHT (MONTH SUMMARY)
  // -----------------------------
  String? _generateAIInsight({
    required double avgEmotional,
    required double avgFatigue,
    required int totalBusy,
  }) {
    if (totalBusy < 30 * 2 * 60) {
      return "This is a light month with plenty of flexibility.";
    }

    if (avgEmotional > 7) {
      return "This month carries a high emotional load. Consider pacing yourself.";
    }

    if (avgFatigue > 7) {
      return "This month may feel physically draining. Build in recovery time.";
    }

    if (totalBusy > 30 * 8 * 60) {
      return "This is a high-density month with limited free space.";
    }

    return "This month has a balanced schedule with manageable demands.";
  }
}
