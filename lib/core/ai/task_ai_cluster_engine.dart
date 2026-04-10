import '../../data/models/task_model.dart';
import 'task_ai_scoring_engine.dart';

/// TaskAIClusterEngine groups tasks into meaningful clusters using
/// AI scoring signals:
/// - difficulty
/// - stress
/// - readiness
/// - time sensitivity
/// - global score
///
/// These clusters are used by:
/// - Mode Engine
/// - Next Best Action Engine
/// - Dashboard smart grouping
/// - Calendar day clustering
/// - Heatmaps
class TaskAIClusterEngine {
  // Singleton
  static final TaskAIClusterEngine instance =
      TaskAIClusterEngine._internal();
  TaskAIClusterEngine._internal();

  final _scoring = TaskAIScoringEngine.instance;

  // -----------------------------
  // CLUSTER: HIGH DIFFICULTY
  // -----------------------------
  List<TaskModel> highDifficulty(List<TaskModel> tasks) {
    return tasks.where((t) {
      return _scoring.difficulty(t) >= 15;
    }).toList();
  }

  // -----------------------------
  // CLUSTER: HIGH STRESS
  // -----------------------------
  List<TaskModel> highStress(List<TaskModel> tasks) {
    return tasks.where((t) {
      return _scoring.stress(t) >= 10;
    }).toList();
  }

  // -----------------------------
  // CLUSTER: LOW READINESS
  // -----------------------------
  List<TaskModel> lowReadiness(List<TaskModel> tasks) {
    return tasks.where((t) {
      return _scoring.readiness(t) <= 3;
    }).toList();
  }

  // -----------------------------
  // CLUSTER: HIGH TIME SENSITIVITY
  // -----------------------------
  List<TaskModel> timeSensitive(List<TaskModel> tasks) {
    return tasks.where((t) {
      return _scoring.timeSensitivity(t) >= 5;
    }).toList();
  }

  // -----------------------------
  // CLUSTER: HIGH GLOBAL SCORE
  // -----------------------------
  List<TaskModel> highGlobalScore(List<TaskModel> tasks) {
    return tasks.where((t) {
      return _scoring.globalScore(t) >= 12;
    }).toList();
  }

  // -----------------------------
  // CLUSTER: ENERGY FRIENDLY
  // -----------------------------
  /// Tasks that are easy to start when energy is low.
  List<TaskModel> energyFriendly(List<TaskModel> tasks) {
    return tasks.where((t) {
      return _scoring.readiness(t) >= 7 &&
          t.fatigueImpact <= 4 &&
          t.emotionalLoad <= 4;
    }).toList();
  }

  // -----------------------------
  // CLUSTER: EMOTIONALLY HEAVY
  // -----------------------------
  List<TaskModel> emotionalHeavy(List<TaskModel> tasks) {
    return tasks.where((t) {
      return t.emotionalLoad >= 7;
    }).toList();
  }

  // -----------------------------
  // CLUSTER: FATIGUE HEAVY
  // -----------------------------
  List<TaskModel> fatigueHeavy(List<TaskModel> tasks) {
    return tasks.where((t) {
      return t.fatigueImpact >= 7;
    }).toList();
  }

  // -----------------------------
  // CLUSTER: QUICK WINS
  // -----------------------------
  /// Quick wins = high readiness + low difficulty + low stress
  List<TaskModel> quickWins(List<TaskModel> tasks) {
    return tasks.where((t) {
      final r = _scoring.readiness(t);
      final d = _scoring.difficulty(t);
      final s = _scoring.stress(t);
      return r >= 7 && d <= 10 && s <= 6;
    }).toList();
  }

  // -----------------------------
  // CLUSTER: OVERDUE OR NEAR-DUE
  // -----------------------------
  List<TaskModel> urgentTime(List<TaskModel> tasks) {
    return tasks.where((t) {
      return _scoring.timeSensitivity(t) >= 8;
    }).toList();
  }

  // -----------------------------
  // FULL CLUSTER PACKAGE
  // -----------------------------
  Map<String, List<TaskModel>> clusterPackage(List<TaskModel> tasks) {
    return {
      "highDifficulty": highDifficulty(tasks),
      "highStress": highStress(tasks),
      "lowReadiness": lowReadiness(tasks),
      "timeSensitive": timeSensitive(tasks),
      "highGlobalScore": highGlobalScore(tasks),
      "energyFriendly": energyFriendly(tasks),
      "emotionalHeavy": emotionalHeavy(tasks),
      "fatigueHeavy": fatigueHeavy(tasks),
      "quickWins": quickWins(tasks),
      "urgentTime": urgentTime(tasks),
    };
  }
}
