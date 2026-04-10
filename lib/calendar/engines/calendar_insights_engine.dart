import '../models/calendar_day_model.dart';
import '../models/calendar_week_model.dart';
import '../models/calendar_month_model.dart';
import 'calendar_analytics_engine.dart';

/// CalendarInsightsEngine converts analytics into
/// human-readable insights.
///
/// It generates:
/// - Daily insights
/// - Weekly insights
/// - Monthly insights
/// - Overload warnings
/// - Recovery recommendations
/// - Smart scheduling suggestions
///
/// This engine powers:
/// - Calendar Insights Dashboard
/// - Daily Briefing
/// - Weekly Summary
/// - Monthly Review
/// - Smart Scheduling
class CalendarInsightsEngine {
  // Singleton
  static final CalendarInsightsEngine instance =
      CalendarInsightsEngine._internal();
  CalendarInsightsEngine._internal();

  final _analytics = CalendarAnalyticsEngine.instance;

  // -----------------------------
  // DAILY INSIGHTS
  // -----------------------------
  String dailyInsight(CalendarDayModel day) {
    final data = _analytics.analyzeDay(day);

    final emotional = data["emotionalLoad"] as double;
    final fatigue = data["fatigueLoad"] as double;
    final busy = data["busyMinutes"] as int;

    if (day.isOverloaded) {
      return "This day is overloaded. Emotional and physical demands are high — consider reducing commitments.";
    }

    if (emotional > 7) {
      return "This day carries a high emotional load. Build in grounding moments.";
    }

    if (fatigue > 7) {
      return "This day may feel physically draining. Add recovery time where possible.";
    }

    if (busy > 8 * 60) {
      return "This is a high-density day with limited free space.";
    }

    if (day.isLightDay) {
      return "This is a light day with plenty of flexibility.";
    }

    return "This day has a balanced schedule with manageable demands.";
  }

  // -----------------------------
  // WEEKLY INSIGHTS
  // -----------------------------
  String weeklyInsight(CalendarWeekModel week) {
    final data = _analytics.analyzeWeek(week);

    final emotional = data["avgEmotionalLoad"] as double;
    final fatigue = data["avgFatigueLoad"] as double;
    final busy = data["totalBusyMinutes"] as int;

    if (week.isOverloaded) {
      return "This week is overloaded. Emotional and physical demands are elevated — consider pacing yourself.";
    }

    if (emotional > 7) {
      return "This week carries a high emotional load. Prioritize grounding and emotional recovery.";
    }

    if (fatigue > 7) {
      return "This week may feel physically draining. Build in rest windows.";
    }

    if (busy > 7 * 8 * 60) {
      return "This is a high-density week with limited free space.";
    }

    if (week.isLightWeek) {
      return "This is a light week with plenty of flexibility.";
    }

    return "This week has a balanced schedule with manageable demands.";
  }

  // -----------------------------
  // MONTHLY INSIGHTS
  // -----------------------------
  String monthlyInsight(CalendarMonthModel month) {
    final data = _analytics.analyzeMonth(month);

    final emotional = data["avgEmotionalLoad"] as double;
    final fatigue = data["avgFatigueLoad"] as double;
    final busy = data["totalBusyMinutes"] as int;

    if (month.isOverloaded) {
      return "This month is overloaded. Emotional and physical demands are elevated — consider reducing commitments.";
    }

    if (emotional > 7) {
      return "This month carries a high emotional load. Prioritize emotional recovery and grounding.";
    }

    if (fatigue > 7) {
      return "This month may feel physically draining. Build in rest and recovery.";
    }

    if (busy > month.days.length * 8 * 60) {
      return "This is a high-density month with limited free space.";
    }

    if (month.isLightMonth) {
      return "This is a light month with plenty of flexibility.";
    }

    return "This month has a balanced schedule with manageable demands.";
  }

  // -----------------------------
  // SMART SCHEDULING SUGGESTIONS
  // -----------------------------
  List<String> smartSchedulingSuggestions(CalendarWeekModel week) {
    final freeBlocks = _analytics.analyzeWeek(week)["freeTimeBlocks"]
        as List<Map<String, dynamic>>;

    final suggestions = <String>[];

    if (freeBlocks.isEmpty) {
      suggestions.add("This week has limited free time. Consider rescheduling non-essential events.");
      return suggestions;
    }

    // Suggest the largest free block
    final largest = freeBlocks.reduce((a, b) =>
        (a["minutes"] as int) > (b["minutes"] as int) ? a : b);

    suggestions.add(
        "Your best scheduling window is ${largest["minutes"]} minutes of free time on ${largest["start"]}.");

    // Suggest recovery days
    final recoveryDays = _analytics.analyzeWeek(week)["recoveryDays"]
        as List<CalendarDayModel>;

    if (recoveryDays.isNotEmpty) {
      suggestions.add(
          "You have recovery-friendly days this week — ideal for rest or low-demand tasks.");
    }

    return suggestions;
  }
}
