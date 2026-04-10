import 'package:flutter/foundation.dart';

import '../../calendar/services/calendar_service.dart';
import '../../calendar/models/calendar_day_model.dart';
import '../../calendar/models/calendar_week_model.dart';
import '../../calendar/models/calendar_month_model.dart';

/// ModeCalendarFacade is the bridge between:
/// - Mode Engine
/// - Calendar subsystem
///
/// It exposes a mode-friendly view of:
/// - Overload
/// - Free time
/// - Deep-work windows
/// - Recovery windows
/// - Emotional / fatigue tone
///
/// So modes can adapt behavior based on the real schedule.
class ModeCalendarFacade {
  // Singleton
  static final ModeCalendarFacade instance =
      ModeCalendarFacade._internal();
  ModeCalendarFacade._internal();

  final _calendar = CalendarService.instance;

  // -----------------------------
  // DAILY CONTEXT FOR MODE
  // -----------------------------
  ModeCalendarDayContext getDayContext(DateTime date) {
    final day = _calendar.getDay(date);

    final freeBlocks = _calendar.freeBlocksForDay(date);
    final deepWork = _calendar.deepWorkWindowsForDay(date);
    final recovery = _calendar.recoveryWindowsForDay(date);
    final insight = _calendar.getDailyInsight(date);

    return ModeCalendarDayContext(
      date: date,
      isOverloaded: day.isOverloaded,
      isHighDensity: day.isHighDensity,
      isLightDay: day.isLightDay,
      totalBusyMinutes: day.totalBusyMinutes,
      emotionalLoad: day.emotionalLoad,
      fatigueLoad: day.fatigueLoad,
      freeBlocks: freeBlocks,
      deepWorkWindows: deepWork,
      recoveryWindows: recovery,
      insight: insight,
    );
  }

  // -----------------------------
  // WEEKLY CONTEXT FOR MODE
  // -----------------------------
  ModeCalendarWeekContext getWeekContext(DateTime weekStart) {
    final week = _calendar.getWeek(weekStart);

    final insight = _calendar.getWeeklyInsight(weekStart);

    // Aggregate free/deep/recovery across the week
    final List<Map<String, dynamic>> freeBlocks = [];
    final List<Map<String, dynamic>> deepWork = [];
    final List<Map<String, dynamic>> recovery = [];

    for (final day in week.days) {
      freeBlocks.addAll(_calendar.freeBlocksForDay(day.date));
      deepWork.addAll(_calendar.deepWorkWindowsForDay(day.date));
      recovery.addAll(_calendar.recoveryWindowsForDay(day.date));
    }

    return ModeCalendarWeekContext(
      weekStart: week.weekStart,
      weekEnd: week.weekEnd,
      isOverloaded: week.isOverloaded,
      isHighDensity: week.isHighDensity,
      isLightWeek: week.isLightWeek,
      totalBusyMinutes: week.totalBusyMinutes,
      avgEmotionalLoad: week.avgEmotionalLoad,
      avgFatigueLoad: week.avgFatigueLoad,
      freeBlocks: freeBlocks,
      deepWorkWindows: deepWork,
      recoveryWindows: recovery,
      insight: insight,
    );
  }

  // -----------------------------
  // MONTHLY CONTEXT FOR MODE
  // -----------------------------
  ModeCalendarMonthContext getMonthContext(int year, int month) {
    final m = _calendar.getMonth(year, month);
    final insight = _calendar.getMonthlyInsight(year, month);

    return ModeCalendarMonthContext(
      year: m.year,
      month: m.month,
      isOverloaded: m.isOverloaded,
      isHighDensity: m.isHighDensity,
      isLightMonth: m.isLightMonth,
      totalBusyMinutes: m.totalBusyMinutes,
      avgEmotionalLoad: m.avgEmotionalLoad,
      avgFatigueLoad: m.avgFatigueLoad,
      insight: insight,
    );
  }
}

// -----------------------------
// DATA CLASSES FOR MODE CONTEXT
// -----------------------------
@immutable
class ModeCalendarDayContext {
  final DateTime date;
  final bool isOverloaded;
  final bool isHighDensity;
  final bool isLightDay;
  final int totalBusyMinutes;
  final double emotionalLoad;
  final double fatigueLoad;
  final List<Map<String, dynamic>> freeBlocks;
  final List<Map<String, dynamic>> deepWorkWindows;
  final List<Map<String, dynamic>> recoveryWindows;
  final String insight;

  const ModeCalendarDayContext({
    required this.date,
    required this.isOverloaded,
    required this.isHighDensity,
    required this.isLightDay,
    required this.totalBusyMinutes,
    required this.emotionalLoad,
    required this.fatigueLoad,
    required this.freeBlocks,
    required this.deepWorkWindows,
    required this.recoveryWindows,
    required this.insight,
  });
}

@immutable
class ModeCalendarWeekContext {
  final DateTime weekStart;
  final DateTime weekEnd;
  final bool isOverloaded;
  final bool isHighDensity;
  final bool isLightWeek;
  final int totalBusyMinutes;
  final double avgEmotionalLoad;
  final double avgFatigueLoad;
  final List<Map<String, dynamic>> freeBlocks;
  final List<Map<String, dynamic>> deepWorkWindows;
  final List<Map<String, dynamic>> recoveryWindows;
  final String insight;

  const ModeCalendarWeekContext({
    required this.weekStart,
    required this.weekEnd,
    required this.isOverloaded,
    required this.isHighDensity,
    required this.isLightWeek,
    required this.totalBusyMinutes,
    required this.avgEmotionalLoad,
    required this.avgFatigueLoad,
    required this.freeBlocks,
    required this.deepWorkWindows,
    required this.recoveryWindows,
    required this.insight,
  });
}

@immutable
class ModeCalendarMonthContext {
  final int year;
  final int month;
  final bool isOverloaded;
  final bool isHighDensity;
  final bool isLightMonth;
  final int totalBusyMinutes;
  final double avgEmotionalLoad;
  final double avgFatigueLoad;
  final String insight;

  const ModeCalendarMonthContext({
    required this.year,
    required this.month,
    required this.isOverloaded,
    required this.isHighDensity,
    required this.isLightMonth,
    required this.totalBusyMinutes,
    required this.avgEmotionalLoad,
    required this.avgFatigueLoad,
    required this.insight,
  });
}
