import '../dao/routine_dao.dart';
import '../models/routine_model.dart';

class RoutineRepository {
  final RoutineDao dao;

  RoutineRepository(this.dao);

  // Create
  Future<void> createRoutine(RoutineModel routine) async {
    await dao.insert(routine);
  }

  // Update
  Future<void> updateRoutine(RoutineModel routine) async {
    await dao.update(routine);
  }

  // Delete
  Future<void> deleteRoutine(String id) async {
    await dao.delete(id);
  }

  // Get by ID
  Future<RoutineModel?> getRoutineById(String id) async {
    return await dao.getById(id);
  }

  // Get all routines
  Future<List<RoutineModel>> getAllRoutines() async {
    return await dao.getAll();
  }

  // Get active routines
  Future<List<RoutineModel>> getActiveRoutines() async {
    return await dao.getActive();
  }

  // Get routines by category
  Future<List<RoutineModel>> getRoutinesByCategory(String category) async {
    final all = await dao.getAll();
    return all.where((r) => r.category == category).toList();
  }

  // Update streak
  Future<void> updateStreak({
    required String id,
    required int streak,
    required DateTime? lastCompletedAt,
  }) async {
    await dao.updateStreak(id, streak, lastCompletedAt);
  }

  // Replace steps
  Future<void> updateSteps(String routineId, List<RoutineStepModel> steps) async {
    final routine = await dao.getById(routineId);
    if (routine == null) return;

    final updated = routine.copyWith(steps: steps);
    await dao.update(updated);
  }

  // Add a step
  Future<void> addStep(String routineId, RoutineStepModel step) async {
    final routine = await dao.getById(routineId);
    if (routine == null) return;

    final updatedSteps = [...routine.steps, step];
    final updated = routine.copyWith(steps: updatedSteps);

    await dao.update(updated);
  }

  // Remove a step
  Future<void> removeStep(String routineId, String stepId) async {
    final routine = await dao.getById(routineId);
    if (routine == null) return;

    final updatedSteps =
        routine.steps.where((s) => s.id != stepId).toList();

    final updated = routine.copyWith(steps: updatedSteps);

    await dao.update(updated);
  }

  // Reorder steps
  Future<void> reorderSteps(String routineId, List<RoutineStepModel> steps) async {
    final routine = await dao.getById(routineId);
    if (routine == null) return;

    final updated = routine.copyWith(steps: steps);
    await dao.update(updated);
  }
}
