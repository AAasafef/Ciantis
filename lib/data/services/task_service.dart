import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';
import 'mode_engine_service.dart';

class TaskService {
  final TaskRepository _repository = TaskRepository();
  final ModeEngineService _modeEngine = ModeEngineService();
  final Uuid _uuid = const Uuid();

  // -----------------------------
  // CREATE TASK
  // -----------------------------
  Future<void> createTask({
    required String title,
    String? description,
    required String category,
    required int priority,
    required int emotionalLoad,
    required int fatigueImpact,
    DateTime? dueDate,
  }) async {
    final now = DateTime.now();

    final task = TaskModel(
      id: _uuid.v4(),
      title: title.trim(),
      description: description?.trim(),
      category: category,
      priority: priority,
      emotionalLoad: emotionalLoad.clamp(1, 10),
      fatigueImpact: fatigueImpact.clamp(1, 10),
      dueDate: dueDate,
      completed: false,
      streak: 0,
      lastCompletedDate: null,
      createdAt: now,
      updatedAt: now,
    );

    await _repository.addTask(task);

    // MODE ENGINE HOOK
    final suggestion = _modeEngine.evaluateModeSuggestion(
      emotionalLoad: emotionalLoad,
      fatigue: fatigueImpact,
      isNight: now.hour >= 19,
    );

    _modeEngine.setSuggestion(suggestion);
  }

  // -----------------------------
  // UPDATE TASK
  // -----------------------------
  Future<void> updateTask(TaskModel task) async {
    final updated = task.copyWith(
      updatedAt: DateTime.now(),
    );

    await _repository.updateTask(updated);

    // MODE ENGINE HOOK
    final suggestion = _modeEngine.evaluateModeSuggestion(
      emotionalLoad: updated.emotionalLoad,
      fatigue: updated.fatigueImpact,
      isNight: DateTime.now().hour >= 19,
    );

    _modeEngine.setSuggestion(suggestion);
  }

  // -----------------------------
  // DELETE TASK
  // -----------------------------
  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
  }

  // -----------------------------
  // GET ALL TASKS
  // -----------------------------
  Future<List<TaskModel>> getAllTasks() async {
    return await _repository.getAllTasks();
  }

  // -----------------------------
  // GET TASK BY ID
  // -----------------------------
  Future<TaskModel?> getTaskById(String id) async {
    return await _repository.getTaskById(id);
  }

  // -----------------------------
  // COMPLETE TASK (STREAK LOGIC)
  // -----------------------------
  Future<void> completeTask(String id) async {
    final task = await _repository.getTaskById(id);
    if (task == null) return;

    final now = DateTime.now();
    final last = task.lastCompletedDate;

    int newStreak = task.streak;

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

    final updated = task.copyWith(
      completed: true,
      streak: newStreak,
      lastCompletedDate: now,
      updatedAt: now,
    );

    await _repository.updateTask(updated);

    // MODE ENGINE HOOK
    final suggestion = _modeEngine.evaluateModeSuggestion(
      emotionalLoad: updated.emotionalLoad,
      fatigue: updated.fatigueImpact,
      isNight: now.hour >= 19,
    );

    _modeEngine.setSuggestion(suggestion);
  }

  // -----------------------------
  // SMART TASK SUGGESTIONS
  // -----------------------------
  Future<List<TaskModel>> getSmartSuggestions() async {
    final tasks = await getAllTasks();

    tasks.sort((a, b) {
      int scoreA = _taskScore(a);
      int scoreB = _taskScore(b);
      return scoreB.compareTo(scoreA);
    });

    return tasks.take(5).toList();
  }

  int _taskScore(TaskModel task) {
    int score = 0;

    // Priority weighting
    score += task.priority * 10;

    // Emotional load weighting
    score += task.emotionalLoad * 4;

    // Fatigue impact weighting
    score += task.fatigueImpact * 3;

    // Streak weighting
    score += task.streak * 2;

    // Due date weighting (sooner = higher score)
    if (task.dueDate != null) {
      final diff = task.dueDate!.difference(DateTime.now()).inHours;
      if (diff <= 0) {
        score += 50; // overdue = urgent
      } else {
        score += (100 ~/ diff.clamp(1, 100)); // closer = higher
      }
    }

    return score;
  }
}
