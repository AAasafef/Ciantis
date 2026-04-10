import '../models/calendar_day_model.dart';
import '../models/calendar_week_model.dart';
import '../models/calendar_month_model.dart';

/// CalendarAnalyticsEngine computes:
/// - Busy score
/// - Emotional heatmaps
/// - Fatigue heatmaps
/// - Overload detection
/// - Free-time windows
/// - Scheduling windows
/// - Day/Week/Month summaries
///
/// This engine powers:
/// - Month View heatmaps
/// - Week View summaries
/// - Smart Scheduling Engine
/// - Calendar Insights Dashboard
class CalendarAnalyticsEngine {
  // Singleton
  static final CalendarAnalyticsEngine instance =
      CalendarAnalyticsEngine._internal();
  CalendarAnalyticsEngine._internal();

  // -----------------------------
  // DAILY ANALYTICS
  // -----------------------------
  Map<String, dynamic> analyzeDay(CalendarDayModel day) {
    return {
      "date": day.date,
      "busyMinutes": day.totalBusyMinutes,
      "emotionalLoad": day.emotionalLoad,
      "fatigueLoad": day.fatigueLoad,
      "isOverloaded": day.isOverloaded,
      "isHighDensity": day.isHighDensity,
      "isLightDay": day.isLightDay,
      "freeTimeBlocks": _freeTimeBlocks(day),
    };
  }

  // -----------------------------
  // WEEKLY ANALYTICS
  // -----------------------------
  Map<String, dynamic> analyzeWeek(CalendarWeekModel week) {
    final totalBusy = week.totalBusyMinutes;
    final avgEmotional = week.avgEmotionalLoad;
    final avgFatigue = week.avgFatigueLoad;

    return {
      "weekStart": week.weekStart,
      "weekEnd": week.weekEnd,
      "totalBusyMinutes": totalBusy,
      "avgEmotionalLoad": avgEmotional,
      "avgFatigueLoad": avgFatigue,
      "isOverloaded": week.isOverloaded,
      "isHighDensity": week.isHighDensity,
      "isLightWeek": week.isLightWeek,
      "freeTimeBlocks": _freeTimeBlocksWeek(week),
      "peakStressDays": _peakStressDays(week),
      "recoveryDays": _recoveryDays(week),
    };
  }

  // -----------------------------
  // MONTHLY ANALYTICS
  // -----------------------------
  Map<String, dynamic> analyzeMonth(CalendarMonthModel month) {
    final totalBusy = month.totalBusyMinutes;
    final avgEmotional = month.avgEmotionalLoad;
    final avgFatigue = month.avgFatigueLoad;

    return {
      "year": month.year,
      "month": month.month,
      "totalEvents": month.totalEvents,
      "totalBusyMinutes": totalBusy,
      "avgEmotionalLoad": avgEmotional,
      "avgFatigueLoad": avgFatigue,
      "isOverloaded": month.isOverloaded,
      "isHighDensity": month.isHighDensity,
      "isLightMonth": month.isLightMonth,
      "heatmap": _buildHeatmap(month),
      "peakStressWeeks": _peakStressWeeks(month),
      "recoveryWeeks": _recoveryWeeks(month),
    };
  }

  // -----------------------------
  // FREE TIME BLOCKS (DAY)
  // -----------------------------
  List<Map<String, dynamic>> _freeTimeBlocks(CalendarDayModel day) {
    if (day.events.isEmpty) {
      return [
        {
          "start": DateTime(day.date.year, day.date.month, day.date.day, 0, 0),
          "end": DateTime(day.date.year, day.date.month, day.date.day, 23, 59),
          "minutes": 24 * 60,
        }
      ];
    }

    final sorted = [...day.events]..sort((a, b) => a.start.compareTo(b.start));

    final List<Map<String, dynamic>> blocks = [];

    // Before first event
    final first = sorted.first;
    final dayStart = DateTime(day.date.year, day.date.month, day.date.day, 0, 0);
    if (first.start.isAfter(dayStart)) {
      blocks.add({
        "start": dayStart,
        "end": first.start,
        "minutes": first.start.difference(dayStart).inMinutes,
      });
    }

    // Between events
    for (int i = 0; i < sorted.length - 1; i++) {
      final current = sorted[i];
      final next = sorted[i + 1];

      if (next.start.isAfter(current.end)) {
        blocks.add({
          "start": current.end,
          "end": next.start,
          "minutes": next.start.difference(current.end).inMinutes,
        });
      }
    }

    // After last event
    final last = sorted.last;
    final dayEnd = DateTime(day.date.year, day.date.month, day.date.day, 23, 59);
    if (last.end.isBefore(dayEnd)) {
      blocks.add({
        "start": last.end,
        "end": dayEnd,
        "minutes": dayEnd.difference(last.end).inMinutes,
      });
    }

    return blocks;
  }

  // -----------------------------
  // FREE TIME BLOCKS (WEEK)
  // -----------------------------
  List<Map<String, dynamic>> _freeTimeBlocksWeek(CalendarWeekModel week) {
    final List<Map<String, dynamic>> blocks = [];

    for (final day in week.days) {
      blocks.addAll(_freeTimeBlocks(day));
    }

    return blocks;
  }

  // -----------------------------
  // PEAK STRESS DAYS
  // -----------------------------
  List<CalendarDayModel> _peakStressDays(CalendarWeekModel week) {
    return week.days
        .where((d) => d.emotionalLoad + d.fatigueLoad > 14)
        .toList();
  }

  // -----------------------------
  // RECOVERY DAYS
  // -----------------------------
  List<CalendarDayModel> _recoveryDays(CalendarWeekModel week) {
    return week.days
        .where((d) => d.totalBusyMinutes < 2 * 60)
        .toList();
  }

  // -----------------------------
  // HEATMAP (MONTH)
  // -----------------------------
  Map<DateTime, Map<String, double>> _buildHeatmap(
      CalendarMonthModel month) {
    final Map<DateTime, Map<String, double>> map = {};

    for (final day in month.days) {
      map[day.date] = {
        "emotional": day.emotionalLoad,
        "fatigue": day.fatigueLoad,
        "busy": day.totalBusyMinutes.toDouble(),
      };
    }

    return map;
  }

  // -----------------------------
  // PEAK STRESS WEEKS (MONTH)
  // -----------------------------
  List<CalendarWeekModel> _peakStressWeeks(CalendarMonthModel month) {
    return month.weeks
        .where((w) => w.avgEmotionalLoad + w.avgFatigueLoad > 14)
        .toList();
  }

  // -----------------------------
  // RECOVERY WEEKS (MONTH)
  // -----------------------------
  List<CalendarWeekModel> _recoveryWeeks(CalendarMonthModel month) {
    return month.weeks
        .where((w) => w.totalBusyMinutes < (7 * 2 * 60))
        .toList();
  }
}
