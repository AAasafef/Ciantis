import '../../data/models/task_model.dart';
import 'task_ai_trend_engine.dart';
import 'task_ai_scoring_engine.dart';

/// TaskAIAnomalyEngine detects unusual or unexpected patterns in tasks.
/// This engine is used by:
/// - Mode Engine
/// - Next Best Action Engine
/// - Dashboard alerts
/// - Burnout prevention
/// - Smart nudges
///
/// It identifies:
/// - Emotional spikes
/// - Fatigue spikes
/// - Completion drops
/// - Overdue anomalies
/// - Category imbalance
/// - Tag imbalance
/// - Outlier tasks
/// - Behavioral anomalies
class TaskAIAnomalyEngine {
  // Singleton
  static final TaskAIAnomalyEngine instance =
      TaskAIAnomalyEngine._internal();
  TaskAIAnomalyEngine._internal();

  final _trend = TaskAITrendEngine.instance;
  final _scoring = TaskAIScoringEngine.instance;

  // -----------------------------
  // EMOTIONAL SPIKE DETECTION
  // -----------------------------
  List<TaskModel> emotionalSpike(List<TaskModel> tasks) {
    final avg = _trend.emotionalTrend(tasks);

    return tasks.where((t) {
      return t.emotionalLoad >= avg + 3;
    }).toList();
  }

  // -----------------------------
  // FATIGUE SPIKE DETECTION
  // -----------------------------
  List<TaskModel> fatigueSpike(List<TaskModel> tasks) {
    final avg = _trend.fatigueTrend(tasks);

    return tasks.where((t) {
      return t.fatigueImpact >= avg + 3;
    }).toList();
  }

  // -----------------------------
  // COMPLETION DROP DETECTION
  // -----------------------------
  bool completionDrop(List<TaskModel> tasks) {
    final rate = _trend.completionRate(tasks);
    return rate <= 0.25; // significant drop
  }

  // -----------------------------
  // OVERDUE ANOMALIES
  // -----------------------------
  List<TaskModel> overdueAnomalies(List<TaskModel> tasks) {
    final now = DateTime.now();

    return tasks.where((t) {
      if (t.dueDate == null) return false;
      return t.dueDate!.isBefore(now) && !t.isCompleted;
    }).toList();
  }

  // -----------------------------
  // CATEGORY IMBALANCE
  // -----------------------------
  /// Detects categories that dominate the task list.
  List<String> categoryImbalance(List<TaskModel> tasks) {
    final map = _trend.categoryTrend(tasks);
    final total = tasks.length;

    return map.entries
        .where((e) => e.value / total >= 0.4)
        .map((e) => e.key)
        .toList();
  }

  // -----------------------------
  // TAG IMBALANCE
  // -----------------------------
  List<String> tagImbalance(List<TaskModel> tasks) {
    final map = _trend.tagTrend(tasks);
    final total = tasks.length;

    return map.entries
        .where((e) => e.value / total >= 0.4)
        .map((e) => e.key)
        .toList();
  }

  // -----------------------------
  // OUTLIER TASKS (GLOBAL SCORE)
  // -----------------------------
  List<TaskModel> outlierTasks(List<TaskModel> tasks) {
    if (tasks.isEmpty) return [];

    final scores = tasks.map((t) => _scoring.globalScore(t)).toList();
    final avg = scores.reduce((a, b) => a + b) / scores.length;

    return tasks.where((t) {
      final s = _scoring.globalScore(t);
      return s >= avg + 5 || s <= avg - 5;
    }).toList();
  }

  // -----------------------------
  // MOMENTUM ANOMALIES
  // -----------------------------
  /// Tasks completed unusually fast.
  List<TaskModel> momentumAnomalies(List<TaskModel> tasks) {
    return tasks.where((t) {
      if (!t.isCompleted) return false;
      if (t.dueDate == null) return false;

      final diff = t.dueDate!.difference(t.createdAt).inHours;
      return diff > 0 && diff <= 6; // extremely fast completion
    }).toList();
  }

  // -----------------------------
  // BEHAVIORAL ANOMALIES
  // -----------------------------
  /// Tasks that contradict the user's usual patterns.
  List<TaskModel> behavioralAnomalies(List<TaskModel> tasks) {
    final emotionalAvg = _trend.emotionalTrend(tasks);
    final fatigueAvg = _trend.fatigueTrend(tasks);

    return tasks.where((t) {
      final emotionalOutlier = (t.emotionalLoad - emotionalAvg).abs() >= 4;
      final fatigueOutlier = (t.fatigueImpact - fatigueAvg).abs() >= 4;
      return emotionalOutlier || fatigueOutlier;
    }).toList();
  }

  // -----------------------------
  // FULL ANOMALY PACKAGE
  // -----------------------------
  Map<String, dynamic> anomalyPackage(List<TaskModel> tasks) {
    return {
      "emotionalSpike": emotionalSpike(tasks),
      "fatigueSpike": fatigueSpike(tasks),
      "completionDrop": completionDrop(tasks),
      "overdueAnomalies": overdueAnomalies(tasks),
      "categoryImbalance": categoryImbalance(tasks),
      "tagImbalance": tagImbalance(tasks),
      "outlierTasks": outlierTasks(tasks),
      "momentumAnomalies": momentumAnomalies(tasks),
      "behavioralAnomalies": behavioralAnomalies(tasks),
    };
  }
}
