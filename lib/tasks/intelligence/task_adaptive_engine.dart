import '../task_facade.dart';
import '../models/task.dart';

/// TaskAdaptiveEngine learns from:
/// - Completion patterns
/// - Overdue patterns
/// - Energy cycles
/// - Priority tendencies
/// - Scheduling behavior
/// - Mode patterns
///
/// It produces:
/// - Personalized energy curve
/// - Priority tendency score
/// - Overdue risk score
/// - Scheduling preference curve
/// - Mode preference profile
/// - Personalized recommendations
class TaskAdaptiveEngine {
  // Singleton
  static final TaskAdaptiveEngine instance =
      TaskAdaptiveEngine._internal();
  TaskAdaptiveEngine._internal();

  final _facade = TaskFacade.instance;

  // -----------------------------
  // LEARNED ENERGY CURVE
  // -----------------------------
  Map<int, double> learnedEnergyCurve() {
    // hour → score
    final map = <int, double>{};

    for (final t in _facade.completed()) {
      final hour = t.completedAt?.hour;
      if (hour == null) continue;

      map[hour] = (map[hour] ?? 0) + _energyWeight(t.energy);
    }

    return map;
  }

  double _energyWeight(TaskEnergy e) {
    switch (e) {
      case TaskEnergy.low:
        return 0.5;
      case TaskEnergy.medium:
        return 1.0;
      case TaskEnergy.high:
        return 1.5;
    }
  }

  // -----------------------------
  // PRIORITY TENDENCY SCORE
  // -----------------------------
  double priorityTendency() {
    final tasks = _facade.all;
    if (tasks.isEmpty) return 0;

    final high = tasks.where((t) => t.priority == TaskPriority.high).length;
    final completedHigh =
        tasks.where((t) => t.priority == TaskPriority.high && t.isCompleted).length;

    if (high == 0) return 0;

    return (completedHigh / high) * 100;
  }

  // -----------------------------
  // OVERDUE RISK SCORE
  // -----------------------------
  double overdueRisk() {
    final tasks = _facade.all;
    if (tasks.isEmpty) return 0;

    final overdue = tasks.where((t) =>
        t.dueDate != null &&
        t.dueDate!.isBefore(DateTime.now()) &&
        !t.isCompleted).length;

    return (overdue / tasks.length) * 100;
  }

  // -----------------------------
  // SCHEDULING PREFERENCE CURVE
  // -----------------------------
  Map<int, int> schedulingCurve() {
    // hour → count
    final map = <int, int>{};

    for (final t in _facade.all) {
      final start = t.scheduledStart;
      if (start == null) continue;

      map[start.hour] = (map[start.hour] ?? 0) + 1;
    }

    return map;
  }

  // -----------------------------
  // MODE PREFERENCE PROFILE
  // -----------------------------
  Map<String, int> modeProfile() {
    // This will integrate with Mode Engine later.
    return {
      "focus": 0,
      "fatigue": 0,
      "recovery": 0,
    };
  }

  // -----------------------------
  // PERSONALIZED RECOMMENDATIONS
  // -----------------------------
  List<String> recommendations() {
    final recs = <String>[];

    if (priorityTendency() < 40) {
      recs.add("You tend to avoid high-priority tasks. Try using Focus Mode.");
    }

    if (overdueRisk() > 30) {
      recs.add("Your overdue rate is high. Consider scheduling tasks earlier.");
    }

    final energy = learnedEnergyCurve();
    if (energy.isNotEmpty) {
      final bestHour = energy.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      recs.add("Your peak productivity is around $bestHour:00.");
    }

    return recs;
  }
}
