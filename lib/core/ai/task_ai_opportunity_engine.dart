import '../../data/models/task_model.dart';
import 'task_ai_scoring_engine.dart';
import 'task_ai_context_engine.dart';
import 'task_ai_cluster_engine.dart';
import 'task_ai_pattern_engine.dart';

/// TaskAIOpportunityEngine identifies positive openings in the task landscape.
/// This engine is used by:
/// - Mode Engine
/// - Next Best Action Engine
/// - Dashboard "Opportunities"
/// - Smart nudges
///
/// It detects:
/// - Quick wins
/// - Energy-aligned tasks
/// - Emotionally light tasks
/// - Low-fatigue tasks
/// - High-impact tasks
/// - Momentum tasks
/// - Tasks that reduce future stress
/// - Tasks that unlock other tasks
class TaskAIOpportunityEngine {
  // Singleton
  static final TaskAIOpportunityEngine instance =
      TaskAIOpportunityEngine._internal();
  TaskAIOpportunityEngine._internal();

  final _scoring = TaskAIScoringEngine.instance;
  final _context = TaskAIContextEngine.instance;
  final _clusters = TaskAIClusterEngine.instance;
  final _patterns = TaskAIPatternEngine.instance;

  // -----------------------------
  // QUICK WINS
  // -----------------------------
  List<TaskModel> quickWins(List<TaskModel> tasks) {
    return _clusters.quickWins(tasks);
  }

  // -----------------------------
  // ENERGY-ALIGNED TASKS
  // -----------------------------
  List<TaskModel> energyAligned(List<TaskModel> tasks) {
    final energy = _context.energyContext(tasks);

    return tasks.where((t) {
      final readiness = _scoring.readiness(t);
      return readiness >= energy - 2; // matches current energy
    }).toList();
  }

  // -----------------------------
  // EMOTIONALLY LIGHT TASKS
  // -----------------------------
  List<TaskModel> emotionallyLight(List<TaskModel> tasks) {
    return tasks.where((t) => t.emotionalLoad <= 3).toList();
  }

  // -----------------------------
  // LOW FATIGUE TASKS
  // -----------------------------
  List<TaskModel> lowFatigue(List<TaskModel> tasks) {
    return tasks.where((t) => t.fatigueImpact <= 3).toList();
  }

  // -----------------------------
  // HIGH IMPACT TASKS
  // -----------------------------
  /// High impact = high priority + low emotional + low fatigue
  List<TaskModel> highImpact(List<TaskModel> tasks) {
    return tasks.where((t) {
      return t.priority >= 4 &&
          t.emotionalLoad <= 4 &&
          t.fatigueImpact <= 4;
    }).toList();
  }

  // -----------------------------
  // MOMENTUM BUILDERS
  // -----------------------------
  List<TaskModel> momentumBuilders(List<TaskModel> tasks) {
    return _patterns.momentumTasks(tasks);
  }

  // -----------------------------
  // FUTURE STRESS REDUCERS
  // -----------------------------
  /// Tasks that prevent future stress:
  /// - moderate priority
  /// - moderate time sensitivity
  /// - low emotional load
  List<TaskModel> futureStressReducers(List<TaskModel> tasks) {
    return tasks.where((t) {
      final time = _scoring.timeSensitivity(t);
      return t.priority >= 3 &&
          t.priority <= 4 &&
          time >= 3 &&
          time <= 6 &&
          t.emotionalLoad <= 4;
    }).toList();
  }

  // -----------------------------
  // UNLOCKER TASKS
  // -----------------------------
  /// Unlockers = tasks that are prerequisites for others.
  /// (Heuristic: tasks with tags like "prep", "setup", "start", "foundation")
  List<TaskModel> unlockers(List<TaskModel> tasks) {
    const keywords = ["prep", "prepare", "setup", "start", "foundation"];

    return tasks.where((t) {
      final tags = t.tags?.map((e) => e.toLowerCase()).toList() ?? [];
      return tags.any((tag) => keywords.contains(tag));
    }).toList();
  }

  // -----------------------------
  // OPPORTUNITY SCORE
  // -----------------------------
  /// Higher = better opportunity to do now.
  double opportunityScore(TaskModel task, List<TaskModel> allTasks) {
    final readiness = _scoring.readiness(task);
    final fatigue = task.fatigueImpact.toDouble();
    final emotional = task.emotionalLoad.toDouble();
    final time = _scoring.timeSensitivity(task);

    return (readiness * 0.4) +
        ((10 - fatigue) * 0.2) +
        ((10 - emotional) * 0.2) +
        ((10 - time) * 0.2);
  }

  // -----------------------------
  // RANKED OPPORTUNITIES
  // -----------------------------
  List<TaskModel> rankedOpportunities(List<TaskModel> tasks) {
    final list = List<TaskModel>.from(tasks);

    list.sort((a, b) {
      final sa = opportunityScore(a, tasks);
      final sb = opportunityScore(b, tasks);
      return sb.compareTo(sa); // DESC
    });

    return list;
  }

  // -----------------------------
  // FULL OPPORTUNITY PACKAGE
  // -----------------------------
  Map<String, List<TaskModel>> opportunityPackage(List<TaskModel> tasks) {
    return {
      "quickWins": quickWins(tasks),
      "energyAligned": energyAligned(tasks),
      "emotionallyLight": emotionallyLight(tasks),
      "lowFatigue": lowFatigue(tasks),
      "highImpact": highImpact(tasks),
      "momentumBuilders": momentumBuilders(tasks),
      "futureStressReducers": futureStressReducers(tasks),
      "unlockers": unlockers(tasks),
      "ranked": rankedOpportunities(tasks),
    };
  }
}
