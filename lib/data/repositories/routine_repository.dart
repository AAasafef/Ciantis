import '../dao/routine_dao.dart';
import '../models/routine_model.dart';

class RoutineRepository {
  final RoutineDao _dao = RoutineDao();

  // -----------------------------
  // ADD ROUTINE
  // -----------------------------
  Future<void> addRoutine(RoutineModel routine) async {
    await _dao.insertRoutine(routine);
  }

  // -----------------------------
  // UPDATE ROUTINE
  // -----------------------------
  Future<void> updateRoutine(RoutineModel routine) async {
    await _dao.updateRoutine(routine);
  }

  // -----------------------------
  // DELETE ROUTINE
  // -----------------------------
  Future<void> deleteRoutine(String id) async {
    await _dao.deleteRoutine(id);
  }

  // -----------------------------
  // GET ALL ROUTINES
  // -----------------------------
  Future<List<RoutineModel>> getAllRoutines() async {
    return await _dao.getAllRoutines();
  }

  // -----------------------------
  // GET ROUTINE BY ID
  // -----------------------------
  Future<RoutineModel?> getRoutineById(String id) async {
    return await _dao.getRoutineById(id);
  }
}
