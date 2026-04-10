import '../models/calendar_day_model.dart';
import '../models/calendar_week_model.dart';
import '../models/calendar_event_model.dart';

/// CalendarFreeTimeEngine identifies:
/// - Free blocks
/// - Micro-windows
/// - Recovery windows
/// - Deep-work windows
/// - Mode-aware availability hooks
///
/// This engine is a utility layer used by:
/// - Smart Scheduling
/// - Mode Engine
/// - Next Best Action
/// - Insights / dashboards
class CalendarFreeTimeEngine {
  // Singleton
  static final CalendarFreeTimeEngine instance =
      CalendarFreeTimeEngine._internal();
  CalendarFreeTimeEngine._internal();

  // -----------------------------
  // FREE BLOCKS FOR A DAY
  // -----------------------------
  List<Map<String, dynamic>> freeBlocksForDay(CalendarDayModel day) {
    if (day.events.isEmpty) {
      final start = DateTime(day.date.year, day.date.month, day.date.day, 0, 0);
      final end = DateTime(day.date.year, day.date.month, day.date.day, 23, 59);
      return [
        {
          "start": start,
          "end": end,
          "minutes": end.difference(start).inMinutes,
        }
      ];
    }

    final events = [...day.events]..sort((a, b) => a.start.compareTo(b.start));
    final List<Map<String, dynamic>> blocks = [];

    final dayStart = DateTime(day.date.year, day.date.month, day.date.day, 0, 0);
    final dayEnd = DateTime(day.date.year, day.date.month, day.date.day, 23, 59);

    // Before first event
    final first = events.first;
    if (first.start.isAfter(dayStart)) {
      blocks.add({
        "start": dayStart,
        "end": first.start,
        "minutes": first.start.difference(dayStart).inMinutes,
      });
    }

    // Between events
    for (int i = 0; i < events.length - 1; i++) {
      final current = events[i];
      final next = events[i + 1];

      if (next.start.isAfter(current.end)) {
        blocks.add({
          "start": current.end,
          "end": next.start,
          "minutes": next.start.difference(current.end).inMinutes,
        });
      }
    }

    // After last event
    final last = events.last;
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
  // MICRO-WINDOWS (SHORT FREE BLOCKS)
  // -----------------------------
  List<Map<String, dynamic>> microWindowsForDay(
    CalendarDayModel day, {
    int maxMinutes = 30,
  }) {
    final blocks = freeBlocksForDay(day);
    return blocks
        .where((b) => (b["minutes"] as int) > 0 && (b["minutes"] as int) <= maxMinutes)
        .toList();
  }

  // -----------------------------
  // DEEP-WORK WINDOWS (LONG FREE BLOCKS)
  // -----------------------------
  List<Map<String, dynamic>> deepWorkWindowsForDay(
    CalendarDayModel day, {
    int minMinutes = 90,
  }) {
    final blocks = freeBlocksForDay(day);
    return blocks
        .where((b) => (b["minutes"] as int) >= minMinutes)
        .toList();
  }

  // -----------------------------
  // RECOVERY WINDOWS (LOW LOAD + FREE TIME)
  // -----------------------------
  List<Map<String, dynamic>> recoveryWindowsForDay(
    CalendarDayModel day, {
    int minMinutes = 45,
    double maxEmotionalLoad = 4,
    double maxFatigueLoad = 4,
  }) {
    if (day.emotionalLoad > maxEmotionalLoad ||
        day.fatigueLoad > maxFatigueLoad) {
      return [];
    }

    final blocks = freeBlocksForDay(day);
    return blocks
        .where((b) => (b["minutes"] as int) >= minMinutes)
        .toList();
  }

  // -----------------------------
  // WEEK-LEVEL FREE BLOCKS
  // -----------------------------
  List<Map<String, dynamic>> freeBlocksForWeek(CalendarWeekModel week) {
    final List<Map<String, dynamic>> blocks = [];

    for (final day in week.days) {
      final dayBlocks = freeBlocksForDay(day);
      for (final b in dayBlocks) {
        blocks.add({
          "start": b["start"],
          "end": b["end"],
          "minutes": b["minutes"],
          "date": day.date,
        });
      }
    }

    return blocks;
  }

  // -----------------------------
  // BEST DEEP-WORK WINDOW IN WEEK
  // -----------------------------
  Map<String, dynamic>? bestDeepWorkWindowInWeek(
    CalendarWeekModel week, {
    int minMinutes = 90,
  }) {
    final List<Map<String, dynamic>> candidates = [];

    for (final day in week.days) {
      final deepBlocks =
          deepWorkWindowsForDay(day, minMinutes: minMinutes);

      for (final b in deepBlocks) {
        double score = (b["minutes"] as int) / 30;

        // Prefer lower emotional + fatigue load
        score += (10 - day.emotionalLoad);
        score += (10 - day.fatigueLoad);

        candidates.add({
          "start": b["start"],
          "end": b["end"],
          "minutes": b["minutes"],
          "date": day.date,
          "score": score,
        });
      }
    }

    if (candidates.isEmpty) return null;

    candidates.sort(
        (a, b) => (b["score"] as double).compareTo(a["score"] as double));
    return candidates.first;
  }

  // -----------------------------
  // MODE-AWARE AVAILABILITY HOOK
  // (Placeholder for Mode Engine integration)
  // -----------------------------
  List<Map<String, dynamic>> availabilityForMode(
    CalendarWeekModel week, {
    required String modeId,
    int minMinutes = 30,
  }) {
    // For now, this simply returns all free blocks >= minMinutes.
    // Mode Engine can later filter/score these based on modeId.
    final blocks = freeBlocksForWeek(week);
    return blocks
        .where((b) => (b["minutes"] as int) >= minMinutes)
        .toList();
  }
}
