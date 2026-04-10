import '../../data/models/task_model.dart';
import 'task_next_best_action_engine.dart';
import 'task_next_best_action_explanation_engine.dart';
import 'task_ai_state_engine.dart';
import 'task_ai_context_engine.dart';
import 'task_ai_opportunity_state_engine.dart';
import '../mode/task_mode_state_engine.dart';

/// TaskNextBestActionStateEngine produces a unified, UI-ready
/// "Next Best Action State" object.
///
/// It merges:
/// - Global NBA decision
/// - Mode state
/// - AI state
/// - Context
/// - Opportunity state
/// - Explanations
///
/// This is what dashboards, daily briefings, and smart nudges consume.
class TaskNextBestActionStateEngine {
  // Singleton
  static final TaskNextBestActionStateEngine instance =
      TaskNextBestActionStateEngine._internal();
  TaskNextBestActionStateEngine._internal();

  final _nba = TaskNextBestActionEngine.instance;
  final _nbaExplain = TaskNextBestActionExplanationEngine.instance;

  final _aiState = TaskAIStateEngine.instance;
  final _context = TaskAIContextEngine.instance;
  final _oppState = TaskAIOpportunityStateEngine.instance;
  final _modeState = TaskModeStateEngine.instance;

  // -----------------------------
  // BUILD NBA STATE
  // -----------------------------
  Map<String, dynamic> buildState(List<TaskModel> tasks) {
    final nba = _nba.nextBestAction(tasks);
    final task = nba["task"] as TaskModel?;

    return {
      "nextBestAction": nba,
      "task": task,
      "modeState": _modeState.buildState(tasks),
      "aiState": _aiState.buildState(tasks),
      "context": _context.contextPackage(tasks),
      "opportunityState": _oppState.buildState(tasks),
      "explanations": _nbaExplain.explanationPackage(tasks),
    };
  }

  // -----------------------------
  // HUMAN-READABLE SUMMARY
  // -----------------------------
  String stateSummary(List<TaskModel> tasks) {
    final state = buildState(tasks);
    final task = state["task"] as TaskModel?;

    if (task == null) {
      return "No Next Best Action is available right now.";
    }

    final ctx = state["context"] as Map<String, dynamic>;
    final nba = state["nextBestAction"] as Map<String, dynamic>;
    final mode = nba["mode"];

    return """
NEXT BEST ACTION SNAPSHOT

Task: ${task.title}
Active Mode: ${mode.name}

Energy: ${ctx["energy"].toStringAsFixed(1)}/10  
Emotional Bandwidth: ${ctx["emotional"].toStringAsFixed(1)}/10  
Fatigue: ${ctx["fatigue"].toStringAsFixed(1)}/10  

This is the single most aligned task given your current mode, context, and opportunity landscape.
""".trim();
  }
}
