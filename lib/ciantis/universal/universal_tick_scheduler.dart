import 'developer_logger.dart';
import 'ciantis_context.dart';
import 'mode_engine.dart';
import 'next_best_action_engine.dart';
import 'daily_briefing_engine.dart';
import 'universal_summary_engine.dart';

/// UniversalTick
/// --------------
/// The heartbeat of Ciantis.
/// Runs every time the scheduler fires.
/// Updates:
/// - Context
/// - Mode
/// - Next Best Action
/// - Daily Briefing
/// - Summary
class UniversalTick {
  static final UniversalTick instance = UniversalTick._internal();
  UniversalTick._internal();

  void run() {
    DeveloperLogger.log("Universal Tick started");

    final ctx = CiantisContext.instance;

    // 1. Refresh context
    ctx.refresh();
    DeveloperLogger.log("Tick: Context refreshed");

    // 2. Update mode
    final newMode = ModeEngine.instance.compute();
    ctx.updateMode(newMode);
    DeveloperLogger.log("Tick: Mode updated → $newMode");

    // 3. Compute next best action
    final nba = NextBestActionEngine.instance.compute();
    DeveloperLogger.log("Tick: Next Best Action computed → ${nba?["title"]}");

    // 4. Generate daily briefing
    final briefing = DailyBriefingEngine.instance.build();
    DeveloperLogger.log("Tick: Daily Briefing generated");

    // 5. Generate summary
    final summary = UniversalSummaryEngine.instance.build();
    DeveloperLogger.log("Tick: Summary generated");

    DeveloperLogger.log("Universal Tick completed");
  }
}
