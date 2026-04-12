import 'daily_briefing_engine.dart';
import 'next_best_action_engine.dart';
import 'ciantis_context.dart';
import '../../tasks/intelligence/task_adaptive_engine.dart';

/// UniversalSummaryEngine
/// -----------------------
/// Produces a unified summary combining:
/// - Daily Briefing
/// - Next Best Action
/// - Recommendations
/// - Current Mode
///
/// This is used by:
/// - Home Dashboard
/// - Morning Overview
/// - Universal Hub (future)
class UniversalSummaryEngine {
  // Singleton
  static final UniversalSummaryEngine instance =
      UniversalSummaryEngine._internal();
  UniversalSummaryEngine._internal();

  final _context = CiantisContext.instance;
  final _briefing = DailyBriefingEngine.instance;
  final _nba = NextBestActionEngine.instance;
  final _adaptive = TaskAdaptiveEngine.instance;

  // -----------------------------
  // BUILD UNIVERSAL SUMMARY
  // -----------------------------
  String build() {
    final buffer = StringBuffer();

    final mode = _context.mode;
    final briefing = _briefing.build();
    final next = _nba.compute();
    final recs = _adaptive.recommendations();

    buffer.writeln("Ciantis Summary");
    buffer.writeln("----------------");
    buffer.writeln("Mode: $mode\n");

    buffer.writeln(next);
    buffer.writeln("");

    buffer.writeln(briefing);
    buffer.writeln("");

    if (recs.isNotEmpty) {
      buffer.writeln("Recommendations:");
      for (final r in recs) {
        buffer.writeln("- $r");
      }
    }

    return buffer.toString();
  }
}
