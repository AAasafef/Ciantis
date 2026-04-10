import '../../data/models/task_model.dart';

/// TaskAIScoringEngine converts task attributes into numerical scores.
/// These scores are used by:
/// - Mode Engine
/// - Next Best Action Engine
/// - Dashboard analytics
/// - Smart sorting
/// - Calendar predictions
///
/// This is the mathematical backbone of the AI system.
class TaskAIScoringEngine {
  // Singleton
  static final TaskAIScoringEngine instance =
      TaskAIScoringEngine._internal();
  TaskAIScoringEngine._internal();

  // -----------------------------
  // DIFFICULTY SCORE
  // -----------------------------
  /// Difficulty = (priority * 2) + emotionalLoad + fatigueImpact
  int difficulty(TaskModel task) {
    return (task.priority * 2) +
        task.emotionalLoad +
        task.fatigueImpact;
  }

  // -----------------------------
  // STRESS SCORE
  // -----------------------------
  /// Stress = emotionalLoad * 1.5 + overduePenalty
  double stress(TaskModel task) {
    double base = task.emotionalLoad * 1.5;

    if (task.dueDate == null) return base;

    final now = DateTime.now();
    final diff = task.dueDate!.difference(now).inHours;

    if (diff < 0) {
      return base + 10; // overdue
    }
    if (diff < 24) {
      return base + 5; // due soon
    }
    if (diff < 72) {
      return base + 2; // due in a few days
    }

    return base;
  }

  // -----------------------------
  // READINESS SCORE
  // -----------------------------
  /// Readiness = 10 - fatigueImpact - (emotionalLoad * 0.5)
  /// Higher = easier to start now
  double readiness(TaskModel task) {
    return 10 -
        task.fatigueImpact -
        (task.emotionalLoad * 0.5);
  }

  // -----------------------------
  // TIME SENSITIVITY SCORE
  // -----------------------------
  /// Time sensitivity = inverse of time remaining
  double timeSensitivity(TaskModel task) {
    if (task.dueDate == null) return 0;

    final now = DateTime.now();
    final diff = task.dueDate!.difference(now).inHours;

    if (diff <= 0) return 10; // overdue
    if (diff <= 24) return 8;
    if (diff <= 72) return 5;
    if (diff <= 168) return 3; // within a week

    return 1;
  }

  // -----------------------------
  // GLOBAL AI SCORE (WEIGHTED)
  // -----------------------------
  /// Global score = weighted composite of:
  /// - difficulty
  /// - stress
  /// - time sensitivity
  /// - inverse readiness
  ///
  /// Higher = more urgent/important for AI to surface
  double globalScore(TaskModel task) {
    final d = difficulty(task).toDouble();
    final s = stress(task);
    final t = timeSensitivity(task);
    final r = readiness(task);

    return (d * 0.3) + (s * 0.3) + (t * 0.3) + ((10 - r) * 0.1);
  }

  // -----------------------------
  // FULL SCORE PACKAGE
  // -----------------------------
  Map<String, double> scores(TaskModel task) {
    return {
      "difficulty": difficulty(task).toDouble(),
      "stress": stress(task),
      "readiness": readiness(task),
      "timeSensitivity": timeSensitivity(task),
      "globalScore": globalScore(task),
    };
  }

  // -----------------------------
  // BULK SCORE PACKAGE
  // -----------------------------
  Map<String, Map<String, double>> scoresForAll(
      List<TaskModel> tasks) {
    final Map<String, Map<String, double>> result = {};

    for (final t in tasks) {
      result[t.id] = scores(t);
    }

    return result;
  }
}
