import '../models/calendar_week_model.dart';
import '../models/calendar_day_model.dart';
import '../models/calendar_event_model.dart';
import 'calendar_day_builder_engine.dart';

/// CalendarWeekBuilderEngine constructs CalendarWeekModels from:
/// - A week start date
/// - Parsed events
/// - Day models
/// - Weekly analytics
/// - Emotional/fatigue averages
/// - Overload detection
/// - AI insights
///
/// This engine powers:
/// - Week View
/// - Weekly summaries
/// - Smart scheduling
/// - Calendar analytics
class CalendarWeekBuilderEngine {
  // Singleton
  static final CalendarWeekBuilderEngine instance =
      CalendarWeekBuilderEngine._internal();
  CalendarWeekBuilderEngine._internal();

  final _dayBuilder = CalendarDayBuilderEngine.instance;

  // -----------------------------
  // BUILD A FULL WEEK
  // -----------------------------
  CalendarWeekModel buildWeek({
    required DateTime weekStart,
    required List<CalendarEventModel> allEvents,
  }) {
    // Normalize weekStart to Monday (or user preference)
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day);

    final List<CalendarDayModel> days = [];

    for (int i = 0; i < 7; i++) {
      final date = start.add(Duration(days: i));
      final day = _dayBuilder.buildDay(
        date: date,
        allEvents: allEvents,
      );
      days.add(day);
    }

    final totalBusy = days.fold(0, (sum, d) => sum + d.totalBusyMinutes);
    final avgEmotional =
        days.fold(0.0, (sum, d) => sum + d.emotionalLoad) / 7.0;
    final avgFatigue =
        days.fold(0.0, (sum, d) => sum + d.fatigueLoad) / 7.0;

    final isOverloaded = (avgEmotional + avgFatigue) > 14;
    final isHighDensity = totalBusy > (7 * 8 * 60); // more than 8h/day avg
    final isLightWeek = totalBusy < (7 * 2 * 60); // less than 2h/day avg

    return CalendarWeekModel(
      weekStart: start,
      days: days,
      totalBusyMinutes: totalBusy,
      avgEmotionalLoad: avgEmotional.clamp(0, 10),
      avgFatigueLoad: avgFatigue.clamp(0, 10),
      isOverloaded: isOverloaded,
      isHighDensity: isHighDensity,
      isLightWeek: isLightWeek,
      aiInsight: _generateAIInsight(
        avgEmotional: avgEmotional,
        avgFatigue: avgFatigue,
        totalBusy: totalBusy,
      ),
    );
  }

  // -----------------------------
  // AI INSIGHT (WEEK SUMMARY)
  // -----------------------------
  String? _generateAIInsight({
    required double avgEmotional,
    required double avgFatigue,
    required int totalBusy,
  }) {
    if (totalBusy < 7 * 2 * 60) {
      return "This is a light week with plenty of flexibility.";
    }

    if (avgEmotional > 7) {
      return "This week carries a high emotional load. Consider pacing yourself.";
    }

    if (avgFatigue > 7) {
      return "This week may feel physically draining. Build in recovery time.";
    }

    if (totalBusy > 7 * 8 * 60) {
      return "This is a high-density week with limited free space.";
    }

    return "This week has a balanced schedule with manageable demands.";
  }
}
