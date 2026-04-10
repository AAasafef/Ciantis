import 'package:flutter/foundation.dart';

import 'mode_calendar_signals.dart';

/// ModeCalendarBehaviorModifiers converts calendar signals into:
/// - Notification behavior changes
/// - UI tone adjustments
/// - Energy protection rules
/// - Mode boosts (Focus, Recovery, Night Goddess, Overload Protection)
///
/// This is where the Mode Engine *acts* on the user's schedule.
class ModeCalendarBehaviorModifiers {
  // Singleton
  static final ModeCalendarBehaviorModifiers instance =
      ModeCalendarBehaviorModifiers._internal();
  ModeCalendarBehaviorModifiers._internal();

  final _signals = ModeCalendarSignals.instance;

  // -----------------------------
  // DAILY MODIFIERS
  // -----------------------------
  ModeBehaviorModifiers getDailyModifiers(DateTime date) {
    final s = _signals.getDailySignals(date);

    bool softenNotifications = false;
    bool reduceInterruptions = false;
    bool boostFocusMode = false;
    bool boostRecoveryMode = false;
    bool activateOverloadProtection = false;

    // Overload
    if (s.signals.contains("overload")) {
      softenNotifications = true;
      reduceInterruptions = true;
      activateOverloadProtection = true;
    }

    // Emotional heavy
    if (s.signals.contains("emotional_heavy")) {
      softenNotifications = true;
      boostRecoveryMode = true;
    }

    // Fatigue heavy
    if (s.signals.contains("fatigue_heavy")) {
      reduceInterruptions = true;
      boostRecoveryMode = true;
    }

    // Deep work
    if (s.signals.contains("deep_work_available")) {
      boostFocusMode = true;
    }

    // No free time
    if (s.signals.contains("no_free_time")) {
      reduceInterruptions = true;
      activateOverloadProtection = true;
    }

    return ModeBehaviorModifiers(
      softenNotifications: softenNotifications,
      reduceInterruptions: reduceInterruptions,
      boostFocusMode: boostFocusMode,
      boostRecoveryMode: boostRecoveryMode,
      activateOverloadProtection: activateOverloadProtection,
      recommendations: s.recommendations,
      insight: s.insight,
    );
  }

  // -----------------------------
  // WEEKLY MODIFIERS
  // -----------------------------
  ModeBehaviorModifiers getWeeklyModifiers(DateTime weekStart) {
    final s = _signals.getWeeklySignals(weekStart);

    bool softenNotifications = false;
    bool reduceInterruptions = false;
    bool boostFocusMode = false;
    bool boostRecoveryMode = false;
    bool activateOverloadProtection = false;

    if (s.signals.contains("week_overloaded")) {
      softenNotifications = true;
      reduceInterruptions = true;
      activateOverloadProtection = true;
    }

    if (s.signals.contains("week_emotional_heavy")) {
      softenNotifications = true;
      boostRecoveryMode = true;
    }

    if (s.signals.contains("week_fatigue_heavy")) {
      reduceInterruptions = true;
      boostRecoveryMode = true;
    }

    if (s.signals.contains("week_deep_work_available")) {
      boostFocusMode = true;
    }

    return ModeBehaviorModifiers(
      softenNotifications: softenNotifications,
      reduceInterruptions: reduceInterruptions,
      boostFocusMode: boostFocusMode,
      boostRecoveryMode: boostRecoveryMode,
      activateOverloadProtection: activateOverloadProtection,
      recommendations: s.recommendations,
      insight: s.insight,
    );
  }

  // -----------------------------
  // MONTHLY MODIFIERS
  // -----------------------------
  ModeBehaviorModifiers getMonthlyModifiers(int year, int month) {
    final s = _signals.getMonthlySignals(year, month);

    bool softenNotifications = false;
    bool reduceInterruptions = false;
    bool boostRecoveryMode = false;
    bool activateOverloadProtection = false;

    if (s.signals.contains("month_overloaded")) {
      softenNotifications = true;
      reduceInterruptions = true;
      activateOverloadProtection = true;
    }

    if (s.signals.contains("month_emotional_heavy")) {
      softenNotifications = true;
      boostRecoveryMode = true;
    }

    if (s.signals.contains("month_fatigue_heavy")) {
      reduceInterruptions = true;
      boostRecoveryMode = true;
    }

    return ModeBehaviorModifiers(
      softenNotifications: softenNotifications,
      reduceInterruptions: reduceInterruptions,
      boostFocusMode: false,
      boostRecoveryMode: boostRecoveryMode,
      activateOverloadProtection: activateOverloadProtection,
      recommendations: s.recommendations,
      insight: s.insight,
    );
  }
}

// -----------------------------
// DATA CLASS
// -----------------------------
@immutable
class ModeBehaviorModifiers {
  final bool softenNotifications;
  final bool reduceInterruptions;
  final bool boostFocusMode;
  final bool boostRecoveryMode;
  final bool activateOverloadProtection;

  final List<String> recommendations;
  final String insight;

  const ModeBehaviorModifiers({
    required this.softenNotifications,
    required this.reduceInterruptions,
    required this.boostFocusMode,
    required this.boostRecoveryMode,
    required this.activateOverloadProtection,
    required this.recommendations,
    required this.insight,
  });
}
