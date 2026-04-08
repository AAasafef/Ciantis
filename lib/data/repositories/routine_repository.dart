import 'package:cloud_firestore/cloud_firestore.dart';
import '../dao/routine_dao.dart';
import '../models/routine_model.dart';

class RoutineRepository {
  final RoutineDao _dao = RoutineDao.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String _collection = 'routines';

  // -----------------------------
  // ADD ROUTINE
  // -----------------------------
  Future<void> addRoutine(RoutineModel routine) async {
    // Local
    await _dao.insertRoutine(routine);

    // Cloud
    await _firestore.collection(_collection).doc(routine.id).set(
      routine.toFirestore(),
    );
  }

  // -----------------------------
  // UPDATE ROUTINE
  // -----------------------------
  Future<void> updateRoutine(RoutineModel routine) async {
    // Local
    await _dao.updateRoutine(routine);

    // Cloud
    await _firestore.collection(_collection).doc(routine.id).update(
      routine.toFirestore(),
    );
  }

  // -----------------------------
  // DELETE ROUTINE
  // -----------------------------
  Future<void> deleteRoutine(String id) async {
    // Local
    await _dao.deleteRoutine(id);

    // Cloud
    await _firestore.collection(_collection).doc(id).delete();
  }

  // -----------------------------
  // GET ALL ROUTINES
  // -----------------------------
  Future<List<RoutineModel>> getAllRoutines() async {
    // Load local first (fast)
    final local = await _dao.getAllRoutines();

    // Sync cloud → local
    await _syncFromCloud();

    // Return updated local
    return await _dao.getAllRoutines();
  }

  // -----------------------------
  // GET ROUTINE BY ID
  // -----------------------------
  Future<RoutineModel?> getRoutineById(String id) async {
    return await _dao.getRoutineById(id);
  }

  // -----------------------------
  // SYNC CLOUD → LOCAL
  // -----------------------------
  Future<void> _syncFromCloud() async {
    final snapshot = await _firestore.collection(_collection).get();

    for (var doc in snapshot.docs) {
      final routine = RoutineModel.fromFirestore(doc);
      await _dao.insertRoutine(routine);
    }
  }
}
