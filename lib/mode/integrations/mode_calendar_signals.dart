import 'package:flutter/foundation.dart';

import 'mode_calendar_facade.dart';

/// ModeCalendarSignals analyzes calendar context and produces:
/// - Mode signals
/// - Recommendations
/// - Behavioral modifiers
///
/// This is where the Mode Engine learns how to adapt itself
/// based on the user's real schedule.
class ModeCalendarSignals {
  // Singleton
  static final ModeCalendarSignals instance =
      ModeCalendarSignals._internal();
  ModeCalendarSignals._internal();

  final _facade = ModeCalendarFacade.instance;

  // -----------------------------
  // DAILY SIGNALS
  // -----------------------------
  ModeCalendarDailySignals getDailySignals(DateTime date) {
    final ctx = _facade.getDayContext(date);

    final signals = <String>[];
    final recommendations = <String>[];

    // Overload
    if (ctx.isOverloaded) {
      signals.add("overload");
      recommendations.add("Reduce cognitive load and soften notifications.");
    }

    // Emotional load
    if (ctx.emotionalLoad > 7) {
      signals.add("emotional_heavy");
      recommendations.add("Encourage grounding and emotional recovery.");
    }

    // Fatigue load
    if (ctx.fatigueLoad > 7) {
      signals.add("fatigue_heavy");
      recommendations.add("Promote rest and minimize demanding tasks.");
    }

    // Deep work
    if (ctx.deepWorkWindows.isNotEmpty) {
      signals.add("deep_work_available");
      recommendations.add("Suggest Focus Mode during deep-work windows.");
    }

    // Recovery
    if (ctx.recoveryWindows.isNotEmpty) {
      signals.add("recovery_available");
      recommendations.add("Suggest Recovery Mode or gentle routines.");
    }

    // No free time
    if (ctx.freeBlocks.isEmpty) {
      signals.add("no_free_time");
      recommendations.add("Protect energy and reduce interruptions.");
    }

    return ModeCalendarDailySignals(
      date: date,
      signals: signals,
      recommendations: recommendations,
      insight: ctx.insight,
    );
  }

  // -----------------------------
  // WEEKLY SIGNALS
  // -----------------------------
  ModeCalendarWeeklySignals getWeeklySignals(DateTime weekStart) {
    final ctx = _facade.getWeekContext(weekStart);

    final signals = <String>[];
    final recommendations = <String>[];

    if (ctx.isOverloaded) {
      signals.add("week_overloaded");
      recommendations.add("Encourage pacing and energy conservation.");
    }

    if (ctx.avgEmotionalLoad > 7) {
      signals.add("week_emotional_heavy");
      recommendations.add("Promote grounding and emotional balance.");
    }

    if (ctx.avgFatigueLoad > 7) {
      signals.add("week_fatigue_heavy");
      recommendations.add("Encourage rest and avoid overcommitment.");
    }

    if (ctx.deepWorkWindows.isNotEmpty) {
      signals.add("week_deep_work_available");
      recommendations.add("Highlight deep-work opportunities.");
    }

    if (ctx.recoveryWindows.isNotEmpty) {
      signals.add("week_recovery_available");
      recommendations.add("Recommend recovery-focused routines.");
    }

    return ModeCalendarWeeklySignals(
      weekStart: ctx.weekStart,
      weekEnd: ctx.weekEnd,
      signals: signals,
      recommendations: recommendations,
      insight: ctx.insight,
    );
  }

  // -----------------------------
  // MONTHLY SIGNALS
  // -----------------------------
  ModeCalendarMonthlySignals getMonthlySignals(int year, int month) {
    final ctx = _facade.getMonthContext(year, month);

    final signals = <String>[];
    final recommendations = <String>[];

    if (ctx.isOverloaded) {
      signals.add("month_overloaded");
      recommendations.add("Encourage long-term pacing and energy protection.");
    }

    if (ctx.avgEmotionalLoad > 7) {
      signals.add("month_emotional_heavy");
      recommendations.add("Promote emotional resilience routines.");
    }

    if (ctx.avgFatigueLoad > 7) {
      signals.add("month_fatigue_heavy");
      recommendations.add("Recommend rest cycles and lighter commitments.");
    }

    return ModeCalendarMonthlySignals(
      year: year,
      month: month,
      signals: signals,
      recommendations: recommendations,
      insight: ctx.insight,
    );
  }
}

// -----------------------------
// SIGNAL DATA CLASSES
// -----------------------------
@immutable
class ModeCalendarDailySignals {
  final DateTime date;
  final List<String> signals;
  final List<String> recommendations;
  final String insight;

  const ModeCalendarDailySignals({
    required this.date,
    required this.signals,
    required this.recommendations,
    required this.insight,
  });
}

@immutable
class ModeCalendarWeeklySignals {
  final DateTime weekStart;
  final DateTime weekEnd;
  final List<String> signals;
  final List<String> recommendations;
  final String insight;

  const ModeCalendarWeeklySignals({
    required this.weekStart,
    required this.weekEnd,
    required this.signals,
    required this.recommendations,
    required this.insight,
  });
}

@immutable
class ModeCalendarMonthlySignals {
  final int year;
  final int month;
  final List<String> signals;
  final List<String> recommendations;
  final String insight;

  const ModeCalendarMonthlySignals({
    required this.year,
    required this.month,
    required this.signals,
    required this.recommendations,
    required this.insight,
  });
}
