import '../../data/models/task_model.dart';
import '../ai/task_ai_context_engine.dart';
import '../ai/task_ai_state_engine.dart';
import '../ai/task_ai_opportunity_engine.dart';
import '../ai/task_ai_scoring_engine.dart';
import 'task_mode_activation_engine.dart';
import 'task_mode_filter_engine.dart';
import 'task_mode_ranking_engine.dart';
import 'task_modes.dart';

/// TaskModeExplanationEngine explains WHY:
/// - A mode was selected
/// - Tasks were filtered
/// - Tasks were ranked
/// - A top task was chosen
///
/// This is the transparency layer of the Mode Engine.
class TaskModeExplanationEngine {
  // Singleton
  static final TaskModeExplanationEngine instance =
      TaskModeExplanationEngine._internal();
  TaskModeExplanationEngine._internal();

  final _activation = TaskModeActivationEngine.instance;
  final _filter = TaskModeFilterEngine.instance;
  final _ranking = TaskModeRankingEngine.instance;
  final _context = TaskAIContextEngine.instance;
  final _state = TaskAIStateEngine.instance;
  final _opp = TaskAIOpportunityEngine.instance;
  final _scoring = TaskAIScoringEngine.instance;

  // -----------------------------
  // EXPLAIN MODE SELECTION
  // -----------------------------
  String explainModeSelection(List<TaskModel> tasks) {
    final mode = _activation.selectMode(tasks);
    final ctx = _context.contextPackage(tasks);

    final buffer = StringBuffer();

    buffer.writeln("The system selected **${mode.name}** because:");

    final rules = mode.activationRules;

    if (rules.containsKey("energyMin")) {
      buffer.writeln(
          "• Your energy (${ctx["energy"].toStringAsFixed(1)}) meets the minimum requirement (${rules["energyMin"]}).");
    }
    if (rules.containsKey("energyMax")) {
      buffer.writeln(
          "• Your energy (${ctx["energy"].toStringAsFixed(1)}) is below the maximum allowed (${rules["energyMax"]}).");
    }

    if (rules.containsKey("fatigueMax")) {
      buffer.writeln(
          "• Your fatigue (${ctx["fatigue"].toStringAsFixed(1)}) is low enough for this mode.");
    }

    if (rules.containsKey("emotionalMin")) {
      buffer.writeln(
          "• Your emotional bandwidth (${ctx["emotional"].toStringAsFixed(1)}) is high enough for this mode.");
    }
    if (rules.containsKey("emotionalMax")) {
      buffer.writeln(
          "• Your emotional load (${ctx["emotional"].toStringAsFixed(1)}) is within the safe range for this mode.");
    }

    if (rules.containsKey("stressMin")) {
      buffer.writeln(
          "• Your stress level (${ctx["stress"].toStringAsFixed(1)}) indicates a need for this mode.");
    }

    if (rules.containsKey("burnoutMin")) {
      buffer.writeln(
          "• Your burnout indicator (${ctx["burnout"].toStringAsFixed(1)}) suggests this mode is restorative.");
    }

    return buffer.toString().trim();
  }

  // -----------------------------
  // EXPLAIN FILTERING
  // -----------------------------
  String explainFiltering(List<TaskModel> tasks) {
    final mode = _activation.selectMode(tasks);
    final filtered = _filter.filterForMode(mode, tasks);

    return """
${filtered.length} out of ${tasks.length} tasks were included because they match:

• Mode strengths  
• Emotional load requirements  
• Fatigue requirements  
• Difficulty constraints  
• Stress constraints  
• Time-sensitivity constraints  

Tasks outside these boundaries were excluded to keep the mode aligned with your current state.
""".trim();
  }

  // -----------------------------
  // EXPLAIN RANKING
  // -----------------------------
  String explainRanking(List<TaskModel> tasks) {
    final mode = _activation.selectMode(tasks);
    final ranked = _ranking.rankForMode(tasks);

    if (ranked.isEmpty) {
      return "No tasks were eligible for ranking in this mode.";
    }

    final top = ranked.first;

    final difficulty = _scoring.difficulty(top);
    final readiness = _scoring.readiness(top);
    final stress = _scoring.stress(top);
    final oppScore = _opp.opportunityScore(top, tasks);

    return """
The top-ranked task is **${top.title}** because:

• Readiness score: ${readiness.toStringAsFixed(1)}  
• Difficulty alignment: ${difficulty.toStringAsFixed(1)}  
• Stress alignment: ${stress.toStringAsFixed(1)}  
• Opportunity score: ${oppScore.toStringAsFixed(1)}  

This task fits the strengths of **${mode.name}** and aligns with your current energy, emotional bandwidth, and fatigue levels.
""".trim();
  }

  // -----------------------------
  // EXPLAIN TOP TASK
  // -----------------------------
  String explainTopTask(List<TaskModel> tasks) {
    final ranked = _ranking.rankForMode(tasks);

    if (ranked.isEmpty) {
      return "There is no top task for this mode at the moment.";
    }

    final top = ranked.first;

    final readiness = _scoring.readiness(top);
    final emotional = top.emotionalLoad;
    final fatigue = top.fatigueImpact;
    final oppScore = _opp.opportunityScore(top, tasks);

    return """
**${top.title}** is the best task for you right now because:

• It has high readiness (${readiness.toStringAsFixed(1)})  
• It has manageable emotional load (${emotional})  
• It has manageable fatigue impact (${fatigue})  
• It has a strong opportunity score (${oppScore.toStringAsFixed(1)})  

This task should feel aligned, approachable, and productive in your current mode.
""".trim();
  }

  // -----------------------------
  // FULL EXPLANATION PACKAGE
  // -----------------------------
  Map<String, String> explanationPackage(List<TaskModel> tasks) {
    return {
      "modeSelection": explainModeSelection(tasks),
      "filtering": explainFiltering(tasks),
      "ranking": explainRanking(tasks),
      "topTask": explainTopTask(tasks),
    };
  }
}
