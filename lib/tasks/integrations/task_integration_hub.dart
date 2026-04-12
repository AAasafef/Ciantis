import 'package:flutter/material.dart';

import '../task_facade.dart';
import '../models/task.dart';
import '../logic/task_suggestions_engine.dart';
import '../logic/task_scheduling_engine.dart';
import '../analytics/task_insights_engine.dart';
import '../notifications/task_notifications_engine.dart';

/// TaskIntegrationHub connects:
/// - Tasks OS
/// - Calendar OS
/// - Mode Engine
/// - Adaptive Intelligence Layer
///
/// This is the central integration point for cross-module behavior.
class TaskIntegrationHub {
  // Singleton
  static final TaskIntegrationHub instance =
      TaskIntegrationHub._internal();
  TaskIntegrationHub._internal();

  final _tasks = TaskFacade.instance;
  final _suggest = TaskSuggestionsEngine.instance;
  final _schedule = TaskSchedulingEngine.instance;
  final _insights = TaskInsightsEngine.instance;
  final _notify = TaskNotificationsEngine.instance;

  // -----------------------------
  // NEXT BEST ACTION (mode-aware)
  // -----------------------------
  Task? nextBestAction({
    required DateTime now,
    String? mode,
  }) {
    if (mode != null) {
      return _suggest.modeAwareSuggestions(
        tasks: _tasks.all,
        now: now,
        mode: mode,
      ).firstOrNull;
    }

    return _suggest.nextBestAction(_tasks.all, now);
  }

  // -----------------------------
  // AUTO-SCHEDULE INTO CALENDAR
  // -----------------------------
  List<Task> autoSchedule(DateTime day) {
    return _schedule.scheduleTasks(_tasks.all, day);
  }

  // -----------------------------
  // DAILY BRIEFING (tasks + insights)
  // -----------------------------
  String dailyBriefing(DateTime now) {
    final insights = _insights.build(_tasks.all, now);
    final overdue = _tasks.overdue(now).length;
    final dueToday = _tasks.today(now).length;

    return """
Tasks Overview:
- Pressure: ${insights.pressureScore.toInt()}
- Relief: ${insights.reliefScore.toInt()}
- Overdue: $overdue
- Due Today: $dueToday

${_notify.dailyBriefing(now)}
""";
  }

  // -----------------------------
  // MODE-AWARE PROMPT
  // -----------------------------
  String? modePrompt(String mode, DateTime now) {
    return _notify.modePrompt(mode, now);
  }

  // -----------------------------
  // CALENDAR ↔ TASKS SYNC (placeholder)
  // -----------------------------
  void syncWithCalendar() {
    // Future: convert tasks to events, sync schedules, etc.
    // Placeholder for now.
  }
}

extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
