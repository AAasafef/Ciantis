import 'ciantis_context.dart';
import 'developer_logger.dart';
import 'ai_state.dart';

/// DailyBriefingEngine
/// --------------------
/// Generates a short narrative summary of the user's day:
/// - Energy trends
/// - Stress trends
/// - Task load
/// - Calendar load
/// - Mode
class DailyBriefingEngine {
  static final DailyBriefingEngine instance =
      DailyBriefingEngine._internal();
  DailyBriefingEngine._internal();

  final _context = CiantisContext.instance;

  String build() {
    final mode = _context.mode;
    final energy = _context.energy;
    final stress = _context.stress;
    final taskLoad = _context.taskLoad;
    final calendarLoad = _context.calendarLoad;

    final briefing =
        "Mode: $mode. Energy=$energy, Stress=$stress, TaskLoad=$taskLoad, CalendarLoad=$calendarLoad.";

    AiState.instance.dailyBriefingReason =
        "Daily briefing generated using current context values.";

    DeveloperLogger.log("Daily Briefing generated");

    return briefing;
  }
}
