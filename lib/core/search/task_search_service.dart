import '../../data/models/task_model.dart';
import '../../data/services/task_service.dart';
import 'task_search_engine.dart';
import 'task_search_indexer.dart';

/// TaskSearchService is the high‑level orchestrator for all search operations.
/// It connects:
/// - TaskRepository (via TaskService)
/// - TaskSearchEngine (search logic)
/// - TaskSearchIndexer (fast lookup index)
///
/// This service is used by:
/// - Task List Page
/// - Global Search
/// - Dashboard
/// - Mode Engine
/// - Next Best Action Engine
/// - Calendar subsystem
class TaskSearchService {
  // Singleton
  static final TaskSearchService instance =
      TaskSearchService._internal();
  TaskSearchService._internal();

  final _engine = TaskSearchEngine.instance;
  final _indexer = TaskSearchIndexer.instance;

  // -----------------------------
  // REINDEX ALL TASKS
  // -----------------------------
  Future<void> reindex(TaskService service) async {
    final tasks = await service.getAllTasks();
    _indexer.indexAll(tasks);
  }

  // -----------------------------
  // BASIC TEXT SEARCH
  // -----------------------------
  Future<List<TaskModel>> searchText(
    TaskService service,
    String query,
  ) async {
    final tasks = await service.getAllTasks();
    return _engine.searchText(tasks, query);
  }

  // -----------------------------
  // CATEGORY SEARCH
  // -----------------------------
  Future<List<TaskModel>> searchCategory(
    TaskService service,
    String category,
  ) async {
    final tasks = await service.getAllTasks();
    return _engine.searchCategory(tasks, category);
  }

  // -----------------------------
  // TAG SEARCH
  // -----------------------------
  Future<List<TaskModel>> searchTag(
    TaskService service,
    String tag,
  ) async {
    final tasks = await service.getAllTasks();
    return _engine.searchTag(tasks, tag);
  }

  // -----------------------------
  // PRIORITY SEARCH
  // -----------------------------
  Future<List<TaskModel>> searchPriority(
    TaskService service, {
    int? min,
    int? max,
  }) async {
    final tasks = await service.getAllTasks();
    return _engine.searchPriority(tasks, min: min, max: max);
  }

  // -----------------------------
  // EMOTIONAL LOAD SEARCH
  // -----------------------------
  Future<List<TaskModel>> searchEmotional(
    TaskService service, {
    int? min,
    int? max,
  }) async {
    final tasks = await service.getAllTasks();
    return _engine.searchEmotional(tasks, min: min, max: max);
  }

  // -----------------------------
  // FATIGUE IMPACT SEARCH
  // -----------------------------
  Future<List<TaskModel>> searchFatigue(
    TaskService service, {
    int? min,
    int? max,
  }) async {
    final tasks = await service.getAllTasks();
    return _engine.searchFatigue(tasks, min: min, max: max);
  }

  // -----------------------------
  // COMBINED SEARCH
  // -----------------------------
  Future<List<TaskModel>> combined({
    required TaskService service,
    String? text,
    String? category,
    List<String>? tags,
    int? minPriority,
    int? maxPriority,
    int? minEmotional,
    int? maxEmotional,
    int? minFatigue,
    int? maxFatigue,
  }) async {
    final tasks = await service.getAllTasks();

    return _engine.combined(
      tasks: tasks,
      text: text,
      category: category,
      tags: tags,
      minPriority: minPriority,
      maxPriority: maxPriority,
      minEmotional: minEmotional,
      maxEmotional: maxEmotional,
      minFatigue: minFatigue,
      maxFatigue: maxFatigue,
    );
  }

  // -----------------------------
  // INDEXED LOOKUP (FAST)
  // -----------------------------
  /// Returns tasks that contain the word in their title index.
  /// This is instant and used for:
  /// - Global search suggestions
  /// - Autocomplete
  /// - Mode Engine fast lookups
  List<TaskModel> lookupTitle(String word) {
    final key = word.toLowerCase();
    return _indexer.titleIndex[key] ?? [];
  }

  /// Returns tasks that contain the word in their description index.
  List<TaskModel> lookupDescription(String word) {
    final key = word.toLowerCase();
    return _indexer.descriptionIndex[key] ?? [];
  }

  /// Returns tasks in a category.
  List<TaskModel> lookupCategory(String category) {
    final key = category.toLowerCase();
    return _indexer.categoryIndex[key] ?? [];
  }

  /// Returns tasks with a given tag.
  List<TaskModel> lookupTag(String tag) {
    final key = tag.toLowerCase();
    return _indexer.tagIndex[key] ?? [];
  }

  /// Returns tasks with a given priority.
  List<TaskModel> lookupPriority(int priority) {
    return _indexer.priorityIndex[priority] ?? [];
  }

  /// Returns tasks due on a specific date.
  List<TaskModel> lookupDueDate(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return _indexer.dueDateIndex[key] ?? [];
  }

  /// Returns tasks by completion status.
  List<TaskModel> lookupCompletion(bool completed) {
    return _indexer.completionIndex[completed] ?? [];
  }
}
