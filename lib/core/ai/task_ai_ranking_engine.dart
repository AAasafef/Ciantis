import '../../data/models/task_model.dart';
import 'task_ai_scoring_engine.dart';

/// TaskAIRankingEngine ranks tasks using weighted AI scores.
/// This is used by:
/// - Mode Engine
/// - Next Best Action Engine
/// - Dashboard smart lists
/// - Calendar day recommendations
/// - Global search ranking
///
/// It transforms raw scores into ranked lists.
class TaskAIRankingEngine {
  // Singleton
  static final TaskAIRankingEngine instance =
      TaskAIRankingEngine._internal();
  TaskAIRankingEngine._internal();

  final _scoring = TaskAIScoringEngine.instance;

  // -----------------------------
  // BASIC RANKING (GLOBAL SCORE)
  // -----------------------------
  List<TaskModel> rankByGlobalScore(List<TaskModel> tasks) {
    final list = List<TaskModel>.from(tasks);

    list.sort((a, b) {
      final sa = _scoring.globalScore(a);
      final sb = _scoring.globalScore(b);
      return sb.compareTo(sa); // DESC
    });

    return list;
  }

  // -----------------------------
  // RANK BY DIFFICULTY
  // -----------------------------
  List<TaskModel> rankByDifficulty(List<TaskModel> tasks) {
    final list = List<TaskModel>.from(tasks);

    list.sort((a, b) {
      final sa = _scoring.difficulty(a);
      final sb = _scoring.difficulty(b);
      return sb.compareTo(sa);
    });

    return list;
  }

  // -----------------------------
  // RANK BY STRESS
  // -----------------------------
  List<TaskModel> rankByStress(List<TaskModel> tasks) {
    final list = List<TaskModel>.from(tasks);

    list.sort((a, b) {
      final sa = _scoring.stress(a);
      final sb = _scoring.stress(b);
      return sb.compareTo(sa);
    });

    return list;
  }

  // -----------------------------
  // RANK BY READINESS (ASC)
  // -----------------------------
  /// Lower readiness = harder to start
  /// Higher readiness = easier to start
  List<TaskModel> rankByReadiness(List<TaskModel> tasks) {
    final list = List<TaskModel>.from(tasks);

    list.sort((a, b) {
      final sa = _scoring.readiness(a);
      final sb = _scoring.readiness(b);
      return sb.compareTo(sa); // highest readiness first
    });

    return list;
  }

  // -----------------------------
  // RANK BY TIME SENSITIVITY
  // -----------------------------
  List<TaskModel> rankByTimeSensitivity(List<TaskModel> tasks) {
    final list = List<TaskModel>.from(tasks);

    list.sort((a, b) {
      final sa = _scoring.timeSensitivity(a);
      final sb = _scoring.timeSensitivity(b);
      return sb.compareTo(sa);
    });

    return list;
  }

  // -----------------------------
  // CONTEXT-AWARE RANKING
  // -----------------------------
  /// Context-aware ranking considers:
  /// - Time of day
  /// - Energy level
  /// - Emotional state
  /// - Fatigue
  ///
  /// This is the pre-AI version of the Mode Engine.
  List<TaskModel> rankWithContext({
    required List<TaskModel> tasks,
    required double energyLevel, // 0–10
    required double emotionalState, // 0–10
    required double fatigueLevel, // 0–10
  }) {
    final list = List<TaskModel>.from(tasks);

    list.sort((a, b) {
      final sa = _contextScore(a, energyLevel, emotionalState, fatigueLevel);
      final sb = _contextScore(b, energyLevel, emotionalState, fatigueLevel);
      return sb.compareTo(sa);
    });

    return list;
  }

  // -----------------------------
  // INTERNAL CONTEXT SCORE
  // -----------------------------
  double _contextScore(
    TaskModel task,
    double energy,
    double emotion,
    double fatigue,
  ) {
    final base = _scoring.globalScore(task);

    // If user has low energy, penalize high-fatigue tasks
    final fatiguePenalty = (10 - energy) * (task.fatigueImpact * 0.2);

    // If user is emotionally drained, penalize high-emotional tasks
    final emotionalPenalty =
        (10 - emotion) * (task.emotionalLoad * 0.2);

    // If user is fatigued, penalize difficulty
    final difficultyPenalty =
        fatigue * (_scoring.difficulty(task) * 0.05);

    return base - fatiguePenalty - emotionalPenalty - difficultyPenalty;
  }

  // -----------------------------
  // FULL RANKING PACKAGE
  // -----------------------------
  Map<String, List<TaskModel>> rankingPackage(List<TaskModel> tasks) {
    return {
      "global": rankByGlobalScore(tasks),
      "difficulty": rankByDifficulty(tasks),
      "stress": rankByStress(tasks),
      "readiness": rankByReadiness(tasks),
      "timeSensitivity": rankByTimeSensitivity(tasks),
    };
  }
}
