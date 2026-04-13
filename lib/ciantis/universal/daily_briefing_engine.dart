import 'ciantis_context.dart';
import 'ai_state.dart';
import 'developer_logger.dart';

/// DailyBriefingEngine
/// --------------------
/// Generates a short narrative summary of the user's day.
/// Influenced by:
/// - Mode
/// - Energy
/// - Stress
/// - Task load
/// - Calendar load
class DailyBriefingEngine {
  static final DailyBriefingEngine instance =
      DailyBriefingEngine._internal();
  DailyBriefingEngine._internal();

  String build() {
    final ctx = CiantisContext.instance;

    DeveloperLogger.log(
      "DailyBriefingEngine: building briefing using "
      "mode=${ctx.mode}, energy=${ctx.energy}, stress=${ctx.stress}, "
      "taskLoad=${ctx.taskLoad}, calendarLoad=${ctx.calendarLoad}"
    );

    String briefing;

    switch (ctx.mode) {
      case "overwhelmed":
        briefing =
            "Your stress levels are elevated today. Focus on grounding tasks and short resets.";
        break;

      case "fatigued":
        briefing =
            "Energy is low. Today is best approached with gentle pacing and low‑effort wins.";
        break;

      case "high_load":
        briefing =
            "Your schedule and tasks are stacked. Prioritization will be your strongest ally today.";
        break;

      default:
        briefing =
            "You’re in a steady state. Maintain your rhythm and continue progressing through your plans.";
        break;
    }

    AiState.instance.dailyBriefingReason =
        "Daily Briefing generated from mode=${ctx.mode}, "
        "energy=${ctx.energy}, stress=${ctx.stress}, "
        "taskLoad=${ctx.taskLoad}, calendarLoad=${ctx.calendarLoad}. "
        "Result: $briefing";

    DeveloperLogger.log("DailyBriefingEngine: briefing generated");

    return briefing;
  }
}
