import '../data/dao/routine_dao.dart';
import '../data/repositories/routine_repository.dart';
import '../data/services/routine_service.dart';

/// Centralized service locator for the entire Ciantis app.
/// Ensures all subsystems use the same instance of each service.
class AppServices {
  // -----------------------------
  // ROUTINES SUBSYSTEM
  // -----------------------------
  static final RoutineService routineService = RoutineService(
    RoutineRepository(
      RoutineDao(),
    ),
  );

  // -----------------------------
  // Add other subsystem services here later:
  // - Tasks
  // - Calendar
  // - Salon
  // - Kids
  // - Health
  // - Academic
  // -----------------------------
}
