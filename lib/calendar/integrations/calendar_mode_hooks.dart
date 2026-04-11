import 'package:flutter/foundation.dart';

import '../../mode/engine/mode_engine.dart';
import '../../mode/auto/mode_auto_switching_engine.dart';
import '../calendar_facade.dart';

/// CalendarModeHooks listens to calendar events and triggers
/// mode adjustments when events start or end.
///
/// This ensures:
/// - Deep-work events → Focus Mode
/// - Recovery events → Recovery Mode
/// - Heavy blocks → Overload Protection
/// - Free blocks → Balanced/Calm
/// - Evening → Night Goddess Mode
class CalendarModeHooks {
  // Singleton
  static final CalendarModeHooks instance =
      CalendarModeHooks._internal();
  CalendarModeHooks._internal();

  final _modeEngine = ModeEngine.instance;
  final _auto = ModeAutoSwitchingEngine.instance;
  final _calendar = CalendarFacade.instance;

  bool _initialized = false;

  // -----------------------------
  // INITIALIZE HOOKS
  // -----------------------------
  void initialize() {
    if (_initialized) return;
    _initialized = true;

    _calendar.addListener(_onCalendarUpdate);
  }

  // -----------------------------
  // CALENDAR UPDATE HANDLER
  // -----------------------------
  void _onCalendarUpdate() {
    final now = DateTime.now();
    final ctx = _calendar.getContextForTime(now);

    // Deep-work window
    if (ctx.isDeepWorkWindow) {
      _modeEngine.overrideMode("focus");
      debugPrint("[CalendarModeHooks] Deep-work window → Focus Mode");
      return;
    }

    // Recovery window
    if (ctx.isRecoveryWindow) {
      _modeEngine.overrideMode("recovery");
      debugPrint("[CalendarModeHooks] Recovery window → Recovery Mode");
      return;
    }

    // Overload block
    if (ctx.isOverloaded) {
      _modeEngine.overrideMode("overload_protection");
      debugPrint("[CalendarModeHooks] Overload detected → Overload Protection");
      return;
    }

    // Evening → Night Goddess Mode
    if (now.hour >= 20) {
      _modeEngine.overrideMode("night_goddess");
      debugPrint("[CalendarModeHooks] Evening → Night Goddess Mode");
      return;
    }

    // Free block → Balanced or Calm
    if (ctx.isFreeBlock) {
      _modeEngine.overrideMode("calm");
      debugPrint("[CalendarModeHooks] Free block → Calm Mode");
      return;
    }

    // Default fallback → Auto-switch
    final auto = _auto.adaptInRealTime(
      now: now,
      isInDeepWorkWindow: ctx.isDeepWorkWindow,
      isInRecoveryWindow: ctx.isRecoveryWindow,
    );

    _modeEngine.overrideMode(auto);
    debugPrint("[CalendarModeHooks] Auto-adapt → $auto");
  }
}
