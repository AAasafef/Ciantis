import '../data/dao/routine_dao.dart';
import '../data/repositories/routine_repository.dart';
import '../data/services/routine_service.dart';

import '../data/dao/task_dao.dart';
import '../data/repositories/task_repository.dart';
import '../data/services/task_service.dart';

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
  // TASKS SUBSYSTEM
  // -----------------------------
  static final TaskService taskService = TaskService(
    TaskRepository(
      TaskDao(),
    ),
  );

  // -----------------------------
  // FUTURE SUBSYSTEMS
  // -----------------------------
  // static final CalendarService calendarService = ...
  // static final KidsService kidsService = ...
  // static final SalonService salonService = ...
  // static final HealthService healthService = ...
  // static final AcademicService academicService = ...
  // static final ModeEngine modeEngine = ...
  // static final NotificationEngine notificationEngine = ...
  // static final AiSuggestionEngine aiEngine = ...
}
