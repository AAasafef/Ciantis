import 'package:flutter/foundation.dart';

import '../models/calendar_event.dart';

/// CalendarAnalyticsEngine computes:
/// - Daily load scores
/// - Weekly balance scores
/// - Pattern detection
/// - Overload risk
/// - Recovery need
/// - Predictive insights
///
/// This powers the Insights panel and Mode Engine intelligence.
class CalendarAnalyticsEngine {
  // Singleton
  static final CalendarAnalyticsEngine instance =
      CalendarAnalyticsEngine._internal();
  CalendarAnalyticsEngine._internal();

  // -----------------------------
  // DAILY LOAD SCORE
  // -----------------------------
  int computeDailyLoad(List<CalendarEvent> events) {
    int score = 0;

    for (final e in events) {
      // Heavy events
      if (e.isEnergyHeavy) score += 25;

      // Deep work
      if (e.type == CalendarEventType.deepWork) score += 20;

      // Recovery reduces load
      if (e.type == CalendarEventType.recovery) score -= 20;

      // Long events
      if (e.duration.inMinutes >= 90) score += 15;

      // Important events
      if (e.isImportant) score += 10;

      // Short events
      if (e.duration.inMinutes <= 30) score += 5;
    }

    return score.clamp(0, 100);
  }

  // -----------------------------
  // WEEKLY BALANCE SCORE
  // -----------------------------
  int computeWeeklyBalance(List<List<CalendarEvent>> weekEvents) {
    int total = 0;

    for (final dayEvents in weekEvents) {
      total += computeDailyLoad(dayEvents);
    }

    // Normalize to 0–100
    final normalized = (total / (weekEvents.length * 100) * 100).round();
    return normalized.clamp(0, 100);
  }

  // -----------------------------
  // OVERLOAD RISK
  // -----------------------------
  bool isOverloadRisk(int dailyLoad) {
    return dailyLoad >= 75;
  }

  // -----------------------------
  // RECOVERY NEED
  // -----------------------------
  bool needsRecovery(int dailyLoad) {
    return dailyLoad >= 60;
  }

  // -----------------------------
  // PATTERN DETECTION
  // -----------------------------
  CalendarPatterns detectPatterns(List<CalendarEvent> events) {
    int deepWorkCount = 0;
    int recoveryCount = 0;
    int heavyCount = 0;

    for (final e in events) {
      if (e.type == CalendarEventType.deepWork) deepWorkCount++;
      if (e.type == CalendarEventType.recovery) recoveryCount++;
      if (e.isEnergyHeavy) heavyCount++;
    }

    return CalendarPatterns(
      deepWorkCount: deepWorkCount,
      recoveryCount: recoveryCount,
      heavyCount: heavyCount,
    );
  }

  // -----------------------------
  // PREDICT TOMORROW LOAD
  // -----------------------------
  int predictTomorrowLoad(List<CalendarEvent> tomorrowEvents) {
    return computeDailyLoad(tomorrowEvents);
  }

  // -----------------------------
  // PREDICT NEXT WEEK BALANCE
  // -----------------------------
  int predictNextWeekBalance(List<List<CalendarEvent>> nextWeekEvents) {
    return computeWeeklyBalance(nextWeekEvents);
  }
}

// -----------------------------
// PATTERN MODEL
// -----------------------------
@immutable
class CalendarPatterns {
  final int deepWorkCount;
  final int recoveryCount;
  final int heavyCount;

  const CalendarPatterns({
    required this.deepWorkCount,
    required this.recoveryCount,
    required this.heavyCount,
  });
}
