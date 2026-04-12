import 'dart:async';
import 'developer_logger.dart';
import 'ciantis_context.dart';
import 'mode_engine.dart';
import 'next_best_action_engine.dart';
import 'daily_briefing_engine.dart';
import 'universal_summary_engine.dart';

/// UniversalTickScheduler
/// -----------------------
/// Runs the Ciantis heartbeat every X minutes.
/// Triggers:
/// - Context refresh
/// - Mode update
/// - Next Best Action update
/// - Daily Briefing update
/// - Summary update
/// - Developer logs
class UniversalTickScheduler {
  static final UniversalTickScheduler instance =
      UniversalTickScheduler._internal();
  UniversalTickScheduler._internal();

  Timer? _timer;

  void start({required Duration interval}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => tick());

    DeveloperLogger.log("Universal Tick Scheduler started (interval: $interval)");
  }

  void tick() {
    final ctx = CiantisContext.instance;
    final mode = ModeEngine.instance;
    final nba = NextBestActionEngine.instance;
    final briefing = DailyBriefingEngine.instance;
    final summary = UniversalSummaryEngine.instance;

    ctx.refresh();
    mode.updateModeAutomatically();
    nba.compute();
    briefing.build();
    summary.build();

    DeveloperLogger.log("Universal Tick executed");
  }
}
