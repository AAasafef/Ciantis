import '../../data/models/task_model.dart';

/// TaskAIPatternEngine detects behavioral patterns in tasks.
/// This engine is used by:
/// - Mode Engine
/// - Next Best Action Engine
/// - Dashboard analytics
/// - Smart suggestions
/// - Habit detection
///
/// It identifies:
/// - Emotional patterns
/// - Fatigue patterns
/// - Priority patterns
/// - Time-of-day patterns
/// - Category patterns
/// - Tag patterns
/// - Completion patterns
/// - Avoidance patterns
/// - Momentum patterns
class TaskAIPatternEngine {
  // Singleton
  static final TaskAIPatternEngine instance =
      TaskAIPatternEngine._internal();
  TaskAIPatternEngine._internal();

  // -----------------------------
  // EMOTIONAL PATTERNS
  // -----------------------------
  /// Returns tasks with consistently high emotional load.
  List<TaskModel> emotionalPatternHigh(List<TaskModel> tasks) {
    return tasks.where((t) => t.emotionalLoad >= 7).toList();
  }

  /// Returns tasks with consistently low emotional load.
  List<TaskModel> emotionalPatternLow(List<TaskModel> tasks) {
    return tasks.where((t) => t.emotionalLoad <= 3).toList();
  }

  // -----------------------------
  // FATIGUE PATTERNS
  // -----------------------------
  List<TaskModel> fatiguePatternHigh(List<TaskModel> tasks) {
    return tasks.where((t) => t.fatigueImpact >= 7).toList();
  }

  List<TaskModel> fatiguePatternLow(List<TaskModel> tasks) {
    return tasks.where((t) => t.fatigueImpact <= 3).toList();
  }

  // -----------------------------
  // PRIORITY PATTERNS
  // -----------------------------
  List<TaskModel> highPriorityPattern(List<TaskModel> tasks) {
    return tasks.where((t) => t.priority >= 4).toList();
  }

  List<TaskModel> lowPriorityPattern(List<TaskModel> tasks) {
    return tasks.where((t) => t.priority <= 2).toList();
  }

  // -----------------------------
  // CATEGORY PATTERNS
  // -----------------------------
  Map<String, List<TaskModel>> categoryPatterns(List<TaskModel> tasks) {
    final Map<String, List<TaskModel>> map = {};

    for (final t in tasks) {
      final c = t.category.toLowerCase();
      map.putIfAbsent(c, () => []);
      map[c]!.add(t);
    }

    return map;
  }

  // -----------------------------
  // TAG PATTERNS
  // -----------------------------
  Map<String, List<TaskModel>> tagPatterns(List<TaskModel> tasks) {
    final Map<String, List<TaskModel>> map = {};

    for (final t in tasks) {
      for (final tag in t.tags ?? []) {
        final normalized = tag.toLowerCase();
        map.putIfAbsent(normalized, () => []);
        map[normalized]!.add(t);
      }
    }

    return map;
  }

  // -----------------------------
  // COMPLETION PATTERNS
  // -----------------------------
  /// Tasks that are frequently completed quickly.
  List<TaskModel> momentumTasks(List<TaskModel> tasks) {
    return tasks.where((t) {
      if (t.dueDate == null) return false;
      final diff = t.dueDate!.difference(t.createdAt).inHours;
      return diff > 0 && diff <= 24 && t.isCompleted;
    }).toList();
  }

  /// Tasks that remain incomplete for long periods.
  List<TaskModel> stuckTasks(List<TaskModel> tasks) {
    return tasks.where((t) {
      if (t.dueDate == null) return false;
      final now = DateTime.now();
      final diff = now.difference(t.createdAt).inDays;
      return !t.isCompleted && diff >= 7;
    }).toList();
  }

  // -----------------------------
  // AVOIDANCE PATTERNS
  // -----------------------------
  /// Tasks with high emotional load + long delay.
  List<TaskModel> avoidanceEmotional(List<TaskModel> tasks) {
    return tasks.where((t) {
      if (t.emotionalLoad < 6) return false;
      final now = DateTime.now();
      final diff = now.difference(t.createdAt).inDays;
      return !t.isCompleted && diff >= 3;
    }).toList();
  }

  /// Tasks with high fatigue impact + long delay.
  List<TaskModel> avoidanceFatigue(List<TaskModel> tasks) {
    return tasks.where((t) {
      if (t.fatigueImpact < 6) return false;
      final now = DateTime.now();
      final diff = now.difference(t.createdAt).inDays;
      return !t.isCompleted && diff >= 3;
    }).toList();
  }

  // -----------------------------
  // TIME-OF-DAY PATTERNS (LIGHT)
  // -----------------------------
  /// Groups tasks by the hour they were created.
  Map<int, List<TaskModel>> timeOfDayPatterns(List<TaskModel> tasks) {
    final Map<int, List<TaskModel>> map = {};

    for (final t in tasks) {
      final hour = t.createdAt.hour;
      map.putIfAbsent(hour, () => []);
      map[hour]!.add(t);
    }

    return map;
  }

  // -----------------------------
  // FULL PATTERN PACKAGE
  // -----------------------------
  Map<String, dynamic> patternPackage(List<TaskModel> tasks) {
    return {
      "emotionalHigh": emotionalPatternHigh(tasks),
      "emotionalLow": emotionalPatternLow(tasks),
      "fatigueHigh": fatiguePatternHigh(tasks),
      "fatigueLow": fatiguePatternLow(tasks),
      "highPriority": highPriorityPattern(tasks),
      "lowPriority": lowPriorityPattern(tasks),
      "categoryPatterns": categoryPatterns(tasks),
      "tagPatterns": tagPatterns(tasks),
      "momentumTasks": momentumTasks(tasks),
      "stuckTasks": stuckTasks(tasks),
      "avoidanceEmotional": avoidanceEmotional(tasks),
      "avoidanceFatigue": avoidanceFatigue(tasks),
      "timeOfDayPatterns": timeOfDayPatterns(tasks),
    };
  }
}
