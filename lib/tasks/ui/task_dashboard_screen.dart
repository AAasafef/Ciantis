import 'package:flutter/material.dart';

import '../task_facade.dart';
import '../analytics/task_insights_engine.dart';
import 'quick_add_task_bar.dart';
import 'smart_suggestions_panel.dart';
import 'task_list_screen.dart';
import 'daily_planning_screen.dart';

/// TaskDashboardScreen is the high-level overview of Tasks OS.
/// It shows:
/// - Insights
/// - Quick Add
/// - Smart Suggestions
/// - Navigation to deeper views
class TaskDashboardScreen extends StatelessWidget {
  const TaskDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final facade = TaskFacade.instance;
    final insights = TaskInsightsEngine.instance
        .build(facade.all, DateTime.now());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Tasks Dashboard"),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // QUICK ADD
          const QuickAddTaskBar(),
          const SizedBox(height: 30),

          // INSIGHTS CARD
          _insightsCard(insights),
          const SizedBox(height: 30),

          // SMART SUGGESTIONS
          const SmartSuggestionsPanel(),
          const SizedBox(height: 30),

          // NAVIGATION
          _navButton(
            context,
            label: "Plan My Day",
            icon: Icons.auto_awesome,
            screen: const DailyPlanningScreen(),
          ),
          const SizedBox(height: 12),

          _navButton(
            context,
            label: "All Tasks",
            icon: Icons.list,
            screen: const TaskListScreen(),
          ),
          const SizedBox(height: 12),

          _navButton(
            context,
            label: "Starred",
            icon: Icons.star,
            screen: _FilteredTasksScreen(
              title: "Starred Tasks",
              filter: (t) => t.isStarred,
            ),
          ),
          const SizedBox(height: 12),

          _navButton(
            context,
            label: "Overdue",
            icon: Icons.warning_amber_rounded,
            screen: _FilteredTasksScreen(
              title: "Overdue Tasks",
              filter: (t) =>
                  t.dueDate != null &&
                  t.dueDate!.isBefore(DateTime.now()) &&
                  !t.isCompleted,
            ),
          ),
          const SizedBox(height: 12),

          _navButton(
            context,
            label: "Low Energy",
            icon: Icons.battery_saver,
            screen: _FilteredTasksScreen(
              title: "Low Energy Tasks",
              filter: (t) => t.energy == TaskEnergy.low,
            ),
          ),
          const SizedBox(height: 12),

          _navButton(
            context,
            label: "Flexible Tasks",
            icon: Icons.air,
            screen: _FilteredTasksScreen(
              title: "Flexible Tasks",
              filter: (t) =>
                  t.flexibility == TaskFlexibility.flexible,
            ),
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
            "Overview",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          _row("Pressure", insights.pressureScore),
          _row("Relief", insights.reliefScore),
          _row("Overdue", insights.overdue.toDouble()),
          _row("Due Today", insights.dueToday.toDouble()),
          _row("High Priority", insights.highPriority.toDouble()),
        ],
      ),
    );
  }

  Widget _row(String label, double value) {
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

  // -----------------------------
  // NAV BUTTON
  // -----------------------------
  Widget _navButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Widget screen,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.tealAccent),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}

/// A simple filtered list screen used by the dashboard.
class _FilteredTasksScreen extends StatelessWidget {
  final String title;
  final bool Function(Task) filter;

  const _FilteredTasksScreen({
    required this.title,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    final facade = TaskFacade.instance;
    final tasks = facade.all.where(filter).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: tasks.map((t) => TaskTile(task: t)).toList(),
      ),
    );
  }
}
