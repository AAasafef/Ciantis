import '../../data/models/task_model.dart';
import '../ai/task_ai_scoring_engine.dart';
import '../ai/task_ai_context_engine.dart';
import '../ai/task_ai_opportunity_engine.dart';
import 'task_mode_activation_engine.dart';
import 'task_mode_filter_engine.dart';
import 'task_modes.dart';

/// TaskModeRankingEngine ranks tasks based on the active mode.
/// 
/// It uses:
/// - Mode strengths
/// - Mode weaknesses
/// - AI scoring (difficulty, stress, readiness, time sensitivity)
/// - Opportunity scoring
/// - Context alignment
///
/// This engine answers:
/// "Given the mode you're in, what should you do first?"
class TaskModeRankingEngine {
  // Singleton
  static final TaskModeRankingEngine instance =
      TaskModeRankingEngine._internal();
  TaskModeRankingEngine._internal();

  final _activation = TaskModeActivationEngine.instance;
  final _filter = TaskModeFilterEngine.instance;
  final _scoring = TaskAIScoringEngine.instance;
  final _context = TaskAIContextEngine.instance;
  final _opp = TaskAIOpportunityEngine.instance;

  // -----------------------------
  // MODE RANKING SCORE
  // -----------------------------
  double _modeScore(TaskModel task, TaskMode mode, List<TaskModel> allTasks) {
    final difficulty = _scoring.difficulty(task);
    final stress = _scoring.stress(task);
    final readiness = _scoring.readiness(task);
    final time = _scoring.timeSensitivity(task);
    final oppScore = _opp.opportunityScore(task, allTasks);

    final ctx = _context.contextPackage(allTasks);
    final energy = ctx["energy"];
    final emotional = ctx["emotional"];
    final fatigue = ctx["fatigue"];

    double score = 0;

    // -----------------------------
    // MODE-SPECIFIC WEIGHTING
    // -----------------------------
    switch (mode.id) {
      case "focus":
        score += readiness * 0.3;
        score += (10 - stress) * 0.2;
        score += (10 - emotional) * 0.2;
        score += (10 - fatigue) * 0.1;
        score += difficulty * 0.2;
        break;

      case "light":
        score += readiness * 0.4;
        score += (10 - difficulty) * 0.2;
        score += (10 - stress) * 0.2;
        score += (10 - emotional) * 0.2;
        break;

      case "power":
        score += readiness * 0.4;
        score += (10 - emotional) * 0.2;
        score += (10 - fatigue) * 0.2;
        score += (10 - difficulty) * 0.2;
        break;

      case "reset":
        score += (10 - stress) * 0.3;
        score += (10 - emotional) * 0.3;
        score += (10 - difficulty) * 0.2;
        score += readiness * 0.2;
        break;

      case "emotional":
        score += emotional * 0.4;
        score += readiness * 0.2;
        score += (10 - fatigue) * 0.2;
        score += (10 - difficulty) * 0.2;
        break;
    }

    // -----------------------------
    // OPPORTUNITY BOOST
    // -----------------------------
    score += oppScore * 0.3;

    return score;
  }

  // -----------------------------
  // RANK TASKS FOR ACTIVE MODE
  // -----------------------------
  List<TaskModel> rankForMode(List<TaskModel> tasks) {
    final mode = _activation.selectMode(tasks);
    final filtered = _filter.filterForMode(mode, tasks);

    final list = List<TaskModel>.from(filtered);

    list.sort((a, b) {
      final sa = _modeScore(a, mode, tasks);
      final sb = _modeScore(b, mode, tasks);
      return sb.compareTo(sa); // DESC
    });

    return list;
  }

  // -----------------------------
  // TOP TASK FOR ACTIVE MODE
  // -----------------------------
  TaskModel? topTask(List<TaskModel> tasks) {
    final ranked = rankForMode(tasks);
    return ranked.isNotEmpty ? ranked.first : null;
  }

  // -----------------------------
  // HUMAN-READABLE SUMMARY
  // -----------------------------
  String rankingSummary(List<TaskModel> tasks) {
    final mode = _activation.selectMode(tasks);
    final ranked = rankForMode(tasks);

    if (ranked.isEmpty) {
      return """
Active Mode: ${mode.name}
No tasks match this mode right now.
""".trim();
    }

    final top = ranked.first;

    return """
Active Mode: ${mode.name}
Top Task: ${top.title}

This task ranks highest because it aligns strongly with:
• Mode strengths
• Your current energy/emotional state
• Opportunity score
• Readiness and low resistance
• Mode-specific weighting
""".trim();
  }
}
