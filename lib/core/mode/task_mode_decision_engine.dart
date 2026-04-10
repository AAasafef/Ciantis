import '../../data/models/task_model.dart';
import '../ai/task_ai_context_engine.dart';
import '../ai/task_ai_state_engine.dart';
import '../ai/task_ai_opportunity_engine.dart';
import '../ai/task_ai_opportunity_summary_engine.dart';
import '../ai/task_ai_opportunity_explanation_engine.dart';
import 'task_mode_activation_engine.dart';
import 'task_mode_filter_engine.dart';
import 'task_mode_ranking_engine.dart';
import 'task_mode_narrative_engine.dart';
import 'task_mode_explanation_engine.dart';
import 'task_modes.dart';

/// TaskModeDecisionEngine produces the final "Next Best Action"
/// *within the active mode*.
///
/// It merges:
/// - Mode activation
/// - Mode filtering
/// - Mode ranking
/// - Mode narratives
/// - Mode explanations
/// - Opportunity scoring
/// - Context
/// - AI state
///
/// This is the final step before the full Next Best Action Engine.
class TaskModeDecisionEngine {
  // Singleton
  static final TaskModeDecisionEngine instance =
      TaskModeDecisionEngine._internal();
  TaskModeDecisionEngine._internal();

  final _activation = TaskModeActivationEngine.instance;
  final _filter = TaskModeFilterEngine.instance;
  final _ranking = TaskModeRankingEngine.instance;
  final _narrative = TaskModeNarrativeEngine.instance;
  final _explain = TaskModeExplanationEngine.instance;

  final _context = TaskAIContextEngine.instance;
  final _state = TaskAIStateEngine.instance;

  final _opp = TaskAIOpportunityEngine.instance;
  final _oppSummary = TaskAIOpportunitySummaryEngine.instance;
  final _oppExplain = TaskAIOpportunityExplanationEngine.instance;

  // -----------------------------
  // NEXT BEST ACTION (MODE-SPECIFIC)
  // -----------------------------
  Map<String, dynamic> nextBestAction(List<TaskModel> tasks) {
    final mode = _activation.selectMode(tasks);
    final filtered = _filter.filterForMode(mode, tasks);
    final ranked = _ranking.rankForMode(tasks);

    final top = ranked.isNotEmpty ? ranked.first : null;

    return {
      "mode": mode,
      "filteredTasks": filtered,
      "rankedTasks": ranked,
      "topTask": top,

      "context": _context.contextPackage(tasks),
      "aiState": _state.buildState(tasks),

      "opportunities": _opp.opportunityPackage(tasks),
      "opportunitySummary": top != null
          ? _oppSummary.explainOpportunity(top, tasks)
          : null,
      "opportunityExplanation": top != null
          ? _oppExplain.explanationPackage(task: top, allTasks: tasks)
          : null,

      "modeNarratives": _narrative.modeNarrativePackage(tasks),
      "modeExplanations": _explain.explanationPackage(tasks),
    };
  }

  // -----------------------------
  // HUMAN-READABLE DECISION SUMMARY
  // -----------------------------
  String decisionSummary(List<TaskModel> tasks) {
    final mode = _activation.selectMode(tasks);
    final ranked = _ranking.rankForMode(tasks);
    final top = ranked.isNotEmpty ? ranked.first : null;

    if (top == null) {
      return """
Active Mode: ${mode.name}

There are no tasks that fit this mode right now.
This may be a moment to rest, reset, or shift modes.
""".trim();
    }

    final ctx = _context.contextPackage(tasks);
    final oppScore = _opp.opportunityScore(top, tasks).toStringAsFixed(1);

    return """
Active Mode: ${mode.name}

Your Next Best Action is:

• **${top.title}**

Why this task:
• It ranks highest in your current mode  
• It matches your energy (${ctx["energy"].toStringAsFixed(1)})  
• It fits your emotional bandwidth (${ctx["emotional"].toStringAsFixed(1)})  
• It has a strong opportunity score ($oppScore)  
• It aligns with mode strengths and avoids mode weaknesses  

This is the task most aligned with who you are *right now*.
""".trim();
  }
}
