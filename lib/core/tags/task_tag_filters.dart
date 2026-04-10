import '../../data/models/task_model.dart';
import 'task_tag_engine.dart';

/// TaskTagFilters provides UI‑ready filtering logic for tags.
/// It builds on top of TaskTagEngine and adds:
/// - AND filtering
/// - OR filtering
/// - Tag frequency maps
/// - Tag grouping
///
/// Used by:
/// - Task List Page
/// - Dashboard
/// - Calendar subsystem
/// - Mode Engine
/// - Next Best Action Engine
class TaskTagFilters {
  // Singleton
  static final TaskTagFilters instance = TaskTagFilters._internal();
  TaskTagFilters._internal();

  final _engine = TaskTagEngine.instance;

  // -----------------------------
  // FILTER: SINGLE TAG
  // -----------------------------
  List<TaskModel> filterByTag(List<TaskModel> tasks, String tag) {
    final normalized = _engine.normalize(tag);

    return tasks.where((t) {
      final tags = t.tags ?? [];
      return tags.map(_engine.normalize).contains(normalized);
    }).toList();
  }

  // -----------------------------
  // FILTER: MULTIPLE TAGS (AND)
  // -----------------------------
  List<TaskModel> filterByTagsAnd(
    List<TaskModel> tasks,
    List<String> tags,
  ) {
    final normalized = tags.map(_engine.normalize).toList();

    return tasks.where((t) {
      final taskTags = (t.tags ?? []).map(_engine.normalize).toList();
      return normalized.every(taskTags.contains);
    }).toList();
  }

  // -----------------------------
  // FILTER: MULTIPLE TAGS (OR)
  // -----------------------------
  List<TaskModel> filterByTagsOr(
    List<TaskModel> tasks,
    List<String> tags,
  ) {
    final normalized = tags.map(_engine.normalize).toList();

    return tasks.where((t) {
      final taskTags = (t.tags ?? []).map(_engine.normalize).toList();
      return normalized.any(taskTags.contains);
    }).toList();
  }

  // -----------------------------
  // TAG FREQUENCY MAP
  // -----------------------------
  /// Returns a map of:
  ///   tag → count
  ///
  /// Used for:
  /// - Tag clouds
  /// - Dashboard summaries
  /// - Analytics
  Map<String, int> tagFrequency(List<TaskModel> tasks) {
    final Map<String, int> freq = {};

    for (final t in tasks) {
      for (final tag in t.tags ?? []) {
        final normalized = _engine.normalize(tag);
        freq[normalized] = (freq[normalized] ?? 0) + 1;
      }
    }

    return freq;
  }

  // -----------------------------
  // GROUP TASKS BY TAG
  // -----------------------------
  /// Returns:
  ///   tag → List<TaskModel>
  Map<String, List<TaskModel>> groupByTag(List<TaskModel> tasks) {
    final Map<String, List<TaskModel>> map = {};

    for (final t in tasks) {
      for (final tag in t.tags ?? []) {
        final normalized = _engine.normalize(tag);

        if (!map.containsKey(normalized)) {
          map[normalized] = [];
        }

        map[normalized]!.add(t);
      }
    }

    return map;
  }

  // -----------------------------
  // GET ALL UNIQUE TAGS
  // -----------------------------
  List<String> allTags(List<TaskModel> tasks) {
    final set = <String>{};

    for (final t in tasks) {
      for (final tag in t.tags ?? []) {
        set.add(_engine.normalize(tag));
      }
    }

    return set.toList();
  }
}
