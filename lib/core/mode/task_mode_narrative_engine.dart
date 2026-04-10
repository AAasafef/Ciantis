import '../../data/models/task_model.dart';
import '../ai/task_ai_context_engine.dart';
import '../ai/task_ai_state_engine.dart';
import 'task_mode_activation_engine.dart';
import 'task_mode_ranking_engine.dart';
import 'task_modes.dart';

/// TaskModeNarrativeEngine turns mode + context + tasks
/// into human-readable narratives.
///
/// Used by:
/// - Dashboard "Mode" panel
/// - Daily briefings
/// - Mode-aware summaries
/// - "What should I do now?" narratives
class TaskModeNarrativeEngine {
  // Singleton
  static final TaskModeNarrativeEngine instance =
      TaskModeNarrativeEngine._internal();
  TaskModeNarrativeEngine._internal();

  final _activation = TaskModeActivationEngine.instance;
  final _ranking = TaskModeRankingEngine.instance;
  final _context = TaskAIContextEngine.instance;
  final _state = TaskAIStateEngine.instance;

  // -----------------------------
  // MODE INTRO NARRATIVE
  // -----------------------------
  String modeIntro(List<TaskModel> tasks) {
    final mode = _activation.selectMode(tasks);
    final ctx = _context.contextPackage(tasks);

    final energy = ctx["energy"];
    final emotional = ctx["emotional"];
    final fatigue = ctx["fatigue"];
    final stress = ctx["stress"];
    final burnout = ctx["burnout"];

    return """
You are currently best suited for **${mode.name}**.

Energy: ${energy.toStringAsFixed(1)}/10  
Emotional Bandwidth: ${emotional.toStringAsFixed(1)}/10  
Fatigue: ${fatigue.toStringAsFixed(1)}/10  
Stress: ${stress.toStringAsFixed(1)}/10  
Burnout Indicator: ${burnout.toStringAsFixed(1)}/10  

${mode.description}
""".trim();
  }

  // -----------------------------
  // MODE STRENGTHS NARRATIVE
  // -----------------------------
  String modeStrengthsNarrative(List<TaskModel> tasks) {
    final mode = _activation.selectMode(tasks);

    return """
In ${mode.name}, you are especially strong at:

• ${mode.strengths.join("\n• ")}

This is a good time to lean into tasks that match these strengths.
""".trim();
  }

  // -----------------------------
  // MODE CAUTIONS NARRATIVE
  // -----------------------------
  String modeCautionsNarrative(List<TaskModel> tasks) {
    final mode = _activation.selectMode(tasks);

    return """
In ${mode.name}, it may be wise to be gentle with:

• ${mode.weaknesses.join("\n• ")}

These areas can feel heavier or more draining in this mode.
""".trim();
  }

  // -----------------------------
  // TOP TASK NARRATIVE
  // -----------------------------
  String modeTopTaskNarrative(List<TaskModel> tasks) {
    final mode = _activation.selectMode(tasks);
    final ranked = _ranking.rankForMode(tasks);

    if (ranked.isEmpty) {
      return """
In ${mode.name}, there are no tasks that clearly fit right now.

This might be a moment to rest, reset, or adjust your plans.
""".trim();
    }

    final top = ranked.first;

    return """
In ${mode.name}, the task that fits you best right now is:

• ${top.title}

It aligns with your current energy, emotional bandwidth, and the natural strengths of this mode.
Starting here should feel relatively aligned and approachable.
""".trim();
  }

  // -----------------------------
  // MODE + STATE NARRATIVE
  // -----------------------------
  String modeStateNarrative(List<TaskModel> tasks) {
    final mode = _activation.selectMode(tasks);
    final state = _state.buildState(tasks);
    final trends = state["trends"];
    final forecast = state["forecast"];

    final emotionalTrend = trends["emotionalTrend"];
    final fatigueTrend = trends["fatigueTrend"];
    final completionRate = trends["completionRate"];
    final overdueRate = trends["overdueRate"];

    final emotionalForecast = forecast["emotionalForecast"];
    final fatigueForecast = forecast["fatigueForecast"];

    return """
${mode.name} is responding to your current landscape:

• Emotional trend is around ${emotionalTrend.toStringAsFixed(1)}, with fatigue trending near ${fatigueTrend.toStringAsFixed(1)}.  
• Completion rate is ${(completionRate * 100).toStringAsFixed(1)}%, and overdue rate is ${(overdueRate * 100).toStringAsFixed(1)}%.  
• In the near future, emotional load is forecast around ${emotionalForecast.toStringAsFixed(1)}, and fatigue around ${fatigueForecast.toStringAsFixed(1)}.

This mode is chosen to work *with* these patterns, not against them.
""".trim();
  }

  // -----------------------------
  // FULL MODE NARRATIVE PACKAGE
  // -----------------------------
  Map<String, String> modeNarrativePackage(List<TaskModel> tasks) {
    return {
      "intro": modeIntro(tasks),
      "strengths": modeStrengthsNarrative(tasks),
      "cautions": modeCautionsNarrative(tasks),
      "topTask": modeTopTaskNarrative(tasks),
      "modeState": modeStateNarrative(tasks),
    };
  }
}
