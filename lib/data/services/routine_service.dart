import 'package:uuid/uuid.dart';
import '../models/routine_model.dart';
import '../repositories/routine_repository.dart';

class RoutineService {
  final RoutineRepository _repository = RoutineRepository();
  final Uuid _uuid = const Uuid();

  // -----------------------------
  // CREATE ROUTINE
  // -----------------------------
  Future<void> createRoutine({
    required String title,
    String? description,
    required String category,
    required List<Map<String, dynamic>> stepsData,
  }) async {
    final now = DateTime.now();

    // Convert raw step data into RoutineStep objects
    final steps = stepsData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;

      return RoutineStep(
        id: _uuid.v4(),
        title: data['title'],
        durationMinutes: data['durationMinutes'],
        isCompleted: false,
        emotionalNote: null,
        order: index,
      );
    }).toList();

    final routine = RoutineModel(
      id: _uuid.v4(),
      title: title.trim(),
      description: description?.trim(),
      category: category,
      steps: steps,
      createdAt: now,
      updatedAt: now,
    );

    await _repository.addRoutine(routine);
  }

  // -----------------------------
  // UPDATE ROUTINE
  // -----------------------------
  Future<void> updateRoutine(RoutineModel routine) async {
    final updated = RoutineModel(
      id: routine.id,
      title: routine.title,
      description: routine.description,
      category: routine.category,
      steps: routine.steps,
      createdAt: routine.createdAt,
      updatedAt: DateTime.now(),
    );

    await _repository.updateRoutine(updated);
  }

  // -----------------------------
  // UPDATE STEPS
  // -----------------------------
  Future<void> updateSteps(String routineId, List<RoutineStep> steps) async {
    final routine = await _repository.getRoutineById(routineId);
    if (routine == null) return;

    final updated = RoutineModel(
      id: routine.id,
      title: routine.title,
      description: routine.description,
      category: routine.category,
      steps: steps,
      createdAt: routine.createdAt,
      updatedAt: DateTime.now(),
    );

    await _repository.updateRoutine(updated);
  }

  // -----------------------------
  // TOGGLE STEP COMPLETION
  // -----------------------------
  Future<void> toggleStep(String routineId, RoutineStep step) async {
    final routine = await _repository.getRoutineById(routineId);
    if (routine == null) return;

    final updatedSteps = routine.steps.map((s) {
      if (s.id == step.id) {
        return RoutineStep(
          id: s.id,
          title: s.title,
          durationMinutes: s.durationMinutes,
          isCompleted: !s.isCompleted,
          emotionalNote: s.emotionalNote,
          order: s.order,
        );
      }
      return s;
    }).toList();

    await updateSteps(routineId, updatedSteps);
  }

  // -----------------------------
  // DELETE ROUTINE
  // -----------------------------
  Future<void> deleteRoutine(String id) async {
    await _repository.deleteRoutine(id);
  }

  // -----------------------------
  // GET ALL ROUTINES
  // -----------------------------
  Future<List<RoutineModel>> getAllRoutines() async {
    return await _repository.getAllRoutines();
  }

  // -----------------------------
  // GET ROUTINE BY ID
  // -----------------------------
  Future<RoutineModel?> getRoutineById(String id) async {
    return await _repository.getRoutineById(id);
  }
}
