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
    DateTime? dueDate,
    required String category,
    required int priority,
  }) async {
    final now = DateTime.now();

    final emotionalLoad = _calculateEmotionalLoad(category, priority);
    final fatigueImpact = _calculateFatigueImpact(category, priority);

    final task = TaskModel(
      id: _uuid.v4(),
      title: title.trim(),
      description: description?.trim(),
      dueDate: dueDate,
      completed: false,
      category: category,
      priority: priority,
      emotionalLoad: emotionalLoad,
      fatigueImpact: fatigueImpact,
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
      emotionalLoad: _calculateEmotionalLoad(task.category, task.priority),
      fatigueImpact: _calculateFatigueImpact(task.category, task.priority),
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
  // GET TASKS BY CATEGORY
  // -----------------------------
  Future<List<TaskModel>> getTasksByCategory(String category) async {
    return await _repository.getTasksByCategory(category);
  }

  // -----------------------------
  // GET OVERDUE TASKS
  // -----------------------------
  Future<List<TaskModel>> getOverdueTasks() async {
    return await _repository.getOverdueTasks(DateTime.now());
  }

  // -----------------------------
  // GET TASKS FOR SPECIFIC DATE
  // -----------------------------
  Future<List<TaskModel>> getTasksForDate(DateTime date) async {
    return await _repository.getTasksForDate(date);
  }

  // -----------------------------
  // SMART TASK SUGGESTIONS
  // -----------------------------
  Future<List<TaskModel>> getSmartSuggestions() async {
    final tasks = await _repository.getAllTasks();

    // Prioritize:
    // 1. Overdue tasks
    // 2. High priority tasks
    // 3. High emotional load tasks
    // 4. Tasks due soon
    tasks.sort((a, b) {
      int scoreA = _taskScore(a);
      int scoreB = _taskScore(b);
      return scoreB.compareTo(scoreA);
    });

    return tasks.take(5).toList();
  }

  int _taskScore(TaskModel task) {
    int score = 0;

    // Overdue = highest urgency
    if (task.dueDate != null && task.dueDate!.isBefore(DateTime.now())) {
      score += 50;
    }

    // Priority weighting
    score += task.priority * 10;

    // Emotional load weighting
    score += task.emotionalLoad * 4;

    // Fatigue impact weighting
    score += task.fatigueImpact * 3;

    // Due soon weighting
    if (task.dueDate != null) {
      final diff = task.dueDate!.difference(DateTime.now()).inHours;
      if (diff < 24) score += 20;
      if (diff < 72) score += 10;
    }

    return score;
  }

  // -----------------------------
  // EMOTIONAL LOAD ENGINE
  // -----------------------------
  int _calculateEmotionalLoad(String category, int priority) {
    int base = switch (category) {
      'school' => 7,
      'kids' => 6,
      'salon' => 5,
      'health' => 8,
      'personal' => 3,
      _ => 4,
    };

    base += (priority - 3); // priority 1–5 shifts emotional weight

    return base.clamp(1, 10);
  }

  // -----------------------------
  // FATIGUE IMPACT ENGINE
  // -----------------------------
  int _calculateFatigueImpact(String category, int priority) {
    int base = switch (category) {
      'school' => 6,
      'kids' => 7,
      'salon' => 5,
      'health' => 4,
      'personal' => 2,
      _ => 3,
    };

    base += (priority ~/ 2);

    return base.clamp(1, 10);
  }
}
