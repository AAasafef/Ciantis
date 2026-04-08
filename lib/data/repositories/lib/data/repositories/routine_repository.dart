import '../dao/routine_dao.dart';
import '../models/routine_model.dart';
import '../models/routine_step_model.dart';

class RoutineRepository {
  final RoutineDao _dao = RoutineDao();

  // -----------------------------
  // ROUTINES
  // -----------------------------
  Future<void> addRoutine(RoutineModel routine) async {
    await _dao.insertRoutine(routine);
  }

  Future<void> updateRoutine(RoutineModel routine) async {
    await _dao.updateRoutine(routine);
  }

  Future<void> deleteRoutine(String id) async {
    await _dao.deleteRoutine(id);
  }

  Future<List<RoutineModel>> getAllRoutines() async {
    return await _dao.getAllRoutines();
  }

  Future<RoutineModel?> getRoutineById(String id) async {
    return await _dao.getRoutineById(id);
  }

  // -----------------------------
  // STEPS
  // -----------------------------
  Future<void> addStep(RoutineStepModel step) async {
    await _dao.insertStep(step);
  }

  Future<void> updateStep(RoutineStepModel step) async {
    await _dao.updateStep(step);
  }

  Future<void> deleteStep(String id) async {
    await _dao.deleteStep(id);
  }

  Future<List<RoutineStepModel>> getStepsForRoutine(String routineId) async {
    return await _dao.getStepsForRoutine(routineId);
  }
}
