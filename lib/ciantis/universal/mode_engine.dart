import 'ciantis_context.dart';
import 'ai_state.dart';
import 'developer_logger.dart';

/// ModeEngine
/// -----------
/// Computes the user's current mode based on:
/// - Energy
/// - Stress
/// - Task load
/// - Calendar load
///
/// Modes influence:
/// - Next Best Action
/// - Daily Briefing tone
/// - UI emotional cues
class ModeEngine {
  static final ModeEngine instance = ModeEngine._internal();
  ModeEngine._internal();

  String compute() {
    final ctx = CiantisContext.instance;

    DeveloperLogger.log(
      "ModeEngine: computing mode using "
      "energy=${ctx.energy}, stress=${ctx.stress}, "
      "taskLoad=${ctx.taskLoad}, calendarLoad=${ctx.calendarLoad}"
    );

    String mode;

    if (ctx.stress > 70) {
      mode = "overwhelmed";
    } else if (ctx.energy < 30) {
      mode = "fatigued";
    } else if (ctx.taskLoad > 70 || ctx.calendarLoad > 70) {
      mode = "high_load";
    } else {
      mode = "steady";
    }

    AiState.instance.modeReason =
        "Mode computed from energy=${ctx.energy}, stress=${ctx.stress}, "
        "taskLoad=${ctx.taskLoad}, calendarLoad=${ctx.calendarLoad}. "
        "Result: $mode";

    DeveloperLogger.log("ModeEngine: mode computed → $mode");

    return mode;
  }
}
