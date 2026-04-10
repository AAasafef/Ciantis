import '../../data/models/task_model.dart';
import 'task_ai_scoring_engine.dart';
import 'task_ai_insights_engine.dart';
import 'task_ai_cluster_engine.dart';
import 'task_ai_pattern_engine.dart';
import 'task_ai_trend_engine.dart';
import 'task_ai_forecast_engine.dart';
import 'task_ai_anomaly_engine.dart';

/// TaskAIExplanationEngine explains *why* the AI made a decision.
/// This engine is used by:
/// - Mode Engine
/// - Next Best Action Engine
/// - Dashboard explanations
/// - Smart nudges
/// - Transparency UI
///
/// It produces:
/// - Ranking explanations
/// - Recommendation explanations
/// - Cluster explanations
/// - Pattern explanations
/// - Trend explanations
/// - Forecast explanations
/// - Anomaly explanations
class TaskAIExplanationEngine {
  // Singleton
  static final TaskAIExplanationEngine instance =
      TaskAIExplanationEngine._internal();
  TaskAIExplanationEngine._internal();

  final _scoring = TaskAIScoringEngine.instance;
  final _insights = TaskAIInsightsEngine.instance;
  final _clusters = TaskAIClusterEngine.instance;
  final _patterns = TaskAIPatternEngine.instance;
  final _trends = TaskAITrendEngine.instance;
  final _forecast = TaskAIForecastEngine.instance;
  final _anomalies = TaskAIAnomalyEngine.instance;

  // -----------------------------
  // EXPLAIN RANKING (PER TASK)
  // -----------------------------
  String explainRanking(TaskModel task) {
    final s = _scoring.scores(task);

    return """
This task ranks highly because of its global AI score of ${s["globalScore"]!.toStringAsFixed(1)}. 
Its difficulty score (${s["difficulty"]!.toStringAsFixed(1)}) and stress score (${s["stress"]!.toStringAsFixed(1)}) contribute significantly to its urgency. 
The time sensitivity score (${s["timeSensitivity"]!.toStringAsFixed(1)}) indicates how soon it may require attention.
""".trim();
  }

  // -----------------------------
  // EXPLAIN NEXT BEST ACTION
  // -----------------------------
  String explainNextBestAction(TaskModel task) {
    final i = _insights.insightsFor(task);

    return """
The recommended next action is based on several factors:
• Priority: ${i["priority"]}  
• Emotional Load: ${i["emotional"]}  
• Fatigue Impact: ${i["fatigue"]}  
• Due Date Status: ${i["overdueRisk"]}  

These combined signals shape the suggested next step.
""".trim();
  }

  // -----------------------------
  // EXPLAIN CLUSTER MEMBERSHIP
  // -----------------------------
  String explainCluster(TaskModel task, List<TaskModel> allTasks) {
    final difficulty = _clusters.highDifficulty(allTasks).contains(task);
    final stress = _clusters.highStress(allTasks).contains(task);
    final readiness = _clusters.lowReadiness(allTasks).contains(task);
    final time = _clusters.timeSensitive(allTasks).contains(task);
    final quick = _clusters.quickWins(allTasks).contains(task);

    final List<String> reasons = [];

    if (difficulty) reasons.add("It has a high difficulty score.");
    if (stress) reasons.add("It carries significant stress.");
    if (readiness) reasons.add("It has low readiness, meaning it may feel hard to start.");
    if (time) reasons.add("It is time-sensitive.");
    if (quick) reasons.add("It qualifies as a quick win.");

    if (reasons.isEmpty) {
      return "This task does not belong to any major AI cluster.";
    }

    return "This task belongs to the following AI clusters:\n• ${reasons.join("\n• ")}";
  }

