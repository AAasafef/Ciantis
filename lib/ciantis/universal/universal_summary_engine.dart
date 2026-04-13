import 'ciantis_context.dart';
import 'ai_state.dart';
import 'developer_logger.dart';

/// UniversalSummaryEngine
/// -----------------------
/// Produces a short, high‑level synthesis of the user's current state.
/// This is used for:
/// - Explainability panel
/// - Developer insights
/// - Future narrative modules
class UniversalSummaryEngine {
  static final UniversalSummaryEngine instance =
      UniversalSummaryEngine._internal();
  UniversalSummaryEngine._internal();

  String build() {
    final ctx = CiantisContext.instance;

    DeveloperLogger.log(
      "UniversalSummaryEngine: building summary using "
      "mode=${ctx.mode}, energy=${ctx.energy}, stress=${ctx.stress}, "
      "taskLoad=${ctx.taskLoad}, calendarLoad=${ctx.calendarLoad}"
    );

    String summary =
        "You are currently in a '${ctx.mode}' state with energy at ${ctx.energy}, "
        "stress at ${ctx.stress}, task load at ${ctx.taskLoad}, and calendar load at ${ctx.calendarLoad}. "
        "This suggests a day shaped by your current emotional and workload balance.";

    AiState.instance.summaryReason =
        "Summary generated from mode=${ctx.mode}, energy=${ctx.energy}, "
        "stress=${ctx.stress}, taskLoad=${ctx.taskLoad}, "
        "calendarLoad=${ctx.calendarLoad}. Result: $summary";

    DeveloperLogger.log("UniversalSummaryEngine: summary generated");

    return summary;
  }
}
