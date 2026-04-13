import 'developer_logger.dart';

/// CiantisContext
/// ----------------
/// Tracks the user's dynamic state:
/// - Energy
/// - Stress
/// - Task load
/// - Calendar load
/// - Mode
/// - Last updated timestamp
///
/// This is refreshed every Universal Tick.
class CiantisContext {
  static final CiantisContext instance = CiantisContext._internal();
  CiantisContext._internal();

  int energy = 70;
  int stress = 30;
  int taskLoad = 40;
  int calendarLoad = 35;
  String mode = "steady";

  DateTime lastUpdated = DateTime.now();

  /// Refresh context values.
  /// In the future, this will pull from:
  /// - Sensors
  /// - Calendar
  /// - Tasks
  /// - Sleep data
  /// - Health data
  void refresh() {
    final oldEnergy = energy;
    final oldStress = stress;
    final oldTaskLoad = taskLoad;
    final oldCalendarLoad = calendarLoad;

    // Placeholder logic for now
    energy = (energy - 1).clamp(0, 100);
    stress = (stress + 1).clamp(0, 100);
    taskLoad = taskLoad;
    calendarLoad = calendarLoad;

    lastUpdated = DateTime.now();

    DeveloperLogger.log(
      "Context refreshed: "
      "energy $oldEnergy → $energy, "
      "stress $oldStress → $stress, "
      "taskLoad $oldTaskLoad → $taskLoad, "
      "calendarLoad $oldCalendarLoad → $calendarLoad"
    );
  }

  /// Update mode after ModeEngine computes it.
  void updateMode(String newMode) {
    final oldMode = mode;
    mode = newMode;

    DeveloperLogger.log("Context mode updated: $oldMode → $newMode");
  }
}
