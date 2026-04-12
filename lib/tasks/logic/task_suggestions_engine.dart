import '../models/task.dart';
import '../analytics/task_insights_engine.dart';
import 'task_filtering_engine.dart';
import 'task_sorting_engine.dart';

/// TaskSuggestionsEngine provides intelligent, context-aware
/// task recommendations.
///
/// This powers:
/// - Next Best Action
/// - Daily Planning
/// - Smart Suggestions
/// - Mode-aware recommendations
class TaskSuggestionsEngine {
  // Singleton
  static final TaskSuggestionsEngine instance =
      TaskSuggestionsEngine._internal();
  TaskSuggestionsEngine._internal();

  final _filter = TaskFilteringEngine.instance;
  final _sort = TaskSortingEngine.instance;
  final _insights = TaskInsightsEngine.instance;

  // -----------------------------
  // NEXT BEST ACTION
  // -----------------------------
  Task? nextBestAction(List<Task> tasks, DateTime now) {
    if (tasks.isEmpty) return null;

    final insights = _insights.build(tasks, now);

    // 1. If pressure is high → prioritize overdue + high priority
    if (insights.pressureScore > 70) {
      final overdue = _filter.overdue(tasks, now);
      if (overdue.isNotEmpty) {
        return _sort.sort(overdue).first;
      }

      final high = _filter.highPriority(tasks);
      if (high.isNotEmpty) {
        return _sort.sort(high).first;
      }
    }

    // 2. If relief is high → suggest low-energy or flexible tasks
    if (insights.reliefScore > 60) {
      final lowEnergy = _filter.lowEnergy(tasks);
      if (lowEnergy.isNotEmpty) {
        return _sort.sort(lowEnergy).first;
      }

      final flexible = _filter.flexible(tasks);
      if (flexible.isNotEmpty) {
        return _sort.sort(flexible).first;
      }
    }

    // 3. Default → sorted list
    final sorted = _sort.sort(tasks);
    return sorted.firstWhere((t) => !t.isCompleted, orElse: () => sorted.first);
  }

  // -----------------------------
  // SUGGESTIONS LIST (TOP 5)
  // -----------------------------
  List<Task> suggestions(List<Task> tasks, DateTime now) {
    if (tasks.isEmpty) return [];

    final insights = _insights.build(tasks, now);

    final List<Task> pool = [];

    // 1. Overdue tasks (if pressure is high)
    if (insights.pressureScore > 60) {
      pool.addAll(_filter.overdue(tasks, now));
    }

    // 2. High priority tasks
    pool.addAll(_filter.highPriority(tasks));

    // 3. Low energy tasks (if user is likely fatigued)
    pool.addAll(_filter.lowEnergy(tasks));

    // 4. Flexible tasks (good fillers)
    pool.addAll(_filter.flexible(tasks));

    // 5. Fallback: everything
    pool.addAll(tasks);

    // Remove completed + dedupe
    final unique = {
      for (final t in pool)
        if (!t.isCompleted) t.id: t
    }.values.toList();

    // Sort and return top 5
    return _sort.sort(unique).take(5).toList();
  }

  // -----------------------------
  // MODE-AWARE SUGGESTIONS
  // (Fatigue, Focus, Recovery)
  // -----------------------------
  List<Task> modeAwareSuggestions({
    required List<Task> tasks,
    required DateTime now,
    required String mode, // "focus", "fatigue", "recovery"
  }) {
    switch (mode) {
      case "focus":
        return _sort.sort(_filter.highPriority(tasks)).take(5).toList();

      case "fatigue":
        return _sort.sort(_filter.lowEnergy(tasks)).take(5).toList();

      case "recovery":
        return _sort.sort(_filter.flexible(tasks)).take(5).toList();

      default:
        return suggestions(tasks, now);
    }
  }
}
