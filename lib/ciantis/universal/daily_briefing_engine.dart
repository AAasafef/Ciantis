import 'ciantis_context.dart';
import 'mode_engine.dart';
import '../../tasks/integrations/task_integration_hub.dart';
import '../../tasks/intelligence/task_adaptive_engine.dart';

/// DailyBriefingEngine
/// --------------------
/// Generates the unified Ciantis daily briefing.
/// Combines:
/// - Tasks OS
/// - Mode Engine
/// - Adaptive Intelligence
/// - CiantisContext
///
/// This is the "morning brain" of Ciantis.
class DailyBriefingEngine {
  // Singleton
  static final DailyBriefingEngine instance =
      DailyBriefingEngine._internal();
  DailyBriefingEngine._internal();

  final _context = CiantisContext.instance;
  final _mode = ModeEngine.instance;
  final _tasks = TaskIntegrationHub.instance;
  final _adaptive = TaskAdaptiveEngine.instance;

  // -----------------------------
  // BUILD DAILY BRIEFING
  // -----------------------------
  String build() {
    final now = DateTime.now();
    _context.updateTime(now);

    // Auto-detect mode before generating briefing
    _mode.updateModeAutomatically();

    final mode = _context.mode;
    final taskBrief = _tasks.dailyBriefing(now);
    final recs = _adaptive.recommendations();

    final buffer = StringBuffer();

    buffer.writeln("Ciantis Daily Briefing");
    buffer.writeln("----------------------");
    buffer.writeln("Mode: $mode\n");
    buffer.writeln(taskBrief);

    if (recs.isNotEmpty) {
      buffer.writeln("Recommendations:");
      for (final r in recs) {
        buffer.writeln("- $r");
      }
    }

    return buffer.toString();
  }
}
