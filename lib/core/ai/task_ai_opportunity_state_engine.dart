import '../../data/models/task_model.dart';
import 'task_ai_opportunity_engine.dart';
import 'task_ai_opportunity_summary_engine.dart';
import 'task_ai_opportunity_explanation_engine.dart';
import 'task_ai_context_engine.dart';

/// TaskAIOpportunityStateEngine produces a unified "Opportunity State"
/// that merges:
/// - Opportunity detection (quick wins, high impact, etc.)
/// - Opportunity ranking
/// - Opportunity summaries
/// - Opportunity explanations
/// - Context alignment
///
/// This is the final layer before the Mode Engine and Next Best Action Engine.
/// It provides a complete, structured snapshot of:
/// - What opportunities exist
/// - Why they exist
/// - How they align with your current state
/// - Which ones matter most right now
class TaskAIOpportunityStateEngine {
  // Singleton
  static final TaskAIOpportunityStateEngine instance =
      TaskAIOpportunityStateEngine._internal();
  TaskAIOpportunityStateEngine._internal();

  final _opp = TaskAIOpportunityEngine.instance;
  final _summary = TaskAIOpportunitySummaryEngine.instance;
  final _explain = TaskAIOpportunityExplanationEngine.instance;
  final _context = TaskAIContextEngine.instance;

  // -----------------------------
  // BUILD OPPORTUNITY STATE
  // -----------------------------
  Map<String, dynamic> buildState(List<TaskModel> tasks) {
    final ranked = _opp.rankedOpportunities(tasks);
    final top = ranked.isNotEmpty ? ranked.first : null;

    return {
      "context": _context.contextPackage(tasks),
      "opportunities": _opp.opportunityPackage(tasks),
      "topOpportunity": top,
      "topOpportunitySummary":
          top != null ? _summary.explainOpportunity(top, tasks) : null,
      "topOpportunityExplanation":
          top != null ? _explain.explanationPackage(task: top, allTasks: tasks) : null,
      "dailyBriefing": _summary.dailyOpportunityBriefing(tasks),
      "categorySummary": _summary.opportunityCategorySummary(tasks),
    };
  }

  // -----------------------------
  // HUMAN-READABLE STATE SUMMARY
  // -----------------------------
  String stateSummary(List<TaskModel> tasks) {
    final context = _context.contextPackage(tasks);
    final opp = _opp.opportunityPackage(tasks);
    final ranked = _opp.rankedOpportunities(tasks);

    final top = ranked.isNotEmpty ? ranked.first : null;

    final buffer = StringBuffer();

    buffer.writeln("OPPORTUNITY SNAPSHOT");
    buffer.writeln(
        "Energy: ${context["energy"].toStringAsFixed(1)} | Emotional: ${context["emotional"].toStringAsFixed(1)} | Fatigue: ${context["fatigue"].toStringAsFixed(1)}");
    buffer.writeln("");

    buffer.writeln("Available Opportunities:");
    buffer.writeln("• Quick Wins: ${opp["quickWins"]!.length}");
    buffer.writeln("• Energy-Aligned: ${opp["energyAligned"]!.length}");
    buffer.writeln("• Emotionally Light: ${opp["emotionallyLight"]!.length}");
    buffer.writeln("• Low Fatigue: ${opp["lowFatigue"]!.length}");
    buffer.writeln("• High Impact: ${opp["highImpact"]!.length}");
    buffer.writeln("• Momentum Builders: ${opp["momentumBuilders"]!.length}");
    buffer.writeln("• Future Stress Reducers: ${opp["futureStressReducers"]!.length}");
    buffer.writeln("• Unlockers: ${opp["unlockers"]!.length}");
    buffer.writeln("");

    if (top != null) {
      buffer.writeln("Top Opportunity: ${top.title}");
      buffer.writeln(_summary.explainOpportunity(top, tasks));
    } else {
      buffer.writeln("No opportunities available at this time.");
    }

    return buffer.toString().trim();
  }
}
