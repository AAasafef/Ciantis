import '../../data/models/task_model.dart';

/// Generates heatmap‑ready data from tasks.
/// Supports multiple heatmap modes:
/// - Task count
/// - Emotional load
/// - Fatigue impact
/// - Urgency score
///
/// Used by:
/// - Calendar Month View
/// - Dashboard heatmaps
/// - Mode Engine daily energy predictions
/// - Next Best Action Engine
class TaskHeatmapGenerator {
  // Singleton
  static final TaskHeatmapGenerator instance =
      TaskHeatmapGenerator._internal();

  TaskHeatmapGenerator._internal();

  // -----------------------------
  // NORMALIZE DATE (midnight)
  // -----------------------------
  DateTime normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // -----------------------------
  // HEATMAP: TASK COUNT
  // -----------------------------
  Map<DateTime, int> taskCountHeatmap(List<TaskModel> tasks) {
    final Map<DateTime, int> map = {};

    for (final task in tasks) {
      if (task.dueDate == null) continue;

      final key = normalize(task.dueDate!);

      map[key] = (map[key] ?? 0) + 1;
    }

    return map;
  }

  // -----------------------------
  // HEATMAP: EMOTIONAL LOAD
  // -----------------------------
  Map<DateTime, int> emotionalHeatmap(List<TaskModel> tasks) {
    final Map<DateTime, int> map = {};

    for (final task in tasks) {
      if (task.dueDate == null) continue;

      final key = normalize(task.dueDate!);

      map[key] = (map[key] ?? 0) + task.emotionalLoad;
    }

    return map;
  }

  // -----------------------------
  // HEATMAP: FATIGUE IMPACT
  // -----------------------------
  Map<DateTime, int> fatigueHeatmap(List<TaskModel> tasks) {
    final Map<DateTime, int> map = {};

    for (final task in tasks) {
      if (task.dueDate == null) continue;

      final key = normalize(task.dueDate!);

      map[key] = (map[key] ?? 0) + task.fatigueImpact;
    }

    return map;
  }

  // -----------------------------
  // HEATMAP: URGENCY SCORE
  // -----------------------------
  Map<DateTime, int> urgencyHeatmap(List<TaskModel> tasks) {
    final Map<DateTime, int> map = {};

    for (final task in tasks) {
      if (task.dueDate == null) continue;

      final key = normalize(task.dueDate!);

      map[key] = (map[key] ?? 0) + task.urgencyScore;
    }

    return map;
  }

  // -----------------------------
  // FULL HEATMAP PACKAGE
  // -----------------------------
  Map<String, Map<DateTime, int>> buildHeatmapPackage(
      List<TaskModel> tasks) {
    return {
      "taskCount": taskCountHeatmap(tasks),
      "emotionalLoad": emotionalHeatmap(tasks),
      "fatigueImpact": fatigueHeatmap(tasks),
      "urgencyScore": urgencyHeatmap(tasks),
    };
  }
}
