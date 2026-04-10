import '../models/calendar_day_model.dart';
import '../models/calendar_week_model.dart';
import '../models/calendar_event_model.dart';
import 'calendar_analytics_engine.dart';

/// CalendarSmartSchedulingEngine determines the best times to schedule:
/// - Events
/// - Tasks
/// - Routines
/// - Appointments
///
/// It uses:
/// - Free-time blocks
/// - Emotional load
/// - Fatigue load
/// - Busy density
/// - Recovery windows
/// - Event constraints
///
/// This engine powers:
/// - "Best time to schedule" suggestions
/// - Event creation UI
/// - Task → Calendar scheduling
/// - Routine placement
/// - Appointment optimization
class CalendarSmartSchedulingEngine {
  // Singleton
  static final CalendarSmartSchedulingEngine instance =
      CalendarSmartSchedulingEngine._internal();
  CalendarSmartSchedulingEngine._internal();

  final _analytics = CalendarAnalyticsEngine.instance;

  // -----------------------------
  // FIND BEST TIME IN A WEEK
  // -----------------------------
  Map<String, dynamic> bestTimeInWeek({
    required CalendarWeekModel week,
    required Duration duration,
    bool avoidHighEmotional = true,
    bool avoidHighFatigue = true,
  }) {
    final freeBlocks = _analytics.analyzeWeek(week)["freeTimeBlocks"]
        as List<Map<String, dynamic>>;

    if (freeBlocks.isEmpty) {
      return {
        "success": false,
        "reason": "No free time available this week.",
      };
    }

    // Filter blocks that fit the required duration
    final fittingBlocks = freeBlocks.where((b) {
      return (b["minutes"] as int) >= duration.inMinutes;
    }).toList();

    if (fittingBlocks.isEmpty) {
      return {
        "success": false,
        "reason": "No free block is long enough for this duration.",
      };
    }

    // Score each block
    final scored = fittingBlocks.map((block) {
      final start = block["start"] as DateTime;
      final day = week.days.firstWhere((d) =>
          d.date.year == start.year &&
          d.date.month == start.month &&
          d.date.day == start.day);

      double score = 0;

      // Prefer low emotional load
      if (avoidHighEmotional) {
        score += (10 - day.emotionalLoad) * 2;
      }

      // Prefer low fatigue load
      if (avoidHighFatigue) {
        score += (10 - day.fatigueLoad) * 2;
      }

      // Prefer larger blocks
      score += (block["minutes"] as int) / 30;

      return {
        "block": block,
        "score": score,
      };
    }).toList();

    // Pick the highest scoring block
    scored.sort((a, b) => (b["score"] as double).compareTo(a["score"] as double));
    final best = scored.first;

    return {
      "success": true,
      "start": best["block"]["start"],
      "end": best["block"]["end"],
      "score": best["score"],
      "minutes": best["block"]["minutes"],
      "reason": _reasonForBlock(best),
    };
  }

  // -----------------------------
  // FIND BEST TIME IN A MONTH
  // -----------------------------
  Map<String, dynamic> bestTimeInMonth({
    required List<CalendarWeekModel> weeks,
    required Duration duration,
  }) {
    final List<Map<String, dynamic>> candidates = [];

    for (final week in weeks) {
      final result = bestTimeInWeek(
        week: week,
        duration: duration,
      );

      if (result["success"] == true) {
        candidates.add(result);
      }
    }

    if (candidates.isEmpty) {
      return {
        "success": false,
        "reason": "No suitable scheduling window found this month.",
      };
    }

    // Pick the best scoring week-level suggestion
    candidates.sort((a, b) =>
        (b["score"] as double).compareTo(a["score"] as double));

    return candidates.first;
  }

  // -----------------------------
  // REASON FOR BLOCK
  // -----------------------------
  String _reasonForBlock(Map<String, dynamic> block) {
    final score = block["score"] as double;
    final minutes = block["block"]["minutes"] as int;

    if (score > 40) {
      return "This block offers excellent emotional and physical alignment with plenty of space.";
    }

    if (score > 25) {
      return "This block is a strong fit with good emotional and physical alignment.";
    }

    if (minutes > 120) {
      return "This block is long enough to comfortably fit your event.";
    }

    return "This block is a reasonable fit for your schedule.";
  }

  // -----------------------------
  // SCHEDULE A TASK INTO CALENDAR
  // -----------------------------
  Map<String, dynamic> scheduleTask({
    required CalendarWeekModel week,
    required Duration duration,
  }) {
    final best = bestTimeInWeek(
      week: week,
      duration: duration,
    );

    if (best["success"] != true) {
      return {
        "success": false,
        "reason": best["reason"],
      };
    }

    return {
      "success": true,
      "start": best["start"],
      "end": best["end"],
      "minutes": best["minutes"],
      "reason": best["reason"],
    };
  }
}
