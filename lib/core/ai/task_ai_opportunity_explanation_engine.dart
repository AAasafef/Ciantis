import '../../data/models/task_model.dart';
import 'task_ai_opportunity_engine.dart';
import 'task_ai_context_engine.dart';
import 'task_ai_scoring_engine.dart';

/// TaskAIOpportunityExplanationEngine provides structured explanations
/// for why a task is considered a good opportunity.
///
/// This engine is used by:
/// - Mode Engine
/// - Next Best Action Engine
/// - Dashboard "Why this task?"
/// - Smart nudges
/// - Transparency UI
///
/// It explains:
/// - Why the task is easy to start
/// - Why it aligns with current energy/emotional state
/// - Why it reduces future stress
/// - Why it builds momentum
/// - Why it is high impact
/// - Why it is surfaced now
class TaskAIOpportunityExplanationEngine {
  // Singleton
  static final TaskAIOpportunityExplanationEngine instance =
      TaskAIOpportunityExplanationEngine._internal();
  TaskAIOpportunityExplanationEngine._internal();

  final _opp = TaskAIOpportunityEngine.instance;
  final _context = TaskAIContextEngine.instance;
  final _scoring = TaskAIScoringEngine.instance;

  // -----------------------------
  // EXPLAIN OPPORTUNITY FACTORS
  // -----------------------------
  Map<String, String> explainFactors(TaskModel task, List<TaskModel> allTasks) {
    final readiness = _scoring.readiness(task);
    final fatigue = task.fatigueImpact;
    final emotional = task.emotionalLoad;
    final time = _scoring.timeSensitivity(task);
    final priority = task.priority;

    final Map<String, String> factors = {};

    if (readiness >= 7) {
      factors["readiness"] = "This task feels easy to start right now.";
    }
    if (fatigue <= 3) {
      factors["fatigue"] = "This task requires very little physical or mental energy.";
    }
    if (emotional <= 3) {
      factors["emotional"] = "This task carries a light emotional load.";
    }
    if (time <= 3) {
      factors["time"] = "This task is flexible and not time‑pressured.";
    }
    if (priority >= 4) {
      factors["priority"] = "This task has meaningful impact despite being approachable.";
    }

    return factors;
  }

  // -----------------------------
  // EXPLAIN CONTEXT ALIGNMENT
  // -----------------------------
  String explainContextAlignment(TaskModel task, List<TaskModel> allTasks) {
    final energy = _context.energyContext(allTasks);
    final emotional = _context.emotionalContext(allTasks);
    final fatigue = _context.fatigueContext(allTasks);

    final readiness = _scoring.readiness(task);

    final List<String> reasons = [];

    if (readiness >= energy - 2) {
      reasons.add("It matches your current energy level.");
    }
    if (task.emotionalLoad <= emotional + 2) {
      reasons.add("It fits your current emotional bandwidth.");
    }
    if (task.fatigueImpact <= fatigue + 2) {
      reasons.add("It aligns with your current fatigue level.");

    }

    if (reasons.isEmpty) {
      return "This task aligns reasonably well with your current state.";
    }

    return "This task aligns with your current state because:\n• ${reasons.join("\n• ")}";
  }

  // -----------------------------
  // EXPLAIN CATEGORY MEMBERSHIP
  // -----------------------------
  String explainCategory(TaskModel task, List<TaskModel> allTasks) {
    final quick = _opp.quickWins(allTasks).contains(task);
    final energy = _opp.energyAligned(allTasks).contains(task);
    final light = _opp.emotionallyLight(allTasks).contains(task);
    final lowFatigue = _opp.lowFatigue(allTasks).contains(task);
    final highImpact = _opp.highImpact(allTasks).contains(task);
    final momentum = _opp.momentumBuilders(allTasks).contains(task);
    final stress = _opp.futureStressReducers(allTasks).contains(task);
    final unlock = _opp.unlockers(allTasks).contains(task);

    final List<String> categories = [];

    if (quick) categories.add("Quick Win");
    if (energy) categories.add("Energy‑Aligned");
    if (light) categories.add("Emotionally Light");
    if (lowFatigue) categories.add("Low Fatigue");
    if (highImpact) categories.add("High Impact");
    if (momentum) categories.add("Momentum Builder");
    if (stress) categories.add("Future Stress Reducer");
    if (unlock) categories.add("Unlocker Task");

    if (categories.isEmpty) {
      return "This task does not belong to any specific opportunity category.";
    }

    return "This task belongs to the following opportunity categories:\n• ${categories.join("\n• ")}";
  }

  // -----------------------------
  // EXPLAIN OPPORTUNITY SCORE
  // -----------------------------
  String explainOpportunityScore(TaskModel task, List<TaskModel> allTasks) {
    final score = _opp.opportunityScore(task, allTasks);

    return """
The Opportunity Score of ${score.toStringAsFixed(1)} reflects:
• How easy the task is to start  
• How well it matches your current energy  
• How emotionally light it is  
• How low‑fatigue it is  
• How flexible it is in timing  
""".trim();
  }

  // -----------------------------
  // FULL EXPLANATION PACKAGE
  // -----------------------------
  Map<String, String> explanationPackage({
    required TaskModel task,
    required List<TaskModel> allTasks,
  }) {
    return {
      "factors": explainFactors(task, allTasks)
          .entries
          .map((e) => "• ${e.value}")
          .join("\n"),
      "contextAlignment": explainContextAlignment(task, allTasks),
      "categories": explainCategory(task, allTasks),
      "opportunityScore": explainOpportunityScore(task, allTasks),
    };
  }
}
