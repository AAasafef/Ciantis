import 'package:flutter/foundation.dart';

import '../models/calendar_event.dart';

/// MonthHeatmapEngine computes a daily intensity score for the month:
/// - Stress load
/// - Energy demand
/// - Focus demand
/// - Recovery balance
///
/// This powers the heatmap overlay in the Month View.
class MonthHeatmapEngine {
  // Singleton
  static final MonthHeatmapEngine instance =
      MonthHeatmapEngine._internal();
  MonthHeatmapEngine._internal();

  // -----------------------------
  // MAIN ENTRY
  // -----------------------------
  MonthHeatmapModel buildHeatmap({
    required int year,
    required int month,
    required List<CalendarEvent> events,
  }) {
    final scores = <DateTime, int>{};

    for (final e in events) {
      if (e.start.year == year && e.start.month == month) {
        final day = DateTime(e.start.year, e.start.month, e.start.day);
        final score = _computeScore(e);

        scores[day] = (scores[day] ?? 0) + score;
      }
    }

    // Normalize scores to 0–100
    final normalized = _normalize(scores);

    return MonthHeatmapModel(
      year: year,
      month: month,
      scores: normalized,
    );
  }

  // -----------------------------
  // SCORE COMPUTATION
  // -----------------------------
  int _computeScore(CalendarEvent e) {
    int score = 0;

    // Heavy events add more load
    if (e.isEnergyHeavy) score += 30;

    // Deep work adds focus load
    if (e.type == CalendarEventType.deepWork) score += 20;

    // Recovery events reduce load
    if (e.type == CalendarEventType.recovery) score -= 20;

    // Long events add more load
    if (e.duration.inMinutes >= 90) score += 15;

    // Short events add minimal load
    if (e.duration.inMinutes <= 30) score += 5;

    // Important events add emotional load
    if (e.isImportant) score += 10;

    return score.clamp(-20, 100);
  }

  // -----------------------------
  // NORMALIZATION
  // -----------------------------
  Map<DateTime, int> _normalize(Map<DateTime, int> scores) {
    if (scores.isEmpty) return {};

    final values = scores.values;
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);

    if (max == min) {
      // All days identical → flat heatmap
      return scores.map((k, v) => MapEntry(k, 50));
    }

    return scores.map((day, value) {
      final normalized = ((value - min) / (max - min) * 100).round();
      return MapEntry(day, normalized);
    });
  }
}

// -----------------------------
// HEATMAP MODEL
// -----------------------------
@immutable
class MonthHeatmapModel {
  final int year;
  final int month;

  /// Map<DateTime, score 0–100>
  final Map<DateTime, int> scores;

  const MonthHeatmapModel({
    required this.year,
    required this.month,
    required this.scores,
  });
}
