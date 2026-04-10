import '../../data/models/task_model.dart';
import '../ai/task_ai_state_engine.dart';
import '../ai/task_ai_context_engine.dart';
import '../ai/task_ai_opportunity_engine.dart';
import 'task_mode_activation_engine.dart';
import 'task_mode_filter_engine.dart';
import 'task_mode_ranking_engine.dart';
import 'task_mode_narrative_engine.dart';
import 'task_mode_explanation_engine.dart';
import 'task_modes.dart';

/// TaskModeStateEngine produces a unified "Mode State" object that merges:
/// - Active mode
/// - Mode filtering
/// - Mode ranking
/// - Mode narratives
/// - Mode explanations
/// - Context
/// - AI state
/// - Opportunities
///
/// This is the central object used by:
/// - Dashboard Mode Panel
/// - Daily Briefings
/// - Next Best Action Engine
/// - Smart Nudges
class TaskModeStateEngine {
  // Singleton
  static final TaskModeStateEngine instance =
      TaskModeStateEngine._internal();
  TaskModeStateEngine._internal();

  final _activation = TaskModeActivationEngine.instance;
  final _filter = TaskModeFilterEngine.instance;
  final _ranking = TaskModeRankingEngine.instance;
  final _narrative = TaskModeNarrativeEngine.instance;
  final _explain = TaskModeExplanationEngine.instance;
  final _context = TaskAIContextEngine.instance;
  final _state = TaskAIStateEngine.instance;
  final _opp = TaskAIOpportunityEngine.instance;

  // -----------------------------
  // BUILD MODE STATE
  // -----------------------------
  Map<String, dynamic> buildState(List<TaskModel> tasks) {
    final mode = _activation.selectMode(tasks);
    final filtered = _filter.filterForMode(mode, tasks);
    final ranked = _ranking.rankForMode(tasks);
    final top = ranked.isNotEmpty ? ranked.first : null;

    return {
      "mode": mode,
      "context": _context.contextPackage(tasks),
      "aiState": _state.buildState(tasks),
      "opportunities": _opp.opportunityPackage(tasks),

      "filteredTasks": filtered,
      "rankedTasks": ranked,
      "topTask": top,

      "narratives": _narrative.modeNarrativePackage(tasks),
      "explanations": _explain.explanationPackage(tasks),
    };
  }

  // -----------------------------
  // HUMAN-READABLE SUMMARY
  // -----------------------------
  String stateSummary(List<TaskModel> tasks) {
    final mode = _activation.selectMode(tasks);
    final ranked = _ranking.rankForMode(tasks);
    final top = ranked.isNotEmpty ? ranked.first : null;

    final ctx = _context.contextPackage(tasks);

    final buffer = StringBuffer();

    buffer.writeln("MODE SNAPSHOT");
    buffer.writeln("Active Mode: ${mode.name}");
    buffer.writeln(
        "Energy: ${ctx["energy"].toStringAsFixed(1)} | Emotional: ${ctx["emotional"].toStringAsFixed(1)} | Fatigue: ${ctx["fatigue"].toStringAsFixed(1)}");
    buffer.writeln("");

    if (top != null) {
      buffer.writeln("Top Task: ${top.title}");
      buffer.writeln("This task fits your current mode and state exceptionally well.");
    } else {
      buffer.writeln("No tasks match this mode right now.");
    }

    return buffer.toString().trim();
  }
}
