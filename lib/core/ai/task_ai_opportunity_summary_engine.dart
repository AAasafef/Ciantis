import '../../data/models/task_model.dart';
import 'task_ai_opportunity_engine.dart';
import 'task_ai_context_engine.dart';
import 'task_ai_scoring_engine.dart';

/// TaskAIOpportunitySummaryEngine produces human-readable summaries
/// for the Opportunity Engine.
/// 
/// This engine is used by:
/// - Dashboard "Opportunities" panel
/// - Mode Engine opportunity explanations
/// - Next Best Action opportunity explanations
/// - Daily briefings
/// - Smart nudges
///
/// It explains:
/// - Why a task is a good opportunity
/// - What makes it easy, aligned, or impactful
/// - How it fits your current context
class TaskAIOpportunitySummaryEngine {
  // Singleton
  static final TaskAIOpportunitySummaryEngine instance =
      TaskAIOpportunitySummaryEngine._internal();
  TaskAIOpportunitySummaryEngine._internal();

  final _opp = TaskAIOpportunityEngine.instance;
  final _context = TaskAIContextEngine.instance;
  final _scoring = TaskAIScoringEngine.instance;

  // -----------------------------
  // EXPLAIN WHY A TASK IS AN OPPORTUNITY
  // -----------------------------
  String explainOpportunity(TaskModel task, List<TaskModel> allTasks) {
    final score = _opp.opportunityScore(task, allTasks);
    final readiness = _scoring.readiness(task);
    final fatigue = task.fatigueImpact;
    final emotional = task.emotionalLoad;
    final time = _scoring.timeSensitivity(task);

    final List<String> reasons = [];

    if (readiness >= 7) {
      reasons.add("It feels easy to start right now.");
    }
    if (fatigue <= 3) {
      reasons.add("It requires very little energy.");
    }
    if (emotional <= 3) {
      reasons.add("It carries a light emotional load.");
    }
    if (time <= 3) {
      reasons.add("It is not time‑pressured, making it flexible.");
    }
    if (task.priority >= 4) {
      reasons.add("It has meaningful impact despite being approachable.");
    }

    if (reasons.isEmpty) {
      return """
This task is a good opportunity because it aligns well with your current energy and emotional state.
Opportunity Score: ${score.toStringAsFixed(1)}
""".trim();
    }

    return """
This task is a strong opportunity because:
• ${reasons.join("\n• ")}
Opportunity Score: ${score.toStringAsFixed(1)}
""".trim();
  }

  // -----------------------------
  // DAILY OPPORTUNITY BRIEFING
  // -----------------------------
  String dailyOpportunityBriefing(List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return "You have no tasks available for opportunity analysis today.";
    }

    final ranked = _opp.rankedOpportunities(tasks);
    final top = ranked.take(3).toList();

    final energy = _context.energyContext(tasks);
    final emotional = _context.emotionalContext(tasks);

    final buffer = StringBuffer();

    buffer.writeln(
        "Based on your current energy (${energy.toStringAsFixed(1)}/10) and emotional bandwidth (${emotional.toStringAsFixed(1)}/10), here are your top opportunities today:");

    for (final t in top) {
      final score = _opp.opportunityScore(t, tasks).toStringAsFixed(1);
      buffer.writeln("• ${t.title} — Opportunity Score: $score");
    }

    return buffer.toString().trim();
  }

  // -----------------------------
  // OPPORTUNITY CATEGORY SUMMARY
  // -----------------------------
  String opportunityCategorySummary(List<TaskModel> tasks) {
    final quick = _opp.quickWins(tasks).length;
    final energy = _opp.energyAligned(tasks).length;
    final light = _opp.emotionallyLight(tasks).length;
    final lowFatigue = _opp.lowFatigue(tasks).length;
    final highImpact = _opp.highImpact(tasks).length;
    final momentum = _opp.momentumBuilders(tasks).length;
    final stress = _opp.futureStressReducers(tasks).length;
    final unlock = _opp.unlockers(tasks).length;

    return """
Quick Wins: $quick  
Energy-Aligned Tasks: $energy  
Emotionally Light Tasks: $light  
Low-Fatigue Tasks: $lowFatigue  
High-Impact Tasks: $highImpact  
Momentum Builders: $momentum  
Future Stress Reducers: $stress  
Unlocker Tasks: $unlock  
""".trim();
  }

  // -----------------------------
  // FULL OPPORTUNITY SUMMARY PACKAGE
  // -----------------------------
  Map<String, String> opportunitySummaryPackage({
    required TaskModel? task,
    required List<TaskModel> allTasks,
  }) {
    return {
      if (task != null)
        "explanation": explainOpportunity(task, allTasks),
      "dailyBriefing": dailyOpportunityBriefing(allTasks),
      "categorySummary": opportunityCategorySummary(allTasks),
    };
  }
}
