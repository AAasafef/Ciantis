import 'package:uuid/uuid.dart';
import '../models/habit_model.dart';
import '../repositories/habit_repository.dart';

class HabitService {
  final HabitRepository _repository = HabitRepository();
  final Uuid _uuid = const Uuid();

  // -----------------------------
  // CREATE HABIT
  // -----------------------------
  Future<void> createHabit({
    required String title,
    String? description,
    required String frequency, // daily, weekly, custom
    List<int>? targetDays, // for weekly habits
  }) async {
    final now = DateTime.now();

    final habit = HabitModel(
      id: _uuid.v4(),
      title: title.trim(),
      description: description?.trim(),
      frequency: frequency,
      targetDays: targetDays,
      streakCount: 0,
      lastCompletedDate: null,
      createdAt: now,
      updatedAt: now,
    );

    await _repository.addHabit(habit);
  }

  // -----------------------------
  // UPDATE HABIT
  // -----------------------------
  Future<void> updateHabit(HabitModel habit) async {
    final updated = HabitModel(
      id: habit.id,
      title: habit.title,
      description: habit.description,
      frequency: habit.frequency,
      targetDays: habit.targetDays,
      streakCount: habit.streakCount,
      lastCompletedDate: habit.lastCompletedDate,
      createdAt: habit.createdAt,
      updatedAt: DateTime.now(),
    );

    await _repository.updateHabit(updated);
  }

  // -----------------------------
  // DELETE HABIT
  // -----------------------------
  Future<void> deleteHabit(String id) async {
    await _repository.deleteHabit(id);
  }

  // -----------------------------
  // GET ALL HABITS
  // -----------------------------
  Future<List<HabitModel>> getAllHabits() async {
    return await _repository.getAllHabits();
  }

  // -----------------------------
  // GET HABIT BY ID
  // -----------------------------
  Future<HabitModel?> getHabitById(String id) async {
    return await _repository.getHabitById(id);
  }

  // -----------------------------
  // MARK HABIT AS COMPLETED
  // -----------------------------
  Future<void> completeHabit(String habitId) async {
    final habit = await _repository.getHabitById(habitId);
    if (habit == null) return;

    final now = DateTime.now();
    final last = habit.lastCompletedDate;

    int newStreak = habit.streakCount;

    // If never completed before → streak starts at 1
    if (last == null) {
      newStreak = 1;
    } else {
      final difference = now.difference(last).inDays;

      if (difference == 1) {
        // Completed yesterday → streak continues
        newStreak = habit.streakCount + 1;
      } else if (difference > 1) {
        // Missed a day → streak resets
        newStreak = 1;
      }
    }

    final updated = HabitModel(
      id: habit.id,
      title: habit.title,
      description: habit.description,
      frequency: habit.frequency,
      targetDays: habit.targetDays,
      streakCount: newStreak,
      lastCompletedDate: now,
      createdAt: habit.createdAt,
      updatedAt: now,
    );

    await _repository.updateHabit(updated);
  }

  // -----------------------------
  // CHECK IF HABIT IS DUE TODAY
  // -----------------------------
  bool isHabitDueToday(HabitModel habit) {
    final now = DateTime.now();

    if (habit.frequency == 'daily') {
      return true;
    }

    if (habit.frequency == 'weekly') {
      if (habit.targetDays == null) return false;
      return habit.targetDays!.contains(now.weekday);
    }

    // Custom logic can be expanded later
    return true;
  }
}
