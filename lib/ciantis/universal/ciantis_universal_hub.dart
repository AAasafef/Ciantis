import '../../tasks/integrations/task_integration_hub.dart';
import '../../tasks/intelligence/task_adaptive_engine.dart';

/// CiantisUniversalHub
/// --------------------
/// Top-level orchestrator that unifies:
/// - Tasks OS
/// - Calendar OS (future)
/// - Mode Engine (future)
/// - Adaptive Intelligence Layer
///
/// All global "what should I do / show / suggest?"
/// flows through here.
class CiantisUniversalHub {
  // Singleton
  static final CiantisUniversalHub instance =
      CiantisUniversalHub._internal();
  CiantisUniversalHub._internal();

  final _tasks = TaskIntegrationHub.instance;
  final _adaptive = TaskAdaptiveEngine.instance;

  // -----------------------------
  // UNIVERSAL NEXT BEST ACTION
  // -----------------------------
  String universalNextBestAction({
    required DateTime now,
    String? mode,
  }) {
    final task = _tasks.nextBestAction(now: now, mode: mode);
    if (task != null) {
      return "Next best action: ${task.title}";
    }
    return "No recommended action right now.";
  }

  // -----------------------------
  // UNIVERSAL DAILY BRIEFING
  // -----------------------------
  String universalDailyBriefing(DateTime now) {
    final taskBrief = _tasks.dailyBriefing(now);

    return """
Ciantis Daily Briefing
----------------------
$taskBrief
""";
  }

  // -----------------------------
  // UNIVERSAL RECOMMENDATIONS
  // -----------------------------
  List<String> universalRecommendations() {
    return _adaptive.recommendations();
  }

  // -----------------------------
  // UNIVERSAL MODE PROMPT
  // -----------------------------
  String? universalModePrompt(String mode, DateTime now) {
    return _tasks.modePrompt(mode, now);
  }
}
