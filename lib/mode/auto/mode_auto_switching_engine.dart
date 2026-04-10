import 'package:flutter/foundation.dart';

import '../integrations/mode_recommendation_engine.dart';
import '../integrations/mode_calendar_behavior_modifiers.dart';

/// ModeAutoSwitchingEngine automatically selects the best mode
/// based on:
/// - Calendar signals
/// - Behavioral modifiers
/// - Time of day
/// - Deep-work windows
/// - Recovery windows
/// - Overload patterns
///
/// This is the intelligence layer that powers:
/// - Auto Mode Switching
/// - Passive Mode Adjustments
/// - Real-time Mode Adaptation
class ModeAutoSwitchingEngine {
  // Singleton
  static final ModeAutoSwitchingEngine instance =
      ModeAutoSwitchingEngine._internal();
  ModeAutoSwitchingEngine._internal();

  final _recommend = ModeRecommendationEngine.instance;
  final _modifiers = ModeCalendarBehaviorModifiers.instance;

  String? _currentMode;

  String? get currentMode => _currentMode;

  // -----------------------------
  // AUTO SWITCH FOR THE DAY
  // -----------------------------
  String autoSwitchForDay(DateTime date) {
    final rec = _recommend.recommendForDay(date);
    _currentMode = rec.primaryMode;
    return _currentMode!;
  }

  // -----------------------------
  // AUTO SWITCH FOR THE WEEK
  // -----------------------------
  String autoSwitchForWeek(DateTime weekStart) {
    final rec = _recommend.recommendForWeek(weekStart);
    _currentMode = rec.primaryMode;
    return _currentMode!;
  }

  // -----------------------------
  // AUTO SWITCH FOR THE MONTH
  // -----------------------------
  String autoSwitchForMonth(int year, int month) {
    final rec = _recommend.recommendForMonth(year, month);
    _currentMode = rec.primaryMode;
    return _currentMode!;
  }

  // -----------------------------
  // REAL-TIME ADAPTATION
  // (e.g., during the day)
  // -----------------------------
  String adaptInRealTime({
    required DateTime now,
    required bool isInDeepWorkWindow,
    required bool isInRecoveryWindow,
  }) {
    final m = _modifiers.getDailyModifiers(now);

    // Overload → immediate protection
    if (m.activateOverloadProtection) {
      _currentMode = "overload_protection";
      return _currentMode!;
    }

    // Deep work window → Focus Mode
    if (isInDeepWorkWindow) {
      _currentMode = "focus";
      return _currentMode!;
    }

    // Recovery window → Recovery Mode
    if (isInRecoveryWindow) {
      _currentMode = "recovery";
      return _currentMode!;
    }

    // Evening → Night Goddess Mode
    if (now.hour >= 20) {
      _currentMode = "night_goddess";
      return _currentMode!;
    }

    // Morning → Focus or Balanced
    if (now.hour >= 6 && now.hour < 12) {
      _currentMode = m.boostFocusMode ? "focus" : "balanced";
      return _currentMode!;
    }

    // Afternoon → Balanced or Calm
    if (now.hour >= 12 && now.hour < 18) {
      _currentMode = m.boostRecoveryMode ? "recovery" : "calm";
      return _currentMode!;
    }

    // Default fallback
    _currentMode = "balanced";
    return _currentMode!;
  }

  // -----------------------------
  // MANUAL OVERRIDE
  // -----------------------------
  void overrideMode(String modeId) {
    _currentMode = modeId;
  }
}
