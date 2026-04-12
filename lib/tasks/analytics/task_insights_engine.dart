import '../models/task.dart';
import '../logic/task_filtering_engine.dart';
import '../logic/task_sorting_engine.dart';

/// TaskInsights represents a snapshot of the user's task landscape.
class TaskInsights {
  final int total;
  final int completed;
  final int overdue;
  final int dueToday;
  final int highPriority;
  final int lowEnergy;
  final int flexible;

  final double pressureScore; // 0–100
  final double reliefScore;   // 0–100

  TaskInsights({
    required this.total,
    required this.completed,
    required this.overdue,
    required this.dueToday,
    required this.highPriority,
    required this.lowEnergy,
    required this.flexible,
    required this.pressureScore,
    required this.reliefScore,
  });

  @override
  String toString() {
    return """
TaskInsights(
  total: $total,
  completed: $completed,
  overdue: $overdue,
  dueToday: $dueToday,
  highPriority: $highPriority,
  lowEnergy: $lowEnergy,
  flexible: $flexible,
  pressureScore: $pressureScore,
  reliefScore: $reliefScore,
)
""";
  }
}

/// TaskInsightsEngine computes analytics for Tasks OS.
/// 
/// This powers:
/// - Daily Briefings
/// - Weekly Reviews
/// - Mode Engine
/// - Smart Suggestions
/// - Adaptive Intelligence Layer
class TaskInsightsEngine {
  // Singleton
  static final TaskInsightsEngine instance =
      TaskInsightsEngine._internal();
  TaskInsightsEngine._internal();

  final _filter = TaskFilteringEngine.instance;
  final _sort = TaskSortingEngine.instance;

  // -----------------------------
  // BUILD INSIGHTS SNAPSHOT
  // -----------------------------
  TaskInsights build(List<Task> tasks, DateTime now) {
    final sorted = _sort.sort(tasks);

    final overdue = _filter.overdue(sorted, now);
    final today = _filter.today(sorted, now);
    final high = _filter.highPriority(sorted);
    final lowEnergy = _filter.lowEnergy(sorted);
    final flexible = _filter.flexible(sorted);
    final completed = _filter.completed(sorted);

    final total = tasks.length;

    // -----------------------------
    // PRESSURE SCORE
    // -----------------------------
    final pressure = _computePressure(
      overdueCount: overdue.length,
      dueTodayCount: today.length,
      highPriorityCount: high.length,
    );

    // -----------------------------
    // RELIEF SCORE
    // -----------------------------
    final relief = _computeRelief(
      lowEnergyCount: lowEnergy.length,
      flexibleCount: flexible.length,
      completedCount: completed.length,
      totalCount: total,
    );

    return TaskInsights(
      total: total,
      completed: completed.length,
      overdue: overdue.length,
      dueToday: today.length,
      highPriority: high.length,
      lowEnergy: lowEnergy.length,
      flexible: flexible.length,
      pressureScore: pressure,
      reliefScore: relief,
    );
  }

  // -----------------------------
  // PRESSURE SCORE (0–100)
  // -----------------------------
  double _computePressure({
    required int overdueCount,
    required int dueTodayCount,
    required int highPriorityCount,
  }) {
    double score = 0;

    score += overdueCount * 12;
    score += dueTodayCount * 8;
    score += highPriorityCount * 10;

    return score.clamp(0, 100).toDouble();
  }

  // -----------------------------
  // RELIEF SCORE (0–100)
  // -----------------------------
  double _computeRelief({
    required int lowEnergyCount,
    required int flexibleCount,
    required int completedCount,
    required int totalCount,
  }) {
    if (totalCount == 0) return 100;

    double score = 0;

    score += lowEnergyCount * 6;
    score += flexibleCount * 4;
    score += (completedCount / totalCount) * 40;

    return score.clamp(0, 100).toDouble();
  }
}
