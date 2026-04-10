import '../../data/models/task_model.dart';
import 'task_ai_trend_engine.dart';
import 'task_ai_scoring_engine.dart';

/// TaskAIForecastEngine predicts future task behavior using:
/// - Trends (from Trend Engine)
/// - Scores (from Scoring Engine)
/// - Lightweight heuristics
///
/// This engine powers:
/// - Mode Engine
/// - Next Best Action Engine
/// - Dashboard forecasting
/// - Calendar predictions
/// - Burnout prevention
/// - Energy-aware planning
class TaskAIForecastEngine {
  // Singleton
  static final TaskAIForecastEngine instance =
      TaskAIForecastEngine._internal();
  TaskAIForecastEngine._internal();

  final _trend = TaskAITrendEngine.instance;
  final _scoring = TaskAIScoringEngine.instance;

  // -----------------------------
  // FORECAST: FUTURE EMOTIONAL LOAD
  // -----------------------------
  /// Predicts emotional load for the next 7 days.
  double forecastEmotionalLoad(List<TaskModel> tasks) {
    final trend = _trend.emotionalTrend(tasks);

    // If emotional trend is high, assume slight increase
    if (trend >= 6) return trend + 0.5;

    // If emotional trend is low, assume stability
    if (trend <= 3) return trend;

    // Otherwise, slight drift upward
    return trend + 0.2;
  }

  // -----------------------------
  // FORECAST: FUTURE FATIGUE LOAD
  // -----------------------------
  double forecastFatigueLoad(List<TaskModel> tasks) {
    final trend = _trend.fatigueTrend(tasks);

    if (trend >= 6) return trend + 0.3;
    if (trend <= 3) return trend;
    return trend + 0.1;
  }

  // -----------------------------
  // FORECAST: FUTURE PRIORITY LOAD
  // -----------------------------
  double forecastPriorityLoad(List<TaskModel> tasks) {
    final trend = _trend.priorityTrend(tasks);

    if (trend >= 4) return trend + 0.2;
    return trend;
  }

  // -----------------------------
  // FORECAST: OVERDUE RISK
  // -----------------------------
  /// Predicts overdue risk for the next 3 days.
  double forecastOverdueRisk(List<TaskModel> tasks) {
    final overdue = _trend.overdueRate(tasks);

    // If overdue rate is high, assume increase
    if (overdue >= 0.3) return overdue + 0.1;

    // If overdue rate is low, assume stability
    if (overdue <= 0.1) return overdue;

    // Otherwise, slight increase
    return overdue + 0.05;
  }

  // -----------------------------
  // FORECAST: COMPLETION RATE
  // -----------------------------
  double forecastCompletionRate(List<TaskModel> tasks) {
    final rate = _trend.completionRate(tasks);

    // If completion rate is high, assume stability
    if (rate >= 0.7) return rate;

    // If completion rate is low, assume slight improvement
    if (rate <= 0.3) return rate + 0.1;

    // Otherwise, slight drift upward
    return rate + 0.05;
  }

  // -----------------------------
  // FORECAST: BURNOUT RISK
  // -----------------------------
  double forecastBurnoutRisk(List<TaskModel> tasks) {
    final burnout = _trend.burnoutTrend(tasks);

    // If burnout is high, assume increase
    if (burnout >= 6) return burnout + 0.5;

    // If burnout is low, assume stability
    if (burnout <= 3) return burnout;

    // Otherwise, slight increase
    return burnout + 0.2;
  }

  // -----------------------------
  // FORECAST: PRODUCTIVITY WINDOW
  // -----------------------------
  /// Predicts the best productivity window for the next 24 hours.
  /// Returns hour of day (0–23).
  int forecastProductiveHour(List<TaskModel> tasks) {
    final weekly = _trend.weeklyProductivity(tasks);

    if (weekly.isEmpty) return 10; // default: mid-morning

    // Find the hour with the highest completion count
    int bestHour = 10;
    int bestCount = 0;

    weekly.forEach((hour, count) {
      if (count > bestCount) {
        bestHour = hour;
        bestCount = count;
      }
    });

    return bestHour;
  }

  // -----------------------------
  // FORECAST: FUTURE GLOBAL LOAD
  // -----------------------------
  /// Predicts the overall task load for the next 7 days.
  double forecastGlobalLoad(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 0;

    double total = 0;

    for (final t in tasks) {
      total += _scoring.globalScore(t);
    }

    final avg = total / tasks.length;

    // If global load is high, assume increase
    if (avg >= 12) return avg + 1;

    // If global load is low, assume stability
    if (avg <= 6) return avg;

    // Otherwise, slight increase
    return avg + 0.5;
  }

  // -----------------------------
  // FULL FORECAST PACKAGE
  // -----------------------------
  Map<String, dynamic> forecastPackage(List<TaskModel> tasks) {
    return {
      "emotionalForecast": forecastEmotionalLoad(tasks),
      "fatigueForecast": forecastFatigueLoad(tasks),
      "priorityForecast": forecastPriorityLoad(tasks),
      "overdueForecast": forecastOverdueRisk(tasks),
      "completionForecast": forecastCompletionRate(tasks),
      "burnoutForecast": forecastBurnoutRisk(tasks),
      "productiveHour": forecastProductiveHour(tasks),
      "globalLoadForecast": forecastGlobalLoad(tasks),
    };
  }
}
