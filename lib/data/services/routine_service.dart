import '../models/routine_model.dart';
import '../repositories/routine_repository.dart';

class RoutineService {
  final RoutineRepository repository;

  RoutineService(this.repository);

  // Create a new routine
  Future<void> createRoutine({
    required String title,
    String? description,
    required String category,
    List<RoutineStepModel> steps = const [],
  }) async {
    final routine = RoutineModel(
      title: title,
      description: description,
      category: category,
      steps: steps,
      emotionalLoad: _computeEmotionalLoad(steps),
      fatigueImpact: _computeFatigueImpact(steps),
    );

    await repository.createRoutine(routine);
  }

  // Update routine
  Future<void> updateRoutine(RoutineModel routine) async {
    final updated = routine.copyWith(
      emotionalLoad: _computeEmotionalLoad(routine.steps),
      fatigueImpact: _computeFatigueImpact(routine.steps),
      updatedAt: DateTime.now(),
    );

    await repository.updateRoutine(updated);
  }

  // Delete routine
  Future<void> deleteRoutine(String id) async {
    await repository.deleteRoutine(id);
  }

  // Get by ID
  Future<RoutineModel?> getRoutineById(String id) async {
    return await repository.getRoutineById(id);
  }

  // Get all routines
  Future<List<RoutineModel>> getAllRoutines() async {
    return await repository.getAllRoutines();
  }

  // Get active routines
  Future<List<RoutineModel>> getActiveRoutines() async {
    return await repository.getActiveRoutines();
  }

  // Get routines by category
  Future<List<RoutineModel>> getRoutinesByCategory(String category) async {
    return await repository.getRoutinesByCategory(category);
  }

  // Add a step
  Future<void> addStep(String routineId, RoutineStepModel step) async {
    await repository.addStep(routineId, step);
  }

  // Remove a step
  Future<void> removeStep(String routineId, String stepId) async {
    await repository.removeStep(routineId, stepId);
  }

  // Reorder steps
  Future<void> reorderSteps(String routineId, List<RoutineStepModel> steps) async {
    await repository.reorderSteps(routineId, steps);
  }

  // Mark a step as completed
  Future<void> completeStep(String routineId, String stepId) async {
    final routine = await repository.getRoutineById(routineId);
    if (routine == null) return;

    final updatedSteps = routine.steps.map((s) {
      if (s.id == stepId) {
        return s.copyWith(isCompleted: true);
      }
      return s;
    }).toList();

    final updatedRoutine = routine.copyWith(
      steps: updatedSteps,
      emotionalLoad: _computeEmotionalLoad(updatedSteps),
      fatigueImpact: _computeFatigueImpact(updatedSteps),
    );

    await repository.updateRoutine(updatedRoutine);
  }

  // Mark entire routine as completed
  Future<void> completeRoutine(String routineId) async {
    final routine = await repository.getRoutineById(routineId);
    if (routine == null) return;

    final now = DateTime.now();
    int newStreak = routine.streak;

    // Streak logic: if last completed yesterday or today, continue streak
    if (routine.lastCompletedAt != null) {
      final diff = now.difference(routine.lastCompletedAt!).inDays;
      if (diff == 1) newStreak += 1;
      else if (diff > 1) newStreak = 1;
    } else {
      newStreak = 1;
    }

    await repository.updateStreak(
      id: routineId,
      streak: newStreak,
      lastCompletedAt: now,
    );
  }

  // Compute emotional load (average)
  int _computeEmotionalLoad(List<RoutineStepModel> steps) {
    if (steps.isEmpty) return 3;
    final total = steps.fold(0, (sum, s) => sum + s.emotionalLoad);
    return (total / steps.length).round();
  }

  // Compute fatigue impact (average)
  int _computeFatigueImpact(List<RoutineStepModel> steps) {
    if (steps.isEmpty) return 3;
    final total = steps.fold(0, (sum, s) => sum + s.fatigueImpact);
    return (total / steps.length).round();
  }
}
