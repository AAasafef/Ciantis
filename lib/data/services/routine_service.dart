import 'package:uuid/uuid.dart';
import '../models/routine_model.dart';
import '../repositories/routine_repository.dart';
import 'mode_engine_service.dart';

class RoutineService {
  final RoutineRepository _repository = RoutineRepository();
  final ModeEngineService _modeEngine = ModeEngineService();
  final Uuid _uuid = const Uuid();

  // -----------------------------
  // CREATE ROUTINE
  // -----------------------------
  Future<void> createRoutine({
    required String title,
    String? description,
    required String category,
    required int priority,
    required List<RoutineStepModel> steps,
  }) async {
    final now = DateTime.now();

    // Calculate routine-level emotional + fatigue load
    final emotionalLoad = _calculateRoutineEmotionalLoad(steps);
    final fatigueImpact = _calculateRoutineFatigueImpact(steps);

    final routine = RoutineModel(
      id: _uuid.v4(),
      title: title.trim(),
      description: description?.trim(),
      category: category,
      priority: priority,
      emotionalLoad: emotionalLoad,
      fatigueImpact: fatigueImpact,
      steps: steps,
      active: true,
      streak: 0,
      lastCompletedDate: null,
      createdAt: now,
      updatedAt: now,
    );

    await _repository.addRoutine(routine);

    // MODE ENGINE HOOK
    final suggestion = _modeEngine.evaluateModeSuggestion(
      emotionalLoad: emotionalLoad,
      fatigue: fatigueImpact,
      isNight: now.hour >= 19,
    );

    _modeEngine.setSuggestion(suggestion);
  }

  // -----------------------------
  // UPDATE ROUTINE
  // -----------------------------
  Future<void> updateRoutine(RoutineModel routine) async {
    final updated = routine.copyWith(
      emotionalLoad: _calculateRoutineEmotionalLoad(routine.steps),
      fatigueImpact: _calculateRoutineFatigueImpact(routine.steps),
      updatedAt: DateTime.now(),
    );

    await _repository.updateRoutine(updated);

    // MODE ENGINE HOOK
    final suggestion = _modeEngine.evaluateModeSuggestion(
      emotionalLoad: updated.emotionalLoad,
      fatigue: updated.fatigueImpact,
      isNight: DateTime.now().hour >= 19,
    );

    _modeEngine.setSuggestion(suggestion);
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

  // -----------------------------
  // COMPLETE ROUTINE (STREAK LOGIC)
  // -----------------------------
  Future<void> completeRoutine(String id) async {
    final routine = await _repository.getRoutineById(id);
    if (routine == null) return;

    final now = DateTime.now();
    final last = routine.lastCompletedDate;

    int newStreak = routine.streak;

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

    final updated = routine.copyWith(
      streak: newStreak,
      lastCompletedDate: now,
      updatedAt: now,
    );

    await _repository.updateRoutine(updated);

    // MODE ENGINE HOOK
    final suggestion = _modeEngine.evaluateModeSuggestion(
      emotionalLoad: updated.emotionalLoad,
      fatigue: updated.fatigueImpact,
      isNight: now.hour >= 19,
    );

    _modeEngine.setSuggestion(suggestion);
  }

  // -----------------------------
  // SMART ROUTINE SUGGESTIONS
  // -----------------------------
  Future<List<RoutineModel>> getSmartSuggestions() async {
    final routines = await getAllRoutines();

    routines.sort((a, b) {
      int scoreA = _routineScore(a);
      int scoreB = _routineScore(b);
      return scoreB.compareTo(scoreA);
    });

    return routines.take(5).toList();
  }

  int _routineScore(RoutineModel routine) {
    int score = 0;

    // Priority weighting
    score += routine.priority * 10;

    // Emotional load weighting
    score += routine.emotionalLoad * 4;

    // Fatigue impact weighting
    score += routine.fatigueImpact * 3;

    // Streak weighting
    score += routine.streak * 2;

    // Step count weighting (shorter routines get a slight boost)
    score += (10 - routine.steps.length);

    return score;
  }

  // -----------------------------
  // ROUTINE EMOTIONAL LOAD ENGINE
  // -----------------------------
  int _calculateRoutineEmotionalLoad(List<RoutineStepModel> steps) {
    if (steps.isEmpty) return 1;
    final total = steps.fold<int>(0, (sum, s) => sum + s.emotionalLoad);
    return (total / steps.length).round().clamp(1, 10);
  }

  // -----------------------------
  // ROUTINE FATIGUE IMPACT ENGINE
  // -----------------------------
  int _calculateRoutineFatigueImpact(List<RoutineStepModel> steps) {
    if (steps.isEmpty) return 1;
    final total = steps.fold<int>(0, (sum, s) => sum + s.fatigueImpact);
    return (total / steps.length).round().clamp(1, 10);
  }

  // -----------------------------
  // CREATE ROUTINE STEP
  // -----------------------------
  RoutineStepModel createStep({
    required String title,
    required int order,
    required int durationMinutes,
    required int emotionalLoad,
    required int fatigueImpact,
  }) {
    return RoutineStepModel(
      id: _uuid.v4(),
      title: title.trim(),
      order: order,
      durationMinutes: durationMinutes,
      emotionalLoad: emotionalLoad.clamp(1, 10),
      fatigueImpact: fatigueImpact.clamp(1, 10),
    );
  }
}
