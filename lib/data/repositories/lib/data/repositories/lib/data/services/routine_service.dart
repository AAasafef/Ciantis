import 'package:uuid/uuid.dart';
import '../models/routine_model.dart';
import '../models/routine_step_model.dart';
import '../repositories/routine_repository.dart';
import 'mode_engine_service.dart';

class RoutineService {
  final RoutineRepository _repo = RoutineRepository();
  final ModeEngineService _modeEngine = ModeEngineService();
  final Uuid _uuid = const Uuid();

  // -----------------------------
  // CREATE ROUTINE
  // -----------------------------
  Future<String> createRoutine({
    required String title,
    String? description,
    required String category,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();

    final routine = RoutineModel(
      id: id,
      title: title,
      description: description,
      category: category,
      emotionalLoad: 0,
      fatigueImpact: 0,
      estimatedDuration: 0,
      streak: 0,
      lastCompleted: null,
      createdAt: now,
      updatedAt: now,
    );

    await _repo.addRoutine(routine);
    return id;
  }

  // -----------------------------
  // ADD STEP
  // -----------------------------
  Future<void> addStep({
    required String routineId,
    required String title,
    required int duration,
    required int emotionalLoad,
    required int fatigueImpact,
    required int orderIndex,
  }) async {
    final now = DateTime.now();

    final step = RoutineStepModel(
      id: _uuid.v4(),
      routineId: routineId,
      title: title,
      duration: duration,
      emotionalLoad: emotionalLoad,
      fatigueImpact: fatigueImpact,
      orderIndex: orderIndex,
      completed: false,
      createdAt: now,
      updatedAt: now,
    );

    await _repo.addStep(step);
    await _recalculateRoutineTotals(routineId);
  }

  // -----------------------------
  // UPDATE STEP ORDER
  // -----------------------------
  Future<void> reorderSteps(String routineId, List<RoutineStepModel> steps) async {
    for (int i = 0; i < steps.length; i++) {
      final updated = steps[i].copyWith(
        orderIndex: i,
        updatedAt: DateTime.now(),
      );
      await _repo.updateStep(updated);
    }
  }

  // -----------------------------
  // RECALCULATE ROUTINE TOTALS
  // -----------------------------
  Future<void> _recalculateRoutineTotals(String routineId) async {
    final routine = await _repo.getRoutineById(routineId);
    if (routine == null) return;

    final steps = await _repo.getStepsForRoutine(routineId);

    int emotional = 0;
    int fatigue = 0;
    int duration = 0;

    for (var s in steps) {
      emotional += s.emotionalLoad;
      fatigue += s.fatigueImpact;
      duration += s.duration;
    }

    final updated = routine.copyWith(
      emotionalLoad: emotional,
      fatigueImpact: fatigue,
      estimatedDuration: duration,
      updatedAt: DateTime.now(),
    );

    await _repo.updateRoutine(updated);
  }

  // -----------------------------
  // MARK ROUTINE COMPLETED
  // -----------------------------
  Future<void> completeRoutine(String routineId) async {
    final routine = await _repo.getRoutineById(routineId);
    if (routine == null) return;

    final now = DateTime.now();

    int newStreak = routine.streak;

    if (routine.lastCompleted != null) {
      final last = DateTime(
        routine.lastCompleted!.year,
        routine.lastCompleted!.month,
        routine.lastCompleted!.day,
      );
      final today = DateTime(now.year, now.month, now.day);

      if (today.difference(last).inDays == 1) {
        newStreak += 1;
      } else if (today.difference(last).inDays > 1) {
        newStreak = 1;
      }
    } else {
      newStreak = 1;
    }

    final updated = routine.copyWith(
      streak: newStreak,
      lastCompleted: now,
      updatedAt: now,
    );

    await _repo.updateRoutine(updated);
  }

  // -----------------------------
  // RESET STEP COMPLETION
  // -----------------------------
  Future<void> resetSteps(String routineId) async {
    final steps = await _repo.getStepsForRoutine(routineId);

    for (var s in steps) {
      final updated = s.copyWith(
        completed: false,
        updatedAt: DateTime.now(),
      );
      await _repo.updateStep(updated);
    }
  }

  // -----------------------------
  // MARK STEP COMPLETED
  // -----------------------------
  Future<void> completeStep(String stepId) async {
    final steps = await _repo.getStepsForRoutine(
        (await _repo.getRoutineById(stepId))?.id ?? "");

    for (var s in steps) {
      if (s.id == stepId) {
        final updated = s.copyWith(
          completed: true,
          updatedAt: DateTime.now(),
        );
        await _repo.updateStep(updated);
        break;
      }
    }
  }

  // -----------------------------
  // GET ROUTINE WITH STEPS
  // -----------------------------
  Future<(RoutineModel?, List<RoutineStepModel>)> getRoutineWithSteps(
      String routineId) async {
    final routine = await _repo.getRoutineById(routineId);
    final steps = await _repo.getStepsForRoutine(routineId);
    return (routine, steps);
  }

  // -----------------------------
  // AI INSIGHT FOR ROUTINE
  // -----------------------------
  String generateRoutineInsight(RoutineModel routine) {
    final mode = _modeEngine.currentMode;

    if (routine.emotionalLoad >= 20) {
      return "This routine carries emotional weight. Move gently and stay grounded.";
    }

    if (routine.fatigueImpact >= 20) {
      return "This routine may feel physically demanding. Pace yourself.";
    }

    if (routine.estimatedDuration >= 45) {
      return "This is a longer routine. Protect your time and avoid rushing.";
    }

    switch (mode) {
      case AppMode.recovery:
        return "Your system is in recovery mode. Keep this routine slow and restorative.";
      case AppMode.focus:
        return "A great routine to anchor your focus window.";
      case AppMode.overloaded:
        return "You’re carrying a lot. Consider simplifying this routine today.";
      default:
        return "A balanced routine. Move with intention.";
    }
  }
}
