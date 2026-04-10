import '../../data/models/task_model.dart';
import '../ai/task_ai_scoring_engine.dart';
import 'task_modes.dart';
import 'task_mode_activation_engine.dart';

/// TaskModeFilterEngine filters tasks based on the active mode.
/// 
/// This engine:
/// - Applies mode strengths
/// - Avoids mode weaknesses
/// - Filters by emotional load
/// - Filters by fatigue impact
/// - Filters by difficulty
/// - Filters by time sensitivity
/// - Filters by priority
///
/// It does NOT rank tasks.
/// It ONLY filters them.
class TaskModeFilterEngine {
  // Singleton
  static final TaskModeFilterEngine instance =
      TaskModeFilterEngine._internal();
  TaskModeFilterEngine._internal();

  final _activation = TaskModeActivationEngine.instance;
  final _scoring = TaskAIScoringEngine.instance;

  // -----------------------------
  // FILTER TASKS FOR A GIVEN MODE
  // -----------------------------
  List<TaskModel> filterForMode(TaskMode mode, List<TaskModel> tasks) {
    final List<TaskModel> filtered = [];

    for (final task in tasks) {
      if (_shouldInclude(task, mode)) {
        filtered.add(task);
      }
    }

    return filtered;
  }

  // -----------------------------
  // SHOULD INCLUDE TASK?
  // -----------------------------
  bool _shouldInclude(TaskModel task, TaskMode mode) {
    final difficulty = _scoring.difficulty(task);
    final stress = _scoring.stress(task);
    final readiness = _scoring.readiness(task);
    final time = _scoring.timeSensitivity(task);

    // -----------------------------
    // MODE-SPECIFIC FILTERING
    // -----------------------------
    switch (mode.id) {
      case "focus":
        return _focusFilter(task, difficulty, stress, readiness, time);

      case "light":
        return _lightFilter(task, difficulty, stress, readiness, time);

      case "power":
        return _powerFilter(task, difficulty, stress, readiness, time);

      case "reset":
        return _resetFilter(task, difficulty, stress, readiness, time);

      case "emotional":
        return _emotionalFilter(task, difficulty, stress, readiness, time);

      default:
        return true;
    }
  }

  // -----------------------------
  // FOCUS MODE FILTER
  // -----------------------------
  bool _focusFilter(TaskModel task, double difficulty, double stress,
      double readiness, double time) {
    if (difficulty < 4) return false;
    if (task.emotionalLoad >= 7) return false;
    if (task.fatigueImpact >= 7) return false;
    return true;
  }

  // -----------------------------
  // LIGHT MODE FILTER
  // -----------------------------
  bool _lightFilter(TaskModel task, double difficulty, double stress,
      double readiness, double time) {
    if (difficulty >= 5) return false;
    if (stress >= 6) return false;
    if (task.emotionalLoad >= 6) return false;
    return true;
  }

  // -----------------------------
  // POWER MODE FILTER
  // -----------------------------
  bool _powerFilter(TaskModel task, double difficulty, double stress,
      double readiness, double time) {
    if (difficulty >= 7) return false;
    if (task.fatigueImpact >= 6) return false;
    if (task.emotionalLoad >= 6) return false;
    return true;
  }

  // -----------------------------
  // RESET MODE FILTER
  // -----------------------------
  bool _resetFilter(TaskModel task, double difficulty, double stress,
      double readiness, double time) {
    if (difficulty >= 5) return false;
    if (task.emotionalLoad >= 6) return false;
    if (task.priority >= 4) return false;
    return true;
  }

  // -----------------------------
  // EMOTIONAL MODE FILTER
  // -----------------------------
  bool _emotionalFilter(TaskModel task, double difficulty, double stress,
      double readiness, double time) {
    if (task.emotionalLoad < 5) return false;
    if (task.fatigueImpact >= 7) return false;
    if (difficulty >= 6) return false;
    return true;
  }

  // -----------------------------
  // MAIN ENTRY: FILTER USING ACTIVE MODE
  // -----------------------------
  List<TaskModel> filterActiveMode(List<TaskModel> tasks) {
    final mode = _activation.selectMode(tasks);
    return filterForMode(mode, tasks);
  }

  // -----------------------------
  // HUMAN-READABLE SUMMARY
  // -----------------------------
  String filterSummary(List<TaskModel> tasks) {
    final mode = _activation.selectMode(tasks);
    final filtered = filterForMode(mode, tasks);

    return """
Active Mode: ${mode.name}
Filtered Tasks: ${filtered.length} / ${tasks.length}

Mode Strengths:
• ${mode.strengths.join("\n• ")}

Mode Avoids:
• ${mode.avoidFor.join("\n• ")}
""".trim();
  }
}
