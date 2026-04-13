import 'ciantis_context.dart';
import 'ai_state.dart';
import 'developer_logger.dart';

/// NextBestActionEngine
/// ---------------------
/// Computes the single most strategic action the user should take next.
/// Based on:
/// - Mode
/// - Energy
/// - Stress
/// - Task load
/// - Calendar load
class NextBestActionEngine {
  static final NextBestActionEngine instance =
      NextBestActionEngine._internal();
  NextBestActionEngine._internal();

  Map<String, dynamic>? compute() {
    final ctx = CiantisContext.instance;

    DeveloperLogger.log(
      "NextBestActionEngine: computing using "
      "mode=${ctx.mode}, energy=${ctx.energy}, stress=${ctx.stress}, "
      "taskLoad=${ctx.taskLoad}, calendarLoad=${ctx.calendarLoad}"
    );

    Map<String, dynamic>? action;

    if (ctx.mode == "overwhelmed") {
      action = {
        "title": "Take a 2‑minute reset",
        "description": "Your stress is high. A short reset will stabilize you.",
      };
    } else if (ctx.mode == "fatigued") {
      action = {
        "title": "Do a low‑effort task",
        "description": "Energy is low. Choose something simple to regain momentum.",
      };
    } else if (ctx.mode == "high_load") {
      action = {
        "title": "Prioritize your top task",
        "description": "Your load is high. Focus on the single most important item.",
      };
    } else {
      action = {
        "title": "Proceed with your planned tasks",
        "description": "You’re steady. Continue with your normal workflow.",
      };
    }

    AiState.instance.nextBestActionReason =
        "NBA computed from mode=${ctx.mode}, energy=${ctx.energy}, "
        "stress=${ctx.stress}, taskLoad=${ctx.taskLoad}, "
        "calendarLoad=${ctx.calendarLoad}. "
        "Result: ${action?["title"]}";

    DeveloperLogger.log(
      "NextBestActionEngine: action computed → ${action?["title"]}"
    );

    return action;
  }
}
