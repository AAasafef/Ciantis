import 'package:flutter/material.dart';

import '../task_facade.dart';
import '../analytics/task_insights_engine.dart';
import '../models/task.dart';

/// TaskAnalyticsScreen provides visual insights into:
/// - Priority distribution
/// - Energy distribution
/// - Flexibility distribution
/// - Completion trends
/// - Overdue patterns
/// - Pressure + relief curves
///
/// This is the analytics layer of Tasks OS.
class TaskAnalyticsScreen extends StatelessWidget {
  const TaskAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final facade = TaskFacade.instance;
    final insights = TaskInsightsEngine.instance
        .build(facade.all, DateTime.now());

    final tasks = facade.all;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Task Analytics"),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionTitle("Priority Distribution"),
          _distributionChart(
            data: _countBy<TaskPriority>(
              tasks,
              (t) => t.priority,
            ),
            labels: TaskPriority.values.map((e) => e.name).toList(),
          ),

          const SizedBox(height: 30),

          _sectionTitle("Energy Distribution"),
          _distributionChart(
            data: _countBy<TaskEnergy>(
              tasks,
              (t) => t.energy,
            ),
            labels: TaskEnergy.values.map((e) => e.name).toList(),
          ),

          const SizedBox(height: 30),

          _sectionTitle("Flexibility Distribution"),
          _distributionChart(
            data: _countBy<TaskFlexibility>(
              tasks,
              (t) => t.flexibility,
            ),
            labels: TaskFlexibility.values.map((e) => e.name).toList(),
          ),

          const SizedBox(height: 30),

          _sectionTitle("Pressure & Relief"),
          _barChart({
            "Pressure": insights.pressureScore,
            "Relief": insights.reliefScore,
          }),

          const SizedBox(height: 30),

          _sectionTitle("Overdue vs Completed"),
          _barChart({
            "Completed": facade.completed().length.toDouble(),
            "Overdue": facade.overdue(DateTime.now()).length.toDouble(),
          }),
        ],
      ),
    );
  }

  // -----------------------------
  // SECTION TITLE
  // -----------------------------
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // -----------------------------
  // DISTRIBUTION CHART
  // -----------------------------
  Widget _distributionChart({
    required Map<String, int> data,
    required List<String> labels,
  }) {
    final maxValue = data.values.isEmpty
        ? 1
        : data.values.reduce((a, b) => a > b ? a : b);

    return Column(
      children: labels.map((label) {
        final value = data[label] ?? 0;
        final pct = value / maxValue;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
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
                  value: pct,
                  backgroundColor: Colors.white12,
                  color: Colors.tealAccent,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                value.toString(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // -----------------------------
  // BAR CHART (simple)
  // -----------------------------
  Widget _barChart(Map<String, double> data) {
    final maxValue = data.values.isEmpty
        ? 1
        : data.values.reduce((a, b) => a > b ? a : b);

    return Column(
      children: data.entries.map((entry) {
        final pct = entry.value / maxValue;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: LinearProgressIndicator(
                  value: pct,
                  backgroundColor: Colors.white12,
                  color: Colors.tealAccent,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                entry.value.toInt().toString(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // -----------------------------
  // COUNT BY PROPERTY
  // -----------------------------
  Map<String, int> _countBy<T>(
    List<Task> tasks,
    T Function(Task) selector,
  ) {
    final map = <String, int>{};

    for (final t in tasks) {
      final key = selector(t).toString().split('.').last;
      map[key] = (map[key] ?? 0) + 1;
    }

    return map;
  }
}
