import 'package:flutter/foundation.dart';

import 'mode_calendar_signals.dart';
import 'mode_calendar_behavior_modifiers.dart';

/// ModeRecommendationEngine determines:
/// - The best mode for the user right now
/// - Secondary mode suggestions
/// - Mode priority ranking
///
/// It uses:
/// - Calendar signals (overload, emotional, fatigue)
/// - Behavioral modifiers (notification softening, energy protection)
///
/// This is the intelligence layer that powers:
/// - Auto Mode Switching
/// - Mode Suggestions
/// - Mode Boosts
class ModeRecommendationEngine {
  // Singleton
  static final ModeRecommendationEngine instance =
      ModeRecommendationEngine._internal();
  ModeRecommendationEngine._internal();

  final _signals = ModeCalendarSignals.instance;
  final _modifiers = ModeCalendarBehaviorModifiers.instance;

  // -----------------------------
  // RECOMMEND MODE FOR THE DAY
  // -----------------------------
  ModeRecommendation recommendForDay(DateTime date) {
    final s = _signals.getDailySignals(date);
    final m = _modifiers.getDailyModifiers(date);

    // Priority logic
    if (m.activateOverloadProtection) {
      return ModeRecommendation(
        primaryMode: "overload_protection",
        secondaryModes: ["recovery", "calm"],
        reason: "High overload or no free time detected.",
        insight: s.insight,
      );
    }

    if (m.boostRecoveryMode) {
      return ModeRecommendation(
        primaryMode: "recovery",
        secondaryModes: ["calm", "night_goddess"],
        reason: "High emotional or fatigue load detected.",
        insight: s.insight,
      );
    }

    if (m.boostFocusMode) {
      return ModeRecommendation(
        primaryMode: "focus",
        secondaryModes: ["calm", "deep_work"],
        reason: "Deep-work windows available.",
        insight: s.insight,
      );
    }

    // Light day → Calm Mode
    if (s.signals.contains("light_day")) {
      return ModeRecommendation(
        primaryMode: "calm",
        secondaryModes: ["focus", "recovery"],
        reason: "Light day with balanced emotional/fatigue load.",
        insight: s.insight,
      );
    }

    // Default
    return ModeRecommendation(
      primaryMode: "balanced",
      secondaryModes: ["focus", "calm"],
      reason: "No strong signals detected.",
      insight: s.insight,
    );
  }

  // -----------------------------
  // RECOMMEND MODE FOR THE WEEK
  // -----------------------------
  ModeRecommendation recommendForWeek(DateTime weekStart) {
    final s = _signals.getWeeklySignals(weekStart);

    if (s.signals.contains("week_overloaded")) {
      return ModeRecommendation(
        primaryMode: "overload_protection",
        secondaryModes: ["recovery", "calm"],
        reason: "High weekly overload detected.",
        insight: s.insight,
      );
    }

    if (s.signals.contains("week_emotional_heavy")) {
      return ModeRecommendation(
        primaryMode: "recovery",
        secondaryModes: ["calm", "night_goddess"],
        reason: "High emotional load across the week.",
        insight: s.insight,
      );
    }

    if (s.signals.contains("week_deep_work_available")) {
      return ModeRecommendation(
        primaryMode: "focus",
        secondaryModes: ["deep_work", "calm"],
        reason: "Multiple deep-work windows available.",
        insight: s.insight,
      );
    }

    return ModeRecommendation(
      primaryMode: "balanced",
      secondaryModes: ["focus", "calm"],
      reason: "No strong weekly signals detected.",
      insight: s.insight,
    );
  }

  // -----------------------------
  // RECOMMEND MODE FOR THE MONTH
  // -----------------------------
  ModeRecommendation recommendForMonth(int year, int month) {
    final s = _signals.getMonthlySignals(year, month);

    if (s.signals.contains("month_overloaded")) {
      return ModeRecommendation(
        primaryMode: "overload_protection",
        secondaryModes: ["recovery", "calm"],
        reason: "High monthly overload detected.",
        insight: s.insight,
      );
    }

    if (s.signals.contains("month_emotional_heavy")) {
      return ModeRecommendation(
        primaryMode: "recovery",
        secondaryModes: ["calm", "night_goddess"],
        reason: "High emotional load across the month.",
        insight: s.insight,
      );
    }

    return ModeRecommendation(
      primaryMode: "balanced",
      secondaryModes: ["focus", "calm"],
      reason: "No strong monthly signals detected.",
      insight: s.insight,
    );
  }
}

// -----------------------------
// DATA CLASS
// -----------------------------
@immutable
class ModeRecommendation {
  final String primaryMode;
  final List<String> secondaryModes;
  final String reason;
  final String insight;

  const ModeRecommendation({
    required this.primaryMode,
    required this.secondaryModes,
    required this.reason,
    required this.insight,
  });
}
