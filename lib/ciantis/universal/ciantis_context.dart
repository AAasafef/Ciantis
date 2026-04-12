import 'developer_logger.dart';

/// CiantisContext
/// ---------------
/// Holds the user's dynamic state:
/// - Energy
/// - Stress
/// - Task load
/// - Calendar load
/// - Mode
///
/// This is refreshed every Universal Tick.
class CiantisContext {
  static final CiantisContext instance = CiantisContext._internal();
  CiantisContext._internal();

  int energy = 50;
  int stress = 50;
  int taskLoad = 40;
  int calendarLoad = 40;
  String mode = "default";

  DateTime lastUpdated = DateTime.now();

  void refresh() {
    // Placeholder logic — real logic will be added later
    energy = (energy + 1).clamp(0, 100);
    stress = (stress - 1).clamp(0, 100);
    taskLoad = taskLoad;
    calendarLoad = calendarLoad;

    lastUpdated = DateTime.now();

    DeveloperLogger.log(
      "Context refreshed: energy=$energy, stress=$stress, "
      "taskLoad=$taskLoad, calendarLoad=$calendarLoad"
    );
  }

  void updateMode(String newMode) {
    mode = newMode;
    DeveloperLogger.log("Context mode updated → $newMode");
  }
}
