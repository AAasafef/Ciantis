import 'ciantis_context.dart';
import 'developer_logger.dart';
import 'ai_state.dart';

/// UniversalSummaryEngine
/// -----------------------
/// Generates a high-level summary of the user's current state.
/// This is used for:
/// - Explainability panel
/// - Developer diagnostics
/// - Internal AI reasoning
class UniversalSummaryEngine {
  static final UniversalSummaryEngine instance =
      UniversalSummaryEngine._internal();
  UniversalSummaryEngine._internal();

  final _context = CiantisContext.instance;

  String build() {
    final mode = _context.mode;
    final energy = _context.energy;
    final stress = _context.stress;
    final taskLoad = _context.taskLoad;
    final calendarLoad = _context.calendarLoad;

    final summary =
        "Summary: mode=$mode, energy=$energy, stress=$stress, taskLoad=$taskLoad, calendarLoad=$calendarLoad.";

    AiState.instance.summaryReason =
        "Summary generated using current context values.";

    DeveloperLogger.log("Universal Summary generated");

    return summary;
  }
}
