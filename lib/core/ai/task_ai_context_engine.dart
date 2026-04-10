import '../../data/models/task_model.dart';
import 'task_ai_trend_engine.dart';
import 'task_ai_forecast_engine.dart';

/// TaskAIContextEngine interprets the user's current state and environment.
/// This engine is used by:
/// - Mode Engine
/// - Next Best Action Engine
/// - Smart sorting
/// - Adaptive scheduling
/// - Dashboard "Today's State"
///
/// It produces:
/// - Energy context
/// - Emotional context
/// - Fatigue context
/// - Time-of-day context
/// - Workload context
/// - Stress context
/// - Burnout context
///
/// This is the "You right now" model.
class TaskAIContextEngine {
  // Singleton
  static final TaskAIContextEngine instance =
      TaskAIContextEngine._internal();
  TaskAIContextEngine._internal();

  final _trend = TaskAITrendEngine.instance;
  final _forecast = TaskAIForecastEngine.instance;

  // -----------------------------
  // ENERGY CONTEXT
  // -----------------------------
  /// Estimates energy level (0–10) based on:
  /// - fatigue trend
  /// - time of day
  /// - recent workload
  double energyContext(List<TaskModel> tasks) {
    final fatigue = _trend.fatigueTrend(tasks);
    final hour = DateTime.now().hour;

    double base = 10 - fatigue;

    // Morning boost
    if (hour >= 7 && hour <= 11) base += 1.5;

    // Afternoon dip
    if (hour >= 13 && hour <= 16) base -= 1;

    // Evening fatigue
    if (hour >= 18) base -= 1.5;

    return base.clamp(0, 10);
  }

  // -----------------------------
  // EMOTIONAL CONTEXT
  // -----------------------------
  /// Estimates emotional bandwidth (0–10).
  double emotionalContext(List<TaskModel> tasks) {
    final emotional = _trend.emotionalTrend(tasks);
    return (10 - emotional).clamp(0, 10);
  }

  // -----------------------------
  // FATIGUE CONTEXT
  // -----------------------------
  /// Higher = more fatigued.
  double fatigueContext(List<TaskModel> tasks) {
    final fatigue = _trend.fatigueTrend(tasks);
    return fatigue.clamp(0, 10);
  }

  // -----------------------------
  // TIME-OF-DAY CONTEXT
  // -----------------------------
  /// Returns:
  /// - "morning"
  /// - "afternoon"
  /// - "evening"
  /// - "night"
  String timeOfDayContext() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) return "morning";
    if (hour >= 12 && hour < 17) return "afternoon";
    if (hour >= 17 && hour < 22) return "evening";
    return "night";
  }

  // -----------------------------
  // WORKLOAD CONTEXT
  // -----------------------------
  /// Measures how heavy the current task load is.
  double workloadContext(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 0;

    final globalLoad = _forecast.forecastGlobalLoad(tasks);

    if (globalLoad >= 15) return 10;
    if (globalLoad >= 10) return 7;
    if (globalLoad >= 6) return 4;

    return 2;
  }

  // -----------------------------
  // STRESS CONTEXT
  // -----------------------------
  /// Stress = emotional trend + overdue rate + workload
  double stressContext(List<TaskModel> tasks) {
    final emotional = _trend.emotionalTrend(tasks);
    final overdue = _trend.overdueRate(tasks) * 10;
    final workload = workloadContext(tasks);

    return (emotional + overdue + workload).clamp(0, 10);
  }

  // -----------------------------
  // BURNOUT CONTEXT
  // -----------------------------
  /// Burnout = fatigue + emotional + low completion
  double burnoutContext(List<TaskModel> tasks) {
    final fatigue = _trend.fatigueTrend(tasks);
    final emotional = _trend.emotionalTrend(tasks);
    final completion = _trend.completionRate(tasks);

    final burnout = (fatigue * 0.4) +
        (emotional * 0.4) +
        ((1 - completion) * 10 * 0.2);

    return burnout.clamp(0, 10);
  }

  // -----------------------------
  // FULL CONTEXT PACKAGE
  // -----------------------------
  Map<String, dynamic> contextPackage(List<TaskModel> tasks) {
    return {
      "energy": energyContext(tasks),
      "emotional": emotionalContext(tasks),
      "fatigue": fatigueContext(tasks),
      "timeOfDay": timeOfDayContext(),
      "workload": workloadContext(tasks),
      "stress": stressContext(tasks),
      "burnout": burnoutContext(tasks),
    };
  }

  // -----------------------------
  // CONTEXT SUMMARY (HUMAN-READABLE)
  // -----------------------------
  String contextSummary(List<TaskModel> tasks) {
    final c = contextPackage(tasks);

    return """
Energy Level: ${c["energy"].toStringAsFixed(1)} / 10  
Emotional Bandwidth: ${c["emotional"].toStringAsFixed(1)} / 10  
Fatigue Level: ${c["fatigue"].toStringAsFixed(1)} / 10  
Time of Day: ${c["timeOfDay"]}  
Workload Pressure: ${c["workload"].toStringAsFixed(1)} / 10  
Stress Level: ${c["stress"].toStringAsFixed(1)} / 10  
Burnout Indicator: ${c["burnout"].toStringAsFixed(1)} / 10  
""".trim();
  }
}
