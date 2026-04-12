import 'package:flutter/material.dart';

import '../task_facade.dart';
import '../models/task.dart';
import '../analytics/task_insights_engine.dart';
import '../logic/task_suggestions_engine.dart';

/// TaskNotificationsEngine generates:
/// - Reminders
/// - Overdue nudges
/// - Due-today alerts
/// - Daily briefings
/// - Mode-aware prompts
/// 
/// This is the logic layer only.
/// Delivery is handled by NotificationDispatcher (later).
class TaskNotificationsEngine {
  // Singleton
  static final TaskNotificationsEngine instance =
      TaskNotificationsEngine._internal();
  TaskNotificationsEngine._internal();

  final _facade = TaskFacade.instance;
  final _insights = TaskInsightsEngine.instance;
  final _suggest = TaskSuggestionsEngine.instance;

  // -----------------------------
  // OVERDUE NUDGES
  // -----------------------------
  List<String> overdueNudges(DateTime now) {
    final overdue = _facade.overdue(now);

    if (overdue.isEmpty) return [];

    return overdue.map((t) {
      return "“${t.title}” is overdue. Want to handle it now?";
    }).toList();
  }

  // -----------------------------
  // DUE TODAY ALERTS
  // -----------------------------
  List<String> dueTodayAlerts(DateTime now) {
    final today = _facade.today(now);

    return today.map((t) {
      return "“${t.title}” is due today.";
    }).toList();
  }

  // -----------------------------
  // NEXT BEST ACTION PROMPT
  // -----------------------------
  String? nextBestActionPrompt(DateTime now) {
    final next = _suggest.nextBestAction(_facade.all, now);
    if (next == null) return null;

    return "Next best action: ${next.title}";
  }

  // -----------------------------
  // DAILY BRIEFING
  // -----------------------------
  String dailyBriefing(DateTime now) {
    final insights = _insights.build(_facade.all, now);

    return """
Daily Briefing:
- Pressure: ${insights.pressureScore.toInt()}
- Relief: ${insights.reliefScore.toInt()}
- Overdue: ${insights.overdue}
- Due Today: ${insights.dueToday}
- High Priority: ${insights.highPriority}

You’ve got this. Want suggestions for where to start?
""";
  }

  // -----------------------------
  // END OF DAY WRAP-UP
  // -----------------------------
  String endOfDaySummary(DateTime now) {
    final completed = _facade.completed().length;
    final total = _facade.all.length;

    return """
End of Day Summary:
- Completed: $completed
- Total Tasks: $total

Would you like to plan tomorrow?
""";
  }

  // -----------------------------
  // MODE-AWARE PROMPTS
  // -----------------------------
  String? modePrompt(String mode, DateTime now) {
    switch (mode) {
      case "focus":
        return "You’re in Focus Mode. Want to tackle a high-priority task?";
      case "fatigue":
        return "You’re in Fatigue Mode. Want a low-energy suggestion?";
      case "recovery":
        return "You’re in Recovery Mode. A flexible task might feel good.";
      default:
        return null;
    }
  }
}
