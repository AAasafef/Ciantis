import 'dart:async';

import 'models/task.dart';
import 'data/task_repository.dart';
import 'logic/task_sorting_engine.dart';
import 'logic/task_filtering_engine.dart';
import 'analytics/task_insights_engine.dart';
import 'logic/task_suggestions_engine.dart';
import 'logic/task_scheduling_engine.dart';

/// TaskFacade is the unified API for the entire Tasks OS.
/// 
/// It provides:
/// - CRUD
/// - Streams
/// - Sorting
/// - Filtering
/// - Insights
/// - Suggestions
/// - Smart scheduling
/// 
/// This is the single entry point for all task-related operations.
class TaskFacade {
  // Singleton
  static final TaskFacade instance = TaskFacade._internal();
  TaskFacade._internal();

  final _repo = TaskRepository.instance;
  final _sort = TaskSortingEngine.instance;
  final _filter = TaskFilteringEngine.instance;
  final _insights = TaskInsightsEngine.instance;
  final _suggest = TaskSuggestionsEngine.instance;
  final _schedule = TaskSchedulingEngine.instance;

  // -----------------------------
  // STREAM
  // -----------------------------
  Stream<List<Task>> get stream => _repo.stream;

  // -----------------------------
  // GETTERS
  // -----------------------------
  List<Task> get all => _repo.all;

  // -----------------------------
  // CRUD
  // -----------------------------
  void add(Task task) => _repo.add(task);
  void update(Task task) => _repo.update(task);
  void upsert(Task task) => _repo.upsert(task);
  void delete(String id) => _repo.delete(id);

  // -----------------------------
  // FILTERED LISTS
  // -----------------------------
  List<Task> today(DateTime now) => _filter.today(all, now);
  List<Task> overdue(DateTime now) => _filter.overdue(all, now);
  List<Task> starred() => _filter.starred(all);
  List<Task> highPriority() => _filter.highPriority(all);
  List<Task> lowEnergy() => _filter.lowEnergy(all);
  List<Task> flexible() => _filter.flexible(all);
  List<Task> unscheduled() => _filter.unscheduled(all);
  List<Task> completed() => _filter.completed(all);

  // -----------------------------
  // SORTED LIST
  // -----------------------------
  List<Task> sorted() => _sort.sort(all);

  // -----------------------------
  // INSIGHTS
  // -----------------------------
  TaskInsights insights(DateTime now) => _insights.build(all, now);

  // -----------------------------
  // SUGGESTIONS
  // -----------------------------
  Task? nextBestAction(DateTime now) =>
      _suggest.nextBestAction(all, now);

  List<Task> suggestions(DateTime now) =>
      _suggest.suggestions(all, now);

  List<Task> modeAwareSuggestions({
    required DateTime now,
    required String mode,
  }) =>
      _suggest.modeAwareSuggestions(
        tasks: all,
        now: now,
        mode: mode,
      );

  // -----------------------------
  // SMART SCHEDULING
  // -----------------------------
  DateTimeRange? scheduleTask(Task task, DateTime day) =>
      _schedule.scheduleTask(task, day);

  Map<String, DateTimeRange?> scheduleTasks(
    List<Task> tasks,
    DateTime day,
  ) =>
      _schedule.scheduleTasks(tasks, day);

  DateTimeRange? suggestTime(Task task, DateTime day) =>
      _schedule.suggestTime(task, day);

  // -----------------------------
  // IMPORT / BACKUP SUPPORT
  // -----------------------------
  void replaceAll(List<Task> tasks) => _repo.replaceAll(tasks);
}
