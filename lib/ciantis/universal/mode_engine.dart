import 'ciantis_context.dart';
import '../../tasks/integrations/task_integration_hub.dart';

/// ModeEngine
/// ----------
/// Determines the user's current mode and updates CiantisContext.
/// Modes:
/// - focus
/// - fatigue
/// - recovery
/// - overwhelm
/// - neutral
///
/// This engine is used by:
/// - Universal Hub
/// - Tasks OS
/// - Calendar OS (future)
/// - Adaptive Intelligence Layer
class ModeEngine {
  // Singleton
  static final ModeEngine instance = ModeEngine._internal();
  ModeEngine._internal();

  final _context = CiantisContext.instance;
  final _tasks = TaskIntegrationHub.instance;

  // -----------------------------
  // SET MODE
  // -----------------------------
  void setMode(String mode) {
    _context.updateMode(mode);
  }

  // -----------------------------
  // AUTO-DETECT MODE
  // -----------------------------
  /// Determines mode based on:
  /// - energy
  /// - stress
  /// - task load
  /// - calendar load
  String autoDetectMode() {
    final energy = _context.energy;
    final stress = _context.stress;
    final taskLoad = _context.taskLoad;
    final calendarLoad = _context.calendarLoad;

    // High stress + high load → overwhelm
    if (stress > 70 && (taskLoad + calendarLoad) > 120) {
      return "overwhelm";
    }

    // Low energy → fatigue
    if (energy < 30) {
      return "fatigue";
    }

    // High energy + low stress → focus
    if (energy > 60 && stress < 40) {
      return "focus";
    }

    // Medium energy + medium stress → recovery
    if (energy >= 30 && energy <= 60 && stress >= 40 && stress <= 70) {
      return "recovery";
    }

    return "neutral";
  }

  // -----------------------------
  // UPDATE MODE AUTOMATICALLY
  // -----------------------------
  void updateModeAutomatically() {
    final detected = autoDetectMode();
    _context.updateMode(detected);
  }

  // -----------------------------
  // MODE PROMPT (UNIVERSAL)
  // -----------------------------
  String? modePrompt() {
    return _tasks.modePrompt(_context.mode, _context.now);
  }
}
