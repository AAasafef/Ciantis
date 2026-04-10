import '../../data/models/task_model.dart';
import 'task_ai_context_engine.dart';
import 'task_ai_cluster_engine.dart';
import 'task_ai_pattern_engine.dart';
import 'task_ai_trend_engine.dart';
import 'task_ai_forecast_engine.dart';
import 'task_ai_anomaly_engine.dart';

/// TaskAIStateEngine produces a unified AI state object that merges:
/// - Context (energy, emotional, fatigue, workload, stress, burnout)
/// - Clusters (difficulty, stress, readiness, time sensitivity, quick wins)
/// - Patterns (avoidance, stuck tasks, momentum)
/// - Trends (emotional, fatigue, priority, completion, overdue)
/// - Forecasts (future emotional, fatigue, priority, burnout, productivity)
/// - Anomalies (spikes, outliers, imbalance)
///
/// This is the "brain snapshot" used by:
/// - Mode Engine
/// - Next Best Action Engine
/// - Dashboard intelligence
/// - Smart scheduling
/// - Adaptive recommendations
class TaskAIStateEngine {
  // Singleton
  static final TaskAIStateEngine instance =
      TaskAIStateEngine._internal();
  TaskAIStateEngine._internal();

  final _context = TaskAIContextEngine.instance;
  final _clusters = TaskAIClusterEngine.instance;
  final _patterns = TaskAIPatternEngine.instance;
  final _trends = TaskAITrendEngine.instance;
  final _forecast = TaskAIForecastEngine.instance;
  final _anomalies = TaskAIAnomalyEngine.instance;

  // -----------------------------
  // UNIFIED AI STATE
  // -----------------------------
  Map<String, dynamic> buildState(List<TaskModel> tasks) {
    return {
      "context": _context.contextPackage(tasks),
      "clusters": _clusters.clusterPackage(tasks),
      "patterns": _patterns.patternPackage(tasks),
      "trends": _trends.trendPackage(tasks),
      "forecast": _forecast.forecastPackage(tasks),
      "anomalies": _anomalies.anomalyPackage(tasks),
    };
  }

  // -----------------------------
  // STATE SUMMARY (HUMAN-READABLE)
  // -----------------------------
  String stateSummary(List<TaskModel> tasks) {
    final c = _context.contextPackage(tasks);
    final t = _trends.trendPackage(tasks);
    final f = _forecast.forecastPackage(tasks);
    final a = _anomalies.anomalyPackage(tasks);

    return """
CURRENT STATE
Energy: ${c["energy"].toStringAsFixed(1)}  
Emotional Bandwidth: ${c["emotional"].toStringAsFixed(1)}  
Fatigue: ${c["fatigue"].toStringAsFixed(1)}  
Stress: ${c["stress"].toStringAsFixed(1)}  
Burnout: ${c["burnout"].toStringAsFixed(1)}  

TRENDS
Emotional Trend: ${t["emotionalTrend"].toStringAsFixed(1)}  
Fatigue Trend: ${t["fatigueTrend"].toStringAsFixed(1)}  
Completion Rate: ${(t["completionRate"] * 100).toStringAsFixed(1)}%  
Overdue Rate: ${(t["overdueRate"] * 100).toStringAsFixed(1)}%  

FORECAST
Emotional Forecast: ${f["emotionalForecast"].toStringAsFixed(1)}  
Fatigue Forecast: ${f["fatigueForecast"].toStringAsFixed(1)}  
Burnout Forecast: ${f["burnoutForecast"].toStringAsFixed(1)}  
Productive Hour: ${f["productiveHour"]}:00  

ANOMALIES
Emotional Spikes: ${a["emotionalSpike"].length}  
Fatigue Spikes: ${a["fatigueSpike"].length}  
Overdue Anomalies: ${a["overdueAnomalies"].length}  
Outlier Tasks: ${a["outlierTasks"].length}  
""".trim();
  }
}
