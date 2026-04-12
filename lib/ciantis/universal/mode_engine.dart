import 'ciantis_context.dart';
import 'developer_logger.dart';
import 'ai_state.dart';

/// ModeEngine
/// -----------
/// Determines the user's current mode based on:
/// - Energy
/// - Stress
/// - Task load
/// - Calendar load
///
/// Modes:
/// - focus
/// - recovery
/// - execution
/// - default
class ModeEngine {
  static final ModeEngine instance = ModeEngine._internal();
  ModeEngine._internal();

  final _context = CiantisContext.instance;

  String autoDetectMode() {
    final energy = _context.energy;
    final stress = _context.stress;
    final taskLoad = _context.taskLoad;
    final calendarLoad = _context.calendarLoad;

    if (energy > 70 && stress < 40) return "focus";
    if (stress > 70) return "recovery";
    if (taskLoad > 60 || calendarLoad > 60) return "execution";
    return "default";
  }

  void updateModeAutomatically() {
    final oldMode = _context.mode;
    final newMode = autoDetectMode();

    _context.updateMode(newMode);

    AiState.instance.modeReason =
        "Mode changed from $oldMode to $newMode based on energy=${_context.energy}, "
        "stress=${_context.stress}, taskLoad=${_context.taskLoad}, "
        "calendarLoad=${_context.calendarLoad}.";

    DeveloperLogger.log("Mode changed: $oldMode → $newMode");
  }
}
