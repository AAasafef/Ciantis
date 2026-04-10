import '../../data/models/task_model.dart';
import 'task_ai_state_engine.dart';
import 'task_ai_context_engine.dart';
import 'task_ai_scoring_engine.dart';
import 'task_ai_opportunity_engine.dart';
import 'task_ai_opportunity_state_engine.dart';
import 'task_ai_explanation_engine.dart';
import 'task_ai_opportunity_explanation_engine.dart';
import '../mode/task_mode_decision_engine.dart';
import '../mode/task_mode_state_engine.dart';

/// TaskNextBestActionEngine is the global orchestrator that decides:
/// "Out of everything, what is the single best task to do next?"
///
/// It merges:
/// - Mode Decision (mode-level NBA)
/// - AI State
/// - Context
/// - Opportunities
/// - Scoring
/// - Explanations
///
/// Output: a single, structured Next Best Action object.
class TaskNextBestActionEngine {
  // Singleton
  static final TaskNextBestActionEngine instance =
      TaskNextBestActionEngine._internal();
  TaskNextBestActionEngine._internal();

  final _state = TaskAIStateEngine.instance;
  final _context = TaskAIContextEngine.instance;
  final _scoring = TaskAIScoringEngine.instance;
  final _opp = TaskAIOpportunityEngine.instance;
  final _oppState = TaskAIOpportunityStateEngine.instance;
  final _explain = TaskAIExplanationEngine.instance;
  final _oppExplain = TaskAIOpportunityExplanationEngine.instance;

  final _modeDecision = TaskModeDecisionEngine.instance;
  final _modeState = TaskModeStateEngine.instance;

  // -----------------------------
  // GLOBAL NEXT BEST ACTION
  // -----------------------------
  Map<String, dynamic> nextBestAction(List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return {
        "task": null,
        "reason": "No tasks available.",
      };
    }

    // Mode-level decision
    final modeDecision = _modeDecision.nextBestAction(tasks);
    final modeTopTask = modeDecision["topTask"] as TaskModel?;

    // If mode has a clear top task, we treat that as primary candidate.
    final TaskModel? candidate = modeTopTask;

    if (candidate == null) {
      return {
        "task": null,
        "reason":
            "No suitable task could be identified in your current mode and context.",
      };
    }

    final ctx = _context.contextPackage(tasks);
    final aiState = _state.buildState(tasks);
    final oppState = _oppState.buildState(tasks);

    final scores = _scoring.scores(candidate);
    final oppScore = _opp.opportunityScore(candidate, tasks);

    final explanation = _explain.explanationPackage(
      task: candidate,
      allTasks: tasks,
    );

    final oppExplanation = _oppExplain.explanationPackage(
      task: candidate,
      allTasks: tasks,
    );

    final modeState = _modeState.buildState(tasks);

    return {
      "task": candidate,
      "mode": modeDecision["mode"],
      "scores": {
        "global": scores["globalScore"],
        "difficulty": scores["difficulty"],
        "stress": scores["stress"],
        "readiness": scores["readiness"],
        "timeSensitivity": scores["timeSensitivity"],
        "opportunity": oppScore,
      },
      "context": ctx,
      "aiState": aiState,
      "opportunityState": oppState,
      "modeState": modeState,
      "explanations": {
        "taskAI": explanation,
        "opportunity": oppExplanation,
        "mode": modeDecision["modeExplanations"],
      },
    };
  }

  // -----------------------------
  // HUMAN-READABLE SUMMARY
  // -----------------------------
  String nextBestActionSummary(List<TaskModel> tasks) {
    final nba = nextBestAction(tasks);
    final task = nba["task"] as TaskModel?;

    if (task == null) {
      return nba["reason"] as String;
    }

    final mode = nba["mode"];
    final scores = nba["scores"] as Map<String, dynamic>;
    final ctx = nba["context"] as Map<String, dynamic>;

    return """
Next Best Action: ${task.title}

Active Mode: ${mode.name}
Global Score: ${scores["global"]!.toStringAsFixed(1)}
Opportunity Score: ${scores["opportunity"]!.toStringAsFixed(1)}

Context:
• Energy: ${ctx["energy"].toStringAsFixed(1)}/10  
• Emotional Bandwidth: ${ctx["emotional"].toStringAsFixed(1)}/10  
• Fatigue: ${ctx["fatigue"].toStringAsFixed(1)}/10  

This task is the most aligned with your current state, mode, and opportunity landscape.
""".trim();
  }
}
