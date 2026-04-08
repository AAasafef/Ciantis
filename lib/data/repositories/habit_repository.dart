import 'package:cloud_firestore/cloud_firestore.dart';
import '../dao/habit_dao.dart';
import '../models/habit_model.dart';

class HabitRepository {
  final HabitDao _dao = HabitDao.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String _collection = 'habits';

  // -----------------------------
  // ADD HABIT
  // -----------------------------
  Future<void> addHabit(HabitModel habit) async {
    // Local
    await _dao.insertHabit(habit);

    // Cloud
    await _firestore.collection(_collection).doc(habit.id).set(
      habit.toFirestore(),
    );
  }

  // -----------------------------
  // UPDATE HABIT
  // -----------------------------
  Future<void> updateHabit(HabitModel habit) async {
    // Local
    await _dao.updateHabit(habit);

    // Cloud
    await _firestore.collection(_collection).doc(habit.id).update(
      habit.toFirestore(),
    );
  }

  // -----------------------------
  // DELETE HABIT
  // -----------------------------
  Future<void> deleteHabit(String id) async {
    // Local
    await _dao.deleteHabit(id);

    // Cloud
    await _firestore.collection(_collection).doc(id).delete();
  }

  // -----------------------------
  // GET ALL HABITS
  // -----------------------------
  Future<List<HabitModel>> getAllHabits() async {
    // Load local first (fast)
    final local = await _dao.getAllHabits();

    // Sync cloud → local
    await _syncFromCloud();

    // Return updated local
    return await _dao.getAllHabits();
  }

  // -----------------------------
  // GET HABIT BY ID
  // -----------------------------
  Future<HabitModel?> getHabitById(String id) async {
    return await _dao.getHabitById(id);
  }

  // -----------------------------
  // SYNC CLOUD → LOCAL
  // -----------------------------
  Future<void> _syncFromCloud() async {
    final snapshot = await _firestore.collection(_collection).get();

    for (var doc in snapshot.docs) {
      final habit = HabitModel.fromFirestore(doc);
      await _dao.insertHabit(habit);
    }
  }
}
