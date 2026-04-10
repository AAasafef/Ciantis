import '../../data/models/task_model.dart';

/// The TaskTagEngine provides:
/// - Tag normalization
/// - Tag assignment
/// - Tag removal
/// - Tag merging
/// - Tag extraction from text (light NLP)
///
/// Tags are lightweight descriptors such as:
/// "urgent", "school", "kids", "finance", "errand", "self-care"
///
/// This engine is used by:
/// - Task List Page (filtering)
/// - Dashboard
/// - Mode Engine
/// - Next Best Action Engine
/// - Calendar subsystem
class TaskTagEngine {
  // Singleton
  static final TaskTagEngine instance = TaskTagEngine._internal();
  TaskTagEngine._internal();

  // -----------------------------
  // NORMALIZE TAG
  // -----------------------------
  String normalize(String tag) {
    return tag.trim().toLowerCase();
  }

  // -----------------------------
  // ADD TAG TO TASK
  // -----------------------------
  TaskModel addTag(TaskModel task, String tag) {
    final normalized = normalize(tag);

    final updatedTags = Set<String>.from(task.tags ?? []);
    updatedTags.add(normalized);

    return task.copyWith(tags: updatedTags.toList());
  }

  // -----------------------------
  // REMOVE TAG FROM TASK
  // -----------------------------
  TaskModel removeTag(TaskModel task, String tag) {
    final normalized = normalize(tag);

    final updatedTags = Set<String>.from(task.tags ?? []);
    updatedTags.remove(normalized);

    return task.copyWith(tags: updatedTags.toList());
  }

  // -----------------------------
  // MERGE TAG LISTS
  // -----------------------------
  List<String> mergeTags(List<String> a, List<String> b) {
    final set = <String>{};

    for (final t in a) set.add(normalize(t));
    for (final t in b) set.add(normalize(t));

    return set.toList();
  }

  // -----------------------------
  // EXTRACT TAGS FROM TEXT (LIGHT NLP)
  // -----------------------------
  /// This is a lightweight NLP stub.
  /// Later, the AI engine will replace this with a smarter model.
  List<String> extractTagsFromText(String text) {
    final lower = text.toLowerCase();

    final List<String> tags = [];

    if (lower.contains("school") ||
        lower.contains("study") ||
        lower.contains("exam")) {
      tags.add("school");
    }

    if (lower.contains("kids") ||
        lower.contains("child") ||
        lower.contains("homework")) {
      tags.add("kids");
    }

    if (lower.contains("hair") ||
        lower.contains("client") ||
        lower.contains("salon")) {
      tags.add("salon");
    }

    if (lower.contains("urgent") ||
        lower.contains("asap") ||
        lower.contains("important")) {
      tags.add("urgent");
    }

    if (lower.contains("health") ||
        lower.contains("doctor") ||
        lower.contains("appointment")) {
      tags.add("health");
    }

    if (lower.contains("finance") ||
        lower.contains("bill") ||
        lower.contains("payment")) {
      tags.add("finance");
    }

    return tags;
  }

  // -----------------------------
  // APPLY AUTO‑TAGS TO TASK
  // -----------------------------
  TaskModel autoTag(TaskModel task) {
    final extracted = extractTagsFromText(
      "${task.title} ${task.description ?? ""}",
    );

    final merged = mergeTags(task.tags ?? [], extracted);

    return task.copyWith(tags: merged);
  }

  // -----------------------------
  // FILTER TASKS BY TAG
  // -----------------------------
  List<TaskModel> filterByTag(List<TaskModel> tasks, String tag) {
    final normalized = normalize(tag);

    return tasks.where((t) {
      final tags = t.tags ?? [];
      return tags.map(normalize).contains(normalized);
    }).toList();
  }

  // -----------------------------
  // FILTER TASKS BY MULTIPLE TAGS (AND)
  // -----------------------------
  List<TaskModel> filterByTags(List<TaskModel> tasks, List<String> tags) {
    final normalized = tags.map(normalize).toList();

    return tasks.where((t) {
      final taskTags = (t.tags ?? []).map(normalize).toList();
      return normalized.every(taskTags.contains);
    }).toList();
  }
}
