import 'package:flutter/material.dart';

import '../task_facade.dart';
import '../analytics/task_insights_engine.dart';
import '../models/task.dart';

/// TaskReviewEngine generates:
/// - Daily reviews
/// - Weekly reviews
/// - Monthly reviews
///
/// These reviews combine:
/// - Insights
/// - Completion data
/// - Overdue patterns
/// - Priority + energy trends
/// - AI-style natural language summaries
class TaskReviewEngine {
  // Singleton
  static final TaskReviewEngine instance =
      TaskReviewEngine._internal();
  TaskReviewEngine._internal();

  final _facade = TaskFacade.instance;
  final _insights = TaskInsightsEngine.instance;

  // -----------------------------
  // DAILY REVIEW
  // -----------------------------
  String dailyReview(DateTime now) {
    final insights = _insights.build(_facade.all, now);
    final completed = _facade.completed();
    final overdue = _facade.overdue(now);
    final today = _facade.today(now);

    return """
Daily Review:

Completed: ${completed.length}
Overdue: ${overdue.length}
Due Today: ${today.length}

Pressure Score: ${insights.pressureScore.toInt()}
Relief Score: ${insights.reliefScore.toInt()}

Summary:
You made progress today. Your relief score suggests you handled a good portion of your workload. A few tasks slipped, but nothing unmanageable. Consider reviewing overdue items and planning tomorrow with intention.
""";
  }

  // -----------------------------
  // WEEKLY REVIEW
  // -----------------------------
  String weeklyReview(DateTime now) {
    final tasks = _facade.all;

    final completed = tasks.where((t) => t.isCompleted).length;
    final overdue = tasks.where((t) =>
        t.dueDate != null &&
        t.dueDate!.isBefore(now) &&
        !t.isCompleted).length;

    final highPriority = tasks.where((t) =>
        t.priority == TaskPriority.high).length;

    final insights = _insights.build(tasks, now);

    return """
Weekly Review:

Completed Tasks: $completed
Overdue Tasks: $overdue
High Priority Tasks: $highPriority

Pressure Score: ${insights.pressureScore.toInt()}
Relief Score: ${insights.reliefScore.toInt()}

Summary:
This week showed a mix of productivity and pressure. High-priority tasks may need more focused attention. Consider using Focus Mode next week to improve execution on important items.
""";
  }

  // -----------------------------
  // MONTHLY REVIEW
  // -----------------------------
  String monthlyReview(DateTime now) {
    final tasks = _facade.all;

    final completed = tasks.where((t) => t.isCompleted).length;
    final overdue = tasks.where((t) =>
        t.dueDate != null &&
        t.dueDate!.isBefore(now) &&
        !t.isCompleted).length;

    final insights = _insights.build(tasks, now);

    return """
Monthly Review:

Total Tasks: ${tasks.length}
Completed: $completed
Overdue: $overdue

Pressure Score: ${insights.pressureScore.toInt()}
Relief Score: ${insights.reliefScore.toInt()}

Summary:
Your month shows clear patterns in workload and energy. Consider adjusting your task distribution, reducing bottlenecks, and planning more flexible tasks during high-pressure weeks. You're building momentum — keep refining your system.
""";
  }
}
