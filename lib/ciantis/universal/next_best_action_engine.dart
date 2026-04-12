import 'ciantis_context.dart';
import 'mode_engine.dart';
import '../../tasks/integrations/task_integration_hub.dart';

/// NextBestActionEngine
/// ---------------------
/// The global "Do This Next" brain of Ciantis.
/// Combines:
/// - Tasks OS
/// - Mode Engine
/// - CiantisContext
///
/// Calendar OS will plug in later.
///
/// This engine returns ONE action string.
class NextBestActionEngine {
  // Singleton
  static final NextBestActionEngine instance =
      NextBestActionEngine._internal();
  NextBestActionEngine._internal();

  final _context = CiantisContext.instance;
  final _mode = ModeEngine.instance;
  final _tasks = TaskIntegrationHub.instance;

  // -----------------------------
  // UNIVERSAL NEXT BEST ACTION
  // -----------------------------
  String compute() {
    final now = DateTime.now();
    _context.updateTime(now);

    // Ensure mode is up to date
    _mode.updateModeAutomatically();

    // Ask Tasks OS for the next best action
    final task = _tasks.nextBestAction(
      now: now,
      mode: _context.mode,
    );

    if (task != null) {
      return "Next best action: ${task.title}";
    }

    return "No recommended action right now.";
  }
}
