import '../../data/models/task_model.dart';
import 'task_next_best_action_engine.dart';
import 'task_ai_context_engine.dart';
import 'task_ai_state_engine.dart';
import 'task_ai_scoring_engine.dart';
import 'task_ai_opportunity_engine.dart';
import 'task_ai_opportunity_explanation_engine.dart';
import '../mode/task_mode_explanation_engine.dart';
import '../mode/task_mode_activation_engine.dart';
import '../mode/task_mode_ranking_engine.dart';

/// TaskNextBestActionExplanationEngine provides a full transparency layer
/// for the global Next Best Action decision.
///
/// It explains:
/// - Why this task was chosen
/// - Why this mode was chosen
/// - How the task aligns with context
/// - How the task aligns with opportunities
/// - How the task aligns with AI scoring
/// - Why other tasks were not chosen
///
/// This is the explanation engine for the entire NBA system.
class TaskNextBestActionExplanationEngine {
  // Singleton
  static final TaskNextBestActionExplanationEngine instance =
      TaskNextBestActionExplanationEngine._internal();
  TaskNextBestActionExplanationEngine._internal();

  final _nba = TaskNextBestActionEngine.instance;
  final _context = TaskAIContextEngine.instance;
  final _state = TaskAIStateEngine.instance;
  final _scoring = TaskAIScoringEngine.instance;
  final _opp = TaskAIOpportunityEngine.instance;
  final _oppExplain = TaskAIOpportunityExplanationEngine.instance;

  final _modeExplain = TaskModeExplanationEngine.instance;
  final _modeActivation = TaskModeActivationEngine.instance;
  final _modeRanking = TaskModeRankingEngine.instance;

  // -----------------------------
  // EXPLAIN WHY THIS TASK WAS CHOSEN
  // -----------------------------
  String explainWhyThisTask(TaskModel task, List<TaskModel> tasks) {
    final scores = _scoring.scores(task);
    final oppScore = _opp.opportunityScore(task, tasks);
    final ctx = _context.contextPackage(tasks);

    return """
**${task.title}** was selected as your Next Best Action because:

• It has a strong global score (${scores["globalScore"].toStringAsFixed(1)})  
• It has a high readiness score (${scores["readiness"].toStringAsFixed(1)})  
• It has a manageable emotional load (${task.emotionalLoad})  
• It has a manageable fatigue impact (${task.fatigueImpact})  
• It has a strong opportunity score (${oppScore.toStringAsFixed(1)})  
• It aligns with your current energy (${ctx["energy"].toStringAsFixed(1)})  
• It fits your emotional bandwidth (${ctx["emotional"].toStringAsFixed(1)})  
• It matches the strengths of your active mode  
""".trim();
  }

  // -----------------------------
  // EXPLAIN MODE ALIGNMENT
  // -----------------------------
  String explainModeAlignment(TaskModel task, List<TaskModel> tasks) {
    final mode = _modeActivation.selectMode(tasks);
    final ranked = _modeRanking.rankForMode(tasks);

    final rank = ranked.indexOf(task) + 1;

    return """
Mode Alignment:
• Active Mode: ${mode.name}
• This task ranks #$rank within your current mode
• It fits the mode’s strengths and avoids its weaknesses
""".trim();
  }

  // -----------------------------
  // EXPLAIN CONTEXT ALIGNMENT
  // -----------------------------
  String explainContextAlignment(TaskModel task, List<TaskModel> tasks) {
    final ctx = _context.contextPackage(tasks);

    final List<String> reasons = [];

    if (task.emotionalLoad <= ctx["emotional"] + 2) {
      reasons.add("It fits your emotional bandwidth.");
    }
    if (task.fatigueImpact <= ctx["fatigue"] + 2) {
      reasons.add("It matches your current fatigue level.");
    }
    if (_scoring.readiness(task) >= ctx["energy"] - 2) {
      reasons.add("It aligns with your current energy level.");
    }

    if (reasons.isEmpty) {
      return "This task reasonably aligns with your current state.";
    }

    return "Context Alignment:\n• ${reasons.join("\n• ")}";
  }

  // -----------------------------
  // EXPLAIN OPPORTUNITY ALIGNMENT
  // -----------------------------
  String explainOpportunityAlignment(TaskModel task, List<TaskModel> tasks) {
    final oppExplanation =
        _oppExplain.explanationPackage(task: task, allTasks: tasks);

    return """
Opportunity Alignment:
${oppExplanation["opportunityScore"]}

${oppExplanation["factors"]}

${oppExplanation["categories"]}
""".trim();
  }

  // -----------------------------
  // EXPLAIN WHY OTHER TASKS WERE NOT CHOSEN
  // -----------------------------
  String explainWhyNotOthers(TaskModel chosen, List<TaskModel> tasks) {
    final ranked = _modeRanking.rankForMode(tasks);

    final buffer = StringBuffer();

    buffer.writeln("Why other tasks were not chosen:");

    for (final t in ranked.take(5)) {
      if (t == chosen) continue;

      final readiness = _scoring.readiness(t);
      final emotional = t.emotionalLoad;
      final fatigue = t.fatigueImpact;
      final oppScore = _opp.opportunityScore(t, tasks);

      buffer.writeln("""
• ${t.title}
  - Readiness: ${readiness.toStringAsFixed(1)}
  - Emotional Load: $emotional
  - Fatigue Impact: $fatigue
  - Opportunity Score: ${oppScore.toStringAsFixed(1)}
""");
    }

    return buffer.toString().trim();
  }

  // -----------------------------
  // FULL EXPLANATION PACKAGE
  // -----------------------------
  Map<String, String> explanationPackage(List<TaskModel> tasks) {
    final nba = _nba.nextBestAction(tasks);
    final task = nba["task"] as TaskModel?;

    if (task == null) {
      return {
        "whyThisTask": "No task selected.",
        "modeAlignment": "",
        "contextAlignment": "",
        "opportunityAlignment": "",
        "whyNotOthers": "",
      };
    }

    return {
      "whyThisTask": explainWhyThisTask(task, tasks),
      "modeAlignment": explainModeAlignment(task, tasks),
      "contextAlignment": explainContextAlignment(task, tasks),
      "opportunityAlignment": explainOpportunityAlignment(task, tasks),
      "whyNotOthers": explainWhyNotOthers(task, tasks),
    };
  }
}
