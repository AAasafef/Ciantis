import '../../data/models/task_model.dart';

/// TaskAITrendEngine analyzes long-term behavioral trends.
/// This engine is used by:
/// - Mode Engine
/// - Next Best Action Engine
/// - Dashboard analytics
/// - Burnout prevention
/// - Productivity forecasting
///
/// It identifies:
/// - Emotional trends
/// - Fatigue trends
/// - Priority trends
/// - Completion trends
/// - Category trends
/// - Tag trends
/// - Overdue trends
/// - Weekly/monthly cycles
class TaskAITrendEngine {
  // Singleton
  static final TaskAITrendEngine instance =
      TaskAITrendEngine._internal();
  TaskAITrendEngine._internal();

  // -----------------------------
  // EMOTIONAL LOAD TREND
  // -----------------------------
  /// Returns the average emotional load.
  double emotionalTrend(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 0;
    final total = tasks.fold<int>(0, (sum, t) => sum + t.emotionalLoad);
    return total / tasks.length;
  }

  // -----------------------------
  // FATIGUE TREND
  // -----------------------------
  double fatigueTrend(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 0;
    final total = tasks.fold<int>(0, (sum, t) => sum + t.fatigueImpact);
    return total / tasks.length;
  }

  // -----------------------------
  // PRIORITY TREND
  // -----------------------------
  double priorityTrend(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 0;
    final total = tasks.fold<int>(0, (sum, t) => sum + t.priority);
    return total / tasks.length;
  }

  // -----------------------------
  // COMPLETION RATE TREND
  // -----------------------------
  double completionRate(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 0;
    final completed = tasks.where((t) => t.isCompleted).length;
    return completed / tasks.length;
  }

  // -----------------------------
  // OVERDUE TREND
  // -----------------------------
  double overdueRate(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 0;

    final now = DateTime.now();
    final overdue = tasks.where((t) {
      if (t.dueDate == null) return false;
      return t.dueDate!.isBefore(now) && !t.isCompleted;
    }).length;

    return overdue / tasks.length;
  }

  // -----------------------------
  // CATEGORY TRENDS
  // -----------------------------
  Map<String, int> categoryTrend(List<TaskModel> tasks) {
    final Map<String, int> map = {};

    for (final t in tasks) {
      final c = t.category.toLowerCase();
      map[c] = (map[c] ?? 0) + 1;
    }

    return map;
  }

  // -----------------------------
  // TAG TRENDS
  // -----------------------------
  Map<String, int> tagTrend(List<TaskModel> tasks) {
    final Map<String, int> map = {};

    for (final t in tasks) {
      for (final tag in t.tags ?? []) {
        final normalized = tag.toLowerCase();
        map[normalized] = (map[normalized] ?? 0) + 1;
      }
    }

    return map;
  }

  // -----------------------------
  // WEEKLY PRODUCTIVITY TREND
  // -----------------------------
  /// Returns a map:
  ///   weekday (0=Mon) → completed tasks count
  Map<int, int> weeklyProductivity(List<TaskModel> tasks) {
    final Map<int, int> map = {};

    for (final t in tasks) {
      if (!t.isCompleted) continue;
      final weekday = t.completedAt?.weekday ?? t.createdAt.weekday;
      map[weekday] = (map[weekday] ?? 0) + 1;
    }

    return map;
  }

  // -----------------------------
  // MONTHLY PRODUCTIVITY TREND
  // -----------------------------
  /// Returns:
  ///   month (1–12) → completed tasks count
  Map<int, int> monthlyProductivity(List<TaskModel> tasks) {
    final Map<int, int> map = {};

    for (final t in tasks) {
      if (!t.isCompleted) continue;
      final month = t.completedAt?.month ?? t.createdAt.month;
      map[month] = (map[month] ?? 0) + 1;
    }

    return map;
  }

  // -----------------------------
  // MOMENTUM TREND
  // -----------------------------
  /// Momentum = ratio of quick completions (within 24h)
  double momentumTrend(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 0;

    int momentum = 0;

    for (final t in tasks) {
      if (!t.isCompleted) continue;
      if (t.dueDate == null) continue;

      final diff = t.dueDate!.difference(t.createdAt).inHours;
      if (diff > 0 && diff <= 24) {
        momentum++;
      }
    }

    return momentum / tasks.length;
  }

  // -----------------------------
  // BURNOUT TREND
  // -----------------------------
  /// Burnout = high emotional + high fatigue + low completion
  double burnoutTrend(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 0;

    final emotional = emotionalTrend(tasks);
    final fatigue = fatigueTrend(tasks);
    final completion = completionRate(tasks);

    return (emotional * 0.4) + (fatigue * 0.4) + ((1 - completion) * 0.2);
  }

  // -----------------------------
  // FULL TREND PACKAGE
  // -----------------------------
  Map<String, dynamic> trendPackage(List<TaskModel> tasks) {
    return {
      "emotionalTrend": emotionalTrend(tasks),
      "fatigueTrend": fatigueTrend(tasks),
      "priorityTrend": priorityTrend(tasks),
      "completionRate": completionRate(tasks),
      "overdueRate": overdueRate(tasks),
      "categoryTrend": categoryTrend(tasks),
      "tagTrend": tagTrend(tasks),
      "weeklyProductivity": weeklyProductivity(tasks),
      "monthlyProductivity": monthlyProductivity(tasks),
      "momentumTrend": momentumTrend(tasks),
      "burnoutTrend": burnoutTrend(tasks),
    };
  }
}
