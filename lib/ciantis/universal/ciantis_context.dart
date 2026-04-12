/// CiantisContext
/// --------------
/// Shared global state used by:
/// - Tasks OS
/// - Calendar OS
/// - Mode Engine
/// - Adaptive Intelligence
///
/// This allows all modules to understand:
/// - Current mode
/// - Current energy level
/// - Current stress level
/// - Current task load
/// - Current calendar load
/// - Current time window
///
/// This is the "shared brain state" of Ciantis.
class CiantisContext {
  // Singleton
  static final CiantisContext instance = CiantisContext._internal();
  CiantisContext._internal();

  // -----------------------------
  // MODE (focus, fatigue, recovery, etc.)
  // -----------------------------
  String mode = "neutral";

  // -----------------------------
  // ENERGY (0–100)
  // -----------------------------
  double energy = 50;

  // -----------------------------
  // STRESS (0–100)
  // -----------------------------
  double stress = 20;

  // -----------------------------
  // TASK LOAD (0–100)
  // -----------------------------
  double taskLoad = 0;

  // -----------------------------
  // CALENDAR LOAD (0–100)
  // -----------------------------
  double calendarLoad = 0;

  // -----------------------------
  // CURRENT TIME WINDOW
  // -----------------------------
  DateTime now = DateTime.now();

  // -----------------------------
  // UPDATE HELPERS
  // -----------------------------
  void updateMode(String newMode) {
    mode = newMode;
  }

  void updateEnergy(double value) {
    energy = value.clamp(0, 100);
  }

  void updateStress(double value) {
    stress = value.clamp(0, 100);
  }

  void updateTaskLoad(double value) {
    taskLoad = value.clamp(0, 100);
  }

  void updateCalendarLoad(double value) {
    calendarLoad = value.clamp(0, 100);
  }

  void updateTime(DateTime time) {
    now = time;
  }
}
