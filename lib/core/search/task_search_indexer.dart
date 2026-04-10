import '../../data/models/task_model.dart';
import '../tags/task_tag_engine.dart';

/// TaskSearchIndexer builds and maintains fast lookup indexes for:
/// - Titles
/// - Descriptions
/// - Categories
/// - Tags
/// - Priority
/// - Due dates
/// - Completion status
///
/// This dramatically speeds up:
/// - Global search
/// - Task List filtering
/// - Dashboard queries
/// - Mode Engine lookups
/// - Next Best Action Engine
/// - Calendar subsystem
///
/// The indexer does NOT perform search.
/// It only builds the index used by TaskSearchEngine.
class TaskSearchIndexer {
  // Singleton
  static final TaskSearchIndexer instance =
      TaskSearchIndexer._internal();
  TaskSearchIndexer._internal();

  final _tagEngine = TaskTagEngine.instance;

  // -----------------------------
  // INDEX STRUCTURE
  // -----------------------------
  Map<String, List<TaskModel>> titleIndex = {};
  Map<String, List<TaskModel>> descriptionIndex = {};
  Map<String, List<TaskModel>> categoryIndex = {};
  Map<String, List<TaskModel>> tagIndex = {};
  Map<int, List<TaskModel>> priorityIndex = {};
  Map<DateTime, List<TaskModel>> dueDateIndex = {};
  Map<bool, List<TaskModel>> completionIndex = {};

  // -----------------------------
  // CLEAR INDEX
  // -----------------------------
  void clear() {
    titleIndex.clear();
    descriptionIndex.clear();
    categoryIndex.clear();
    tagIndex.clear();
    priorityIndex.clear();
    dueDateIndex.clear();
    completionIndex.clear();
  }

  // -----------------------------
  // INDEX A SINGLE TASK
  // -----------------------------
  void indexTask(TaskModel task) {
    _indexTitle(task);
    _indexDescription(task);
    _indexCategory(task);
    _indexTags(task);
    _indexPriority(task);
    _indexDueDate(task);
    _indexCompletion(task);
  }

  // -----------------------------
  // INDEX ALL TASKS
  // -----------------------------
  void indexAll(List<TaskModel> tasks) {
    clear();
    for (final t in tasks) {
      indexTask(t);
    }
  }

  // -----------------------------
  // INTERNAL INDEXERS
  // -----------------------------
  void _indexTitle(TaskModel task) {
    final words = task.title.toLowerCase().split(" ");
    for (final w in words) {
      if (w.trim().isEmpty) continue;
      titleIndex.putIfAbsent(w, () => []);
      titleIndex[w]!.add(task);
    }
  }

  void _indexDescription(TaskModel task) {
    final desc = task.description ?? "";
    final words = desc.toLowerCase().split(" ");
    for (final w in words) {
      if (w.trim().isEmpty) continue;
      descriptionIndex.putIfAbsent(w, () => []);
      descriptionIndex[w]!.add(task);
    }
  }

  void _indexCategory(TaskModel task) {
    final c = task.category.toLowerCase();
    categoryIndex.putIfAbsent(c, () => []);
    categoryIndex[c]!.add(task);
  }

  void _indexTags(TaskModel task) {
    for (final tag in task.tags ?? []) {
      final normalized = _tagEngine.normalize(tag);
      tagIndex.putIfAbsent(normalized, () => []);
      tagIndex[normalized]!.add(task);
    }
  }

  void _indexPriority(TaskModel task) {
    priorityIndex.putIfAbsent(task.priority, () => []);
    priorityIndex[task.priority]!.add(task);
  }

  void _indexDueDate(TaskModel task) {
    if (task.dueDate == null) return;

    final key = DateTime(
      task.dueDate!.year,
      task.dueDate!.month,
      task.dueDate!.day,
    );

    dueDateIndex.putIfAbsent(key, () => []);
    dueDateIndex[key]!.add(task);
  }

  void _indexCompletion(TaskModel task) {
    completionIndex.putIfAbsent(task.isCompleted, () => []);
    completionIndex[task.isCompleted]!.add(task);
  }

  // -----------------------------
  // UPDATE INDEX FOR UPDATED TASK
  // -----------------------------
  void updateTask(TaskModel oldTask, TaskModel newTask) {
    // Easiest and safest: reindex everything
    // (Tasks list is small enough for this to be instant)
    // Future optimization: diff-based reindexing
    // For now: full rebuild
    // Caller must pass full task list
  }
}
