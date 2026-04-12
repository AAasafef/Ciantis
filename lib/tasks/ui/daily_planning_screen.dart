import 'package:flutter/material.dart';

import '../task_facade.dart';
import '../models/task.dart';
import '../analytics/task_insights_engine.dart';
import '../logic/task_suggestions_engine.dart';
import '../logic/task_scheduling_engine.dart';
import 'task_tile.dart';

/// DailyPlanningScreen is the intelligent planning interface.
/// It shows:
/// - Insights (pressure, relief)
/// - Suggestions
/// - Today’s tasks
/// - Auto-scheduling actions
class DailyPlanningScreen extends StatelessWidget {
  const DailyPlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final facade = TaskFacade.instance;
    final insightsEngine = TaskInsightsEngine.instance;
    final suggest = TaskSuggestionsEngine.instance;
    final schedule = TaskSchedulingEngine.instance;

    final now = DateTime.now();
    final insights = insightsEngine.build(facade.all, now);
    final suggestions = suggest.suggestions(facade.all, now);
    final todayTasks = facade.today(now);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Plan My Day"),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // INSIGHTS PANEL
          _insightsCard(insights),

          const SizedBox(height: 30),

          // SUGGESTIONS
          const Text(
            "Suggestions",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          if (suggestions.isEmpty)
            const Text(
              "No suggestions right now",
              style: TextStyle(color: Colors.white38),
            )
          else
            Column(
              children: suggestions
                  .map((t) => TaskTile(task: t))
                  .toList(),
            ),

          const SizedBox(height: 30),

          // TODAY TASKS
          const Text(
            "Today",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          if (todayTasks.isEmpty)
            const Text(
              "No tasks scheduled for today",
              style: TextStyle(color: Colors.white38),
            )
          else
            Column(
              children: todayTasks
                  .map((t) => TaskTile(task: t))
                  .toList(),
            ),

          const SizedBox(height: 30),

          // AUTO-SCHEDULE BUTTON
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent.withOpacity(0.2),
              foregroundColor: Colors.tealAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              final results = schedule.scheduleTasks(
                facade.all,
                DateTime(now.year, now.month, now.day),
              );

              // ignore: avoid_print
              print("[DAILY PLANNING] Auto-scheduled: $results");

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Tasks auto-scheduled"),
                ),
              );
            },
            child: const Text("Auto-Schedule Tasks"),
          ),
        ],
      ),
    );
  }

  // -----------------------------
  // INSIGHTS CARD
  // -----------------------------
  Widget _insightsCard(TaskInsights insights) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today’s Insights",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          _insightRow("Pressure", insights.pressureScore),
          _insightRow("Relief", insights.reliefScore),
          _insightRow("Overdue", insights.overdue.toDouble()),
          _insightRow("Due Today", insights.dueToday.toDouble()),
          _insightRow("High Priority", insights.highPriority.toDouble()),
        ],
      ),
    );
  }

  Widget _insightRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: (value / 100).clamp(0, 1),
              backgroundColor: Colors.white12,
              color: Colors.tealAccent,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value.toInt().toString(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