  // -----------------------------
  // EXPLAIN PATTERNS
  // -----------------------------
  String explainPatterns(TaskModel task, List<TaskModel> allTasks) {
    final emotionalHigh = _patterns.emotionalPatternHigh(allTasks).contains(task);
    final fatigueHigh = _patterns.fatiguePatternHigh(allTasks).contains(task);
    final stuck = _patterns.stuckTasks(allTasks).contains(task);
    final avoidanceE = _patterns.avoidanceEmotional(allTasks).contains(task);
    final avoidanceF = _patterns.avoidanceFatigue(allTasks).contains(task);

    final List<String> reasons = [];

    if (emotionalHigh) reasons.add("It has a consistently high emotional load.");
    if (fatigueHigh) reasons.add("It has a consistently high fatigue impact.");
    if (stuck) reasons.add("It has remained incomplete for a long time.");
    if (avoidanceE) reasons.add("It appears to be emotionally avoided.");
    if (avoidanceF) reasons.add("It appears to be avoided due to fatigue.");

    if (reasons.isEmpty) {
      return "This task does not match any notable behavioral patterns.";
    }

    return "This task matches the following behavioral patterns:\n• ${reasons.join("\n• ")}";
  }

  // -----------------------------
  // EXPLAIN TRENDS
  // -----------------------------
  String explainTrends(List<TaskModel> tasks) {
    final emotional = _trends.emotionalTrend(tasks);
    final fatigue = _trends.fatigueTrend(tasks);
    final completion = _trends.completionRate(tasks);
    final overdue = _trends.overdueRate(tasks);

    return """
Your current task trends show:
• Emotional load averaging ${emotional.toStringAsFixed(1)}  
• Fatigue impact averaging ${fatigue.toStringAsFixed(1)}  
• Completion rate at ${(completion * 100).toStringAsFixed(1)}%  
• Overdue rate at ${(overdue * 100).toStringAsFixed(1)}%  

These trends influence how the AI prioritizes and surfaces tasks.
""".trim();
  }

  // -----------------------------
  // EXPLAIN FORECAST
  // -----------------------------
  String explainForecast(List<TaskModel> tasks) {
    final f = _forecast.forecastPackage(tasks);

    return """
The AI forecast is based on your recent trends and task patterns:
• Emotional load expected to move toward ${f["emotionalForecast"]!.toStringAsFixed(1)}  
• Fatigue load trending toward ${f["fatigueForecast"]!.toStringAsFixed(1)}  
• Priority load projected at ${f["priorityForecast"]!.toStringAsFixed(1)}  
• Overdue risk estimated at ${(f["overdueForecast"]! * 100).toStringAsFixed(1)}%  
• Completion rate forecast at ${(f["completionForecast"]! * 100).toStringAsFixed(1)}%  
• Burnout risk trending toward ${f["burnoutForecast"]!.toStringAsFixed(1)}  

These forecasts help the system anticipate your workload and energy needs.
""".trim();
  }

  // -----------------------------
  // EXPLAIN ANOMALIES
  // -----------------------------
  String explainAnomalies(List<TaskModel> tasks) {
    final a = _anomalies.anomalyPackage(tasks);

    return """
The AI detected the following anomalies:
• Emotional spikes: ${a["emotionalSpike"]!.length}  
• Fatigue spikes: ${a["fatigueSpike"]!.length}  
• Overdue anomalies: ${a["overdueAnomalies"]!.length}  
• Outlier tasks: ${a["outlierTasks"]!.length}  
• Behavioral anomalies: ${a["behavioralAnomalies"]!.length}  

These anomalies highlight areas where your system is under stress or behaving unexpectedly.
""".trim();
  }

  // -----------------------------
  // FULL EXPLANATION PACKAGE
  // -----------------------------
  Map<String, String> explanationPackage({
    required TaskModel? task,
    required List<TaskModel> allTasks,
  }) {
    return {
      if (task != null) "ranking": explainRanking(task),
      if (task != null) "nextBestAction": explainNextBestAction(task),
      if (task != null) "cluster": explainCluster(task, allTasks),
      if (task != null) "patterns": explainPatterns(task, allTasks),
      "trends": explainTrends(allTasks),
      "forecast": explainForecast(allTasks),
      "anomalies": explainAnomalies(allTasks),
    };
  }
}
