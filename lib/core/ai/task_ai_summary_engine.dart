import '../../data/models/task_model.dart';
import 'task_ai_insights_engine.dart';
import 'task_ai_scoring_engine.dart';
import 'task_ai_cluster_engine.dart';
import 'task_ai_pattern_engine.dart';
import 'task_ai_trend_engine.dart';
import 'task_ai_forecast_engine.dart';
import 'task_ai_anomaly_engine.dart';

/// TaskAISummaryEngine converts raw AI data into human-readable summaries.
/// This engine is used by:
/// - Dashboard summaries
/// - Mode Engine explanations
/// - Next Best Action Engine explanations
/// - Daily briefings
/// - Weekly reviews
/// - Smart nudges
/// - Task detail pages
///
/// It produces:
/// - Insight summaries
/// - Score summaries
/// - Cluster summaries
/// - Pattern summaries
/// - Trend summaries
/// - Forecast summaries
/// - Anomaly summaries
class TaskAISummaryEngine {
  // Singleton
  static final TaskAISummaryEngine instance =
      TaskAISummaryEngine._internal();
  TaskAISummaryEngine._internal();

  final _insights = TaskAIInsightsEngine.instance;
  final _scoring = TaskAIScoringEngine.instance;
  final _clusters = TaskAIClusterEngine.instance;
  final _patterns = TaskAIPatternEngine.instance;
  final _trends = TaskAITrendEngine.instance;
  final _forecast = TaskAIForecastEngine.instance;
  final _anomalies = TaskAIAnomalyEngine.instance;

  // -----------------------------
  // INSIGHT SUMMARY (PER TASK)
  // -----------------------------
  String insightSummary(TaskModel task) {
    final i = _insights.insightsFor(task);

    return """
Priority: ${i["priority"]}
Emotional Load: ${i["emotional"]}
Fatigue Impact: ${i["fatigue"]}
Due Date: ${i["overdueRisk"]}
Next Best Action: ${i["nextBestAction"]}
""".trim();
  }

  // -----------------------------
  // SCORE SUMMARY (PER TASK)
  // -----------------------------
  String scoreSummary(TaskModel task) {
    final s = _scoring.scores(task);

    return """
Difficulty Score: ${s["difficulty"]!.toStringAsFixed(1)}
Stress Score: ${s["stress"]!.toStringAsFixed(1)}
Readiness Score: ${s["readiness"]!.toStringAsFixed(1)}
Time Sensitivity: ${s["timeSensitivity"]!.toStringAsFixed(1)}
Global AI Score: ${s["globalScore"]!.toStringAsFixed(1)}
""".trim();
  }

  // -----------------------------
  // CLUSTER SUMMARY (ALL TASKS)
  // -----------------------------
  String clusterSummary(List<TaskModel> tasks) {
    final c = _clusters.clusterPackage(tasks);

    return """
High Difficulty: ${c["highDifficulty"]!.length}
High Stress: ${c["highStress"]!.length}
Low Readiness: ${c["lowReadiness"]!.length}
Time Sensitive: ${c["timeSensitive"]!.length}
High Global Score: ${c["highGlobalScore"]!.length}
Energy Friendly: ${c["energyFriendly"]!.length}
Emotionally Heavy: ${c["emotionalHeavy"]!.length}
Fatigue Heavy: ${c["fatigueHeavy"]!.length}
Quick Wins: ${c["quickWins"]!.length}
Urgent Time: ${c["urgentTime"]!.length}
""".trim();
  }

  // -----------------------------
  // PATTERN SUMMARY
  // -----------------------------
  String patternSummary(List<TaskModel> tasks) {
    final p = _patterns.patternPackage(tasks);

    return """
High Emotional Tasks: ${p["emotionalHigh"]!.length}
High Fatigue Tasks: ${p["fatigueHigh"]!.length}
High Priority Tasks: ${p["highPriority"]!.length}
Stuck Tasks: ${p["stuckTasks"]!.length}
Avoidance (Emotional): ${p["avoidanceEmotional"]!.length}
Avoidance (Fatigue): ${p["avoidanceFatigue"]!.length}
Momentum Tasks: ${p["momentumTasks"]!.length}
""".trim();
  }

  // -----------------------------
  // TREND SUMMARY
  // -----------------------------
  String trendSummary(List<TaskModel> tasks) {
    final emotional = _trends.emotionalTrend(tasks);
    final fatigue = _trends.fatigueTrend(tasks);
    final priority = _trends.priorityTrend(tasks);
    final completion = _trends.completionRate(tasks);
    final overdue = _trends.overdueRate(tasks);
    final burnout = _trends.burnoutTrend(tasks);

    return """
Emotional Trend: ${emotional.toStringAsFixed(1)}
Fatigue Trend: ${fatigue.toStringAsFixed(1)}
Priority Trend: ${priority.toStringAsFixed(1)}
Completion Rate: ${(completion * 100).toStringAsFixed(1)}%
Overdue Rate: ${(overdue * 100).toStringAsFixed(1)}%
Burnout Indicator: ${burnout.toStringAsFixed(1)}
""".trim();
  }

  // -----------------------------
  // FORECAST SUMMARY
  // -----------------------------
  String forecastSummary(List<TaskModel> tasks) {
    final f = _forecast.forecastPackage(tasks);

    return """
Next Week Emotional Load: ${f["emotionalForecast"]!.toStringAsFixed(1)}
Next Week Fatigue Load: ${f["fatigueForecast"]!.toStringAsFixed(1)}
Next Week Priority Load: ${f["priorityForecast"]!.toStringAsFixed(1)}
Overdue Risk (3 Days): ${(f["overdueForecast"]! * 100).toStringAsFixed(1)}%
Completion Forecast: ${(f["completionForecast"]! * 100).toStringAsFixed(1)}%
Burnout Forecast: ${f["burnoutForecast"]!.toStringAsFixed(1)}
Best Productivity Hour: ${f["productiveHour"]}
Global Load Forecast: ${f["globalLoadForecast"]!.toStringAsFixed(1)}
""".trim();
  }

  // -----------------------------
  // ANOMALY SUMMARY
  // -----------------------------
  String anomalySummary(List<TaskModel> tasks) {
    final a = _anomalies.anomalyPackage(tasks);

    return """
Emotional Spikes: ${a["emotionalSpike"]!.length}
Fatigue Spikes: ${a["fatigueSpike"]!.length}
Completion Drop: ${a["completionDrop"] == true ? "Yes" : "No"}
Overdue Anomalies: ${a["overdueAnomalies"]!.length}
Category Imbalance: ${a["categoryImbalance"]!.length}
Tag Imbalance: ${a["tagImbalance"]!.length}
Outlier Tasks: ${a["outlierTasks"]!.length}
Momentum Anomalies: ${a["momentumAnomalies"]!.length}
Behavioral Anomalies: ${a["behavioralAnomalies"]!.length}
""".trim();
  }

  // -----------------------------
  // FULL SUMMARY PACKAGE
  // -----------------------------
  Map<String, String> fullSummary({
    required TaskModel? task,
    required List<TaskModel> allTasks,
  }) {
    return {
      if (task != null) "insights": insightSummary(task),
      if (task != null) "scores": scoreSummary(task),
      "clusters": clusterSummary(allTasks),
      "patterns": patternSummary(allTasks),
      "trends": trendSummary(allTasks),
      "forecast": forecastSummary(allTasks),
      "anomalies": anomalySummary(allTasks),
    };
  }
}
