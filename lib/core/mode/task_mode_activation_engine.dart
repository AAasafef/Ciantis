import '../../data/models/task_model.dart';
import '../ai/task_ai_state_engine.dart';
import 'task_modes.dart';

/// TaskModeActivationEngine determines which mode should be active
/// based on:
/// - Context (energy, emotional, fatigue, stress, burnout)
/// - Trends
/// - Forecasts
/// - Anomalies
/// - Opportunity landscape
/// - Mode activation rules
///
/// This is the FIRST stage of the Mode Engine.
/// It does NOT rank tasks.
/// It ONLY determines the correct mode.
class TaskModeActivationEngine {
  // Singleton
  static final TaskModeActivationEngine instance =
      TaskModeActivationEngine._internal();
  TaskModeActivationEngine._internal();

  final _state = TaskAIStateEngine.instance;

  // -----------------------------
  // CHECK IF MODE IS ELIGIBLE
  // -----------------------------
  bool _modeEligible(TaskMode mode, Map<String, dynamic> context) {
    final rules = mode.activationRules;

    bool ok = true;

    if (rules.containsKey("energyMin")) {
      ok &= context["energy"] >= rules["energyMin"];
    }
    if (rules.containsKey("energyMax")) {
      ok &= context["energy"] <= rules["energyMax"];
    }

    if (rules.containsKey("fatigueMin")) {
      ok &= context["fatigue"] >= rules["fatigueMin"];
    }
    if (rules.containsKey("fatigueMax")) {
      ok &= context["fatigue"] <= rules["fatigueMax"];
    }

    if (rules.containsKey("emotionalMin")) {
      ok &= context["emotional"] >= rules["emotionalMin"];
    }
    if (rules.containsKey("emotionalMax")) {
      ok &= context["emotional"] <= rules["emotionalMax"];
    }

    if (rules.containsKey("stressMin")) {
      ok &= context["stress"] >= rules["stressMin"];
    }
    if (rules.containsKey("burnoutMin")) {
      ok &= context["burnout"] >= rules["burnoutMin"];
    }

    return ok;
  }

  // -----------------------------
  // SELECT ACTIVE MODE
  // -----------------------------
  TaskMode selectMode(List<TaskModel> tasks) {
    final state = _state.buildState(tasks);
    final context = state["context"];

    // Priority order:
    // 1. Reset Mode (if stress/burnout is high)
    // 2. Emotional Mode (if emotional load is high)
    // 3. Focus Mode (if energy is high + low fatigue)
    // 4. Power Mode (if energy is very high)
    // 5. Light Mode (fallback when energy/emotional is low)

    // RESET MODE
    if (_modeEligible(TaskModes.reset, context)) {
      return TaskModes.reset;
    }

    // EMOTIONAL MODE
    if (_modeEligible(TaskModes.emotional, context)) {
      return TaskModes.emotional;
    }

    // FOCUS MODE
    if (_modeEligible(TaskModes.focus, context)) {
      return TaskModes.focus;
    }

    // POWER MODE
    if (_modeEligible(TaskModes.power, context)) {
      return TaskModes.power;
    }

    // LIGHT MODE (fallback)
    return TaskModes.light;
  }

  // -----------------------------
  // MODE SUMMARY (HUMAN-READABLE)
  // -----------------------------
  String modeSummary(List<TaskModel> tasks) {
    final mode = selectMode(tasks);

    return """
Active Mode: ${mode.name}

${mode.description}

Strengths:
• ${mode.strengths.join("\n• ")}

Weaknesses:
• ${mode.weaknesses.join("\n• ")}

Best For:
• ${mode.bestFor.join("\n• ")}

Avoid For:
• ${mode.avoidFor.join("\n• ")}
""".trim();
  }
}
