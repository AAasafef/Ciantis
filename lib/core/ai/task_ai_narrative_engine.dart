import '../../data/models/task_model.dart';
import 'task_ai_summary_engine.dart';
import 'task_ai_trend_engine.dart';
import 'task_ai_forecast_engine.dart';
import 'task_ai_anomaly_engine.dart';
import 'task_ai_scoring_engine.dart';

/// TaskAINarrativeEngine transforms AI data into natural-language narratives.
/// This engine is used by:
/// - Daily briefings
/// - Weekly reviews
/// - Mode Engine explanations
/// - Next Best Action Engine explanations
/// - Dashboard narrative panels
/// - Smart nudges
///
/// It produces:
/// - Emotional narratives
/// - Productivity narratives
/// - Burnout narratives
/// - Forecast narratives
/// - Task-specific narratives
/// - System-wide narratives
class TaskAINarrativeEngine {
  // Singleton
  static final TaskAINarrativeEngine instance =
      TaskAINarrativeEngine._internal();
  TaskAINarrativeEngine._internal();

  final _summary = TaskAISummaryEngine.instance;
  final _trends = TaskAITrendEngine.instance;
  final _forecast = TaskAIForecastEngine.instance;
  final _anomalies = TaskAIAnomalyEngine.instance;
  final _scoring = TaskAIScoringEngine.instance;

  // -----------------------------
  // TASK-SPECIFIC NARRATIVE
  // -----------------------------
  String taskNarrative(TaskModel task) {
    final s = _scoring.scores(task);

    final difficulty = s["difficulty"]!;
    final stress = s["stress"]!;
    final readiness = s["readiness"]!;
    final time = s["timeSensitivity"]!;
    final global = s["globalScore"]!;

    return """
This task carries a difficulty score of ${difficulty.toStringAsFixed(1)}, meaning it requires a moderate level of focus and emotional bandwidth. Its stress score of ${stress.toStringAsFixed(1)} suggests that it may weigh on you if left unattended.

Your readiness score of ${readiness.toStringAsFixed(1)} indicates how approachable this task feels right now. A time sensitivity score of ${time.toStringAsFixed(1)} shows how quickly it needs attention.

Overall, this task holds a global AI score of ${global.toStringAsFixed(1)}, placing it among the tasks most worth considering soon.
""".trim();
  }

  // -----------------------------
  // DAILY BRIEFING NARRATIVE
  // -----------------------------
  String dailyBriefing(List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return "You have no tasks scheduled today. This is a perfect moment to rest, reset, or plan ahead.";
    }

    final emotional = _trends.emotionalTrend(tasks);
    final fatigue = _trends.fatigueTrend(tasks);
    final overdue = _trends.overdueRate(tasks);
    final completion = _trends.completionRate(tasks);

    final productiveHour = _forecast.forecastProductiveHour(tasks);

    return """
Your task landscape today shows an emotional load averaging ${emotional.toStringAsFixed(1)}, with a fatigue impact around ${fatigue.toStringAsFixed(1)}. Your completion rate sits at ${(completion * 100).toStringAsFixed(1)}%, suggesting a steady pace.

${overdue > 0.2 ? "A noticeable portion of tasks are overdue — addressing a few of them may lighten your mental load." : "Overdue tasks are under control, giving you room to focus intentionally."}

Your most productive hour today is projected to be around $productiveHour:00. Consider scheduling your most demanding tasks during that window.
""".trim();
  }

  // -----------------------------
  // WEEKLY REVIEW NARRATIVE
  // -----------------------------
  String weeklyReview(List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return "You had a quiet week with no tasks recorded. This may have been a period of rest, transition, or focus elsewhere.";
    }

    final emotional = _trends.emotionalTrend(tasks);
    final fatigue = _trends.fatigueTrend(tasks);
    final priority = _trends.priorityTrend(tasks);
    final completion = _trends.completionRate(tasks);
    final burnout = _trends.burnoutTrend(tasks);

    return """
This week, your tasks reflected an emotional load averaging ${emotional.toStringAsFixed(1)} and a fatigue impact of ${fatigue.toStringAsFixed(1)}. Your priorities averaged ${priority.toStringAsFixed(1)}, showing where your attention naturally gravitated.

Your completion rate was ${(completion * 100).toStringAsFixed(1)}%, indicating your overall momentum. The burnout indicator sits at ${burnout.toStringAsFixed(1)}, offering a gentle reminder to balance effort with recovery.

Overall, your week shows a blend of effort, resilience, and progress — even if some tasks took longer than expected.
""".trim();
  }

  // -----------------------------
  // FORECAST NARRATIVE
  // -----------------------------
  String forecastNarrative(List<TaskModel> tasks) {
    final f = _forecast.forecastPackage(tasks);

    return """
Looking ahead, your emotional load is expected to trend toward ${f["emotionalForecast"]!.toStringAsFixed(1)}, while fatigue may rise slightly to ${f["fatigueForecast"]!.toStringAsFixed(1)}.

Your priority load is projected at ${f["priorityForecast"]!.toStringAsFixed(1)}, and your completion rate may shift toward ${(f["completionForecast"]! * 100).toStringAsFixed(1)}%.

Overdue risk for the next few days is estimated at ${(f["overdueForecast"]! * 100).toStringAsFixed(1)}%, and your burnout forecast sits at ${f["burnoutForecast"]!.toStringAsFixed(1)}.

Your most productive hour in the coming day is likely around ${f["productiveHour"]}:00.
""".trim();
  }

  // -----------------------------
  // ANOMALY NARRATIVE
  // -----------------------------
  String anomalyNarrative(List<TaskModel> tasks) {
    final a = _anomalies.anomalyPackage(tasks);

    final emotional = a["emotionalSpike"] as List<TaskModel>;
    final fatigue = a["fatigueSpike"] as List<TaskModel>;
    final overdue = a["overdueAnomalies"] as List<TaskModel>;
    final outliers = a["outlierTasks"] as List<TaskModel>;

    return """
Your task system shows a few notable anomalies:

• ${emotional.length} task(s) show unusually high emotional load.  
• ${fatigue.length} task(s) show unusually high fatigue impact.  
• ${overdue.length} task(s) are overdue and may need attention soon.  
• ${outliers.length} task(s) stand out as statistical outliers in difficulty or urgency.

These anomalies don’t indicate failure — they highlight where your system is signaling stress, imbalance, or opportunity.
""".trim();
  }

  // -----------------------------
  // FULL NARRATIVE PACKAGE
  // -----------------------------
  Map<String, String> narrativePackage({
    required TaskModel? task,
    required List<TaskModel> allTasks,
  }) {
    return {
      if (task != null) "taskNarrative": taskNarrative(task),
      "dailyBriefing": dailyBriefing(allTasks),
      "weeklyReview": weeklyReview(allTasks),
      "forecast": forecastNarrative(allTasks),
      "anomalies": anomalyNarrative(allTasks),
    };
  }
}
