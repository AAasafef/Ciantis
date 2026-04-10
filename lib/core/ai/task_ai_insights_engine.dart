import '../../data/models/task_model.dart';

/// TaskAIInsightsEngine generates lightweight, heuristic-based insights.
/// This is the foundation for the full AI Mode Engine and NBA Engine.
///
/// It provides:
/// - Priority insights
/// - Emotional load warnings
/// - Fatigue impact warnings
/// - Overdue risk detection
/// - Suggestion generation
/// - Next-best-action hints (pre-AI)
///
/// This engine is intentionally simple.
/// Later, the full AI engine will replace or extend this.
class TaskAIInsightsEngine {
  // Singleton
  static final TaskAIInsightsEngine instance =
      TaskAIInsightsEngine._internal();
  TaskAIInsightsEngine._internal();

  // -----------------------------
  // PRIORITY INSIGHT
  // -----------------------------
  String priorityInsight(TaskModel task) {
    if (task.priority >= 4) {
      return "This task is high priority and should be addressed soon.";
    }
    if (task.priority == 3) {
      return "This task has moderate priority.";
    }
    return "This task is low priority and can be scheduled flexibly.";
  }

  // -----------------------------
  // EMOTIONAL LOAD INSIGHT
  // -----------------------------
  String emotionalInsight(TaskModel task) {
    if (task.emotionalLoad >= 8) {
      return "This task carries a heavy emotional load. Consider pairing it with a lighter task.";
    }
    if (task.emotionalLoad >= 5) {
      return "This task may require emotional focus.";
    }
    return "This task has a low emotional load.";
  }

  // -----------------------------
  // FATIGUE IMPACT INSIGHT
  // -----------------------------
  String fatigueInsight(TaskModel task) {
    if (task.fatigueImpact >= 8) {
      return "This task is physically or mentally draining. Schedule it when your energy is highest.";
    }
    if (task.fatigueImpact >= 5) {
      return "This task requires moderate energy.";
    }
    return "This task has low fatigue impact.";
  }

  // -----------------------------
  // OVERDUE RISK
  // -----------------------------
  String overdueRisk(TaskModel task) {
    if (task.dueDate == null) return "No due date set.";

    final now = DateTime.now();
    final diff = task.dueDate!.difference(now).inHours;

    if (diff < 0) {
      return "This task is overdue.";
    }
    if (diff < 24) {
      return "This task is due soon — consider completing it today.";
    }
    if (diff < 72) {
      return "This task is due in the next few days.";
    }
    return "This task has plenty of time remaining.";
  }

  // -----------------------------
  // NEXT BEST ACTION (HEURISTIC)
  // -----------------------------
  String nextBestAction(TaskModel task) {
    if (task.isCompleted) {
      return "This task is already completed.";
    }

    if (task.priority >= 4 && task.dueDate != null) {
      return "Start this task soon — it is both high priority and time-sensitive.";
    }

    if (task.emotionalLoad >= 7) {
      return "Prepare mentally before starting this task.";
    }

    if (task.fatigueImpact >= 7) {
      return "Schedule this task when your energy is highest.";
    }

    return "This task can be completed at your convenience.";
  }

  // -----------------------------
  // FULL INSIGHT PACKAGE
  // -----------------------------
  Map<String, String> insightsFor(TaskModel task) {
    return {
      "priority": priorityInsight(task),
      "emotional": emotionalInsight(task),
      "fatigue": fatigueInsight(task),
      "overdueRisk": overdueRisk(task),
      "nextBestAction": nextBestAction(task),
    };
  }

  // -----------------------------
  // BULK INSIGHTS
  // -----------------------------
  Map<String, Map<String, String>> insightsForAll(
      List<TaskModel> tasks) {
    final Map<String, Map<String, String>> result = {};

    for (final t in tasks) {
      result[t.id] = insightsFor(t);
    }

    return result;
  }
}
