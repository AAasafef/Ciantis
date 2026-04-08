import 'package:uuid/uuid.dart';
import '../models/habit_model.dart';
import '../repositories/habit_repository.dart';
import 'mode_engine_service.dart';

class HabitService {
  final HabitRepository _repository = HabitRepository();
  final ModeEngineService _modeEngine = ModeEngineService();
  final Uuid _uuid = const Uuid();

  // -----------------------------
  // CREATE HABIT
  // -----------------------------
  Future<void> createHabit({
    required String title,
    String? description,
    required String category,
    required int priority,
    required List<int> days, // 1–7
  }) async {
    final now = DateTime.now();

    final emotionalLoad = _calculateEmotionalLoad(category, priority);
    final fatigueImpact = _calculateFatigueImpact(category, priority);

    final habit = HabitModel(
      id: _uuid.v4(),
      title: title.trim(),
      description: description?.trim(),
      category: category,
      priority: priority,
      emotionalLoad: emotionalLoad,
      fatigueImpact: fatigueImpact,
      days: days,
      active: true,
      streak: 0,
      lastCompletedDate: null,
      createdAt: now,
      updatedAt: now,
    );

    await _repository.addHabit(habit);

    // MODE ENGINE HOOK
    final suggestion = _modeEngine.evaluateModeSuggestion(
      emotionalLoad: emotionalLoad,
      fatigue: fatigueImpact,
      isNight: now.hour >= 19,
    );

    _modeEngine.setSuggestion(suggestion);
  }

  // -----------------------------
  // UPDATE HABIT
  // -----------------------------
  Future<void> updateHabit(HabitModel habit) async {
    final updated = habit.copyWith(
      emotionalLoad: _calculateEmotionalLoad(habit.category, habit.priority),
      fatigueImpact: _calculateFatigueImpact(habit.category, habit.priority),
      updatedAt: DateTime.now(),
    );

    await _repository.updateHabit(updated);

    // MODE ENGINE HOOK
    final suggestion = _modeEngine.evaluateModeSuggestion(
      emotionalLoad: updated.emotionalLoad,
      fatigue: updated.fatigueImpact,
      isNight: DateTime.now().hour >= 19,
    );

    _modeEngine.setSuggestion(suggestion);
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
  // GET ACTIVE HABITS
  // -----------------------------
  Future<List<HabitModel>> getActiveHabits() async {
    return await _repository.getActiveHabits();
  }

  // -----------------------------
  // GET HABITS FOR TODAY
  // -----------------------------
  Future<List<HabitModel>> getHabitsForToday() async {
    final weekday = DateTime.now().weekday; // 1–7
    return await _repository.getHabitsForWeekday(weekday);
  }

  // -----------------------------
  // COMPLETE HABIT (STREAK LOGIC)
  // -----------------------------
  Future<void> completeHabit(String id) async {
    final habit = await _repository.getHabitById(id);
    if (habit == null) return;

    final now = DateTime.now();
    final last = habit.lastCompletedDate;

    int newStreak = habit.streak;

    if (last == null) {
      newStreak = 1;
    } else {
      final lastDay = DateTime(last.year, last.month, last.day);
      final today = DateTime(now.year, now.month, now.day);

      if (today.difference(lastDay).inDays == 1) {
        newStreak += 1; // continued streak
      } else if (today.difference(lastDay).inDays > 1) {
        newStreak = 1; // streak reset
      }
    }

    final updated = habit.copyWith(
      streak: newStreak,
      lastCompletedDate: now,
      updatedAt: now,
    );

    await _repository.updateHabit(updated);

    // MODE ENGINE HOOK
    final suggestion = _modeEngine.evaluateModeSuggestion(
      emotionalLoad: updated.emotionalLoad,
      fatigue: updated.fatigueImpact,
      isNight: now.hour >= 19,
    );

    _modeEngine.setSuggestion(suggestion);
  }

  // -----------------------------
  // SMART HABIT SUGGESTIONS
  // -----------------------------
  Future<List<HabitModel>> getSmartSuggestions() async {
    final habits = await getHabitsForToday();

    habits.sort((a, b) {
      int scoreA = _habitScore(a);
      int scoreB = _habitScore(b);
      return scoreB.compareTo(scoreA);
    });

    return habits.take(5).toList();
  }

  int _habitScore(HabitModel habit) {
    int score = 0;

    // Priority weighting
    score += habit.priority * 10;

    // Emotional load weighting
    score += habit.emotionalLoad * 4;

    // Fatigue impact weighting
    score += habit.fatigueImpact * 3;

    // Streak weighting (encourage consistency)
    score += habit.streak * 2;

    return score;
  }

  // -----------------------------
  // EMOTIONAL LOAD ENGINE
  // -----------------------------
  int _calculateEmotionalLoad(String category, int priority) {
    int base = switch (category) {
      'school' => 6,
      'kids' => 5,
      'salon' => 4,
      'health' => 7,
      'personal' => 3,
      _ => 4,
    };

    base += (priority - 3);

    return base.clamp(1, 10);
  }

  // -----------------------------
  // FATIGUE IMPACT ENGINE
  // -----------------------------
  int _calculateFatigueImpact(String category, int priority) {
    int base = switch (category) {
      'school' => 5,
      'kids' => 6,
      'salon' => 4,
      'health' => 3,
      'personal' => 2,
      _ => 3,
    };

    base += (priority ~/ 2);

    return base.clamp(1, 10);
  }
}
