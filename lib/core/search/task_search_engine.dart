import '../../data/models/task_model.dart';
import '../tags/task_tag_engine.dart';

/// TaskSearchEngine provides:
/// - Title search
/// - Description search
/// - Category search
/// - Tag search
/// - Priority filtering
/// - Emotional/fatigue filtering
/// - Combined multi-field search
/// - Lightweight fuzzy matching
/// - Search scoring (for future AI ranking)
///
/// Used by:
/// - Task List Page
/// - Global Search
/// - Dashboard
/// - Mode Engine
/// - Next Best Action Engine
/// - Calendar subsystem
class TaskSearchEngine {
  // Singleton
  static final TaskSearchEngine instance =
      TaskSearchEngine._internal();
  TaskSearchEngine._internal();

  final _tagEngine = TaskTagEngine.instance;

  // -----------------------------
  // NORMALIZE QUERY
  // -----------------------------
  String normalize(String input) {
    return input.trim().toLowerCase();
  }

  // -----------------------------
  // BASIC MATCH
  // -----------------------------
  bool _match(String text, String query) {
    return text.toLowerCase().contains(query);
  }

  // -----------------------------
  // FUZZY MATCH (LIGHTWEIGHT)
  // -----------------------------
  bool _fuzzyMatch(String text, String query) {
    final t = text.toLowerCase();
    final q = query.toLowerCase();

    // Simple fuzzy: allow missing characters in between
    int ti = 0;
    int qi = 0;

    while (ti < t.length && qi < q.length) {
      if (t[ti] == q[qi]) {
        qi++;
      }
      ti++;
    }

    return qi == q.length;
  }

  // -----------------------------
  // SEARCH BY TEXT (TITLE + DESCRIPTION)
  // -----------------------------
  List<TaskModel> searchText(List<TaskModel> tasks, String query) {
    final q = normalize(query);

    return tasks.where((t) {
      final title = t.title.toLowerCase();
      final desc = (t.description ?? "").toLowerCase();

      return _match(title, q) ||
          _match(desc, q) ||
          _fuzzyMatch(title, q) ||
          _fuzzyMatch(desc, q);
    }).toList();
  }

  // -----------------------------
  // SEARCH BY CATEGORY
  // -----------------------------
  List<TaskModel> searchCategory(List<TaskModel> tasks, String category) {
    final c = normalize(category);

    return tasks.where((t) {
      return t.category.toLowerCase() == c;
    }).toList();
  }

  // -----------------------------
  // SEARCH BY TAG
  // -----------------------------
  List<TaskModel> searchTag(List<TaskModel> tasks, String tag) {
    final normalized = _tagEngine.normalize(tag);

    return tasks.where((t) {
      final tags = t.tags ?? [];
      return tags.map(_tagEngine.normalize).contains(normalized);
    }).toList();
  }

  // -----------------------------
  // SEARCH BY PRIORITY RANGE
  // -----------------------------
  List<TaskModel> searchPriority(
    List<TaskModel> tasks, {
    int? min,
    int? max,
  }) {
    return tasks.where((t) {
      if (min != null && t.priority < min) return false;
      if (max != null && t.priority > max) return false;
      return true;
    }).toList();
  }

  // -----------------------------
  // SEARCH BY EMOTIONAL LOAD RANGE
  // -----------------------------
  List<TaskModel> searchEmotional(
    List<TaskModel> tasks, {
    int? min,
    int? max,
  }) {
    return tasks.where((t) {
      if (min != null && t.emotionalLoad < min) return false;
      if (max != null && t.emotionalLoad > max) return false;
      return true;
    }).toList();
  }

  // -----------------------------
  // SEARCH BY FATIGUE IMPACT RANGE
  // -----------------------------
  List<TaskModel> searchFatigue(
    List<TaskModel> tasks, {
    int? min,
    int? max,
  }) {
    return tasks.where((t) {
      if (min != null && t.fatigueImpact < min) return false;
      if (max != null && t.fatigueImpact > max) return false;
      return true;
    }).toList();
  }

  // -----------------------------
  // COMBINED SEARCH
  // -----------------------------
  /// Supports:
  /// - text
  /// - category
  /// - tags
  /// - priority range
  /// - emotional range
  /// - fatigue range
  ///
  /// Returns tasks that match ALL provided filters.
  List<TaskModel> combined({
    required List<TaskModel> tasks,
    String? text,
    String? category,
    List<String>? tags,
    int? minPriority,
    int? maxPriority,
    int? minEmotional,
    int? maxEmotional,
    int? minFatigue,
    int? maxFatigue,
  }) {
    List<TaskModel> result = List.from(tasks);

    if (text != null && text.trim().isNotEmpty) {
      result = searchText(result, text);
    }

    if (category != null && category.trim().isNotEmpty) {
      result = searchCategory(result, category);
    }

    if (tags != null && tags.isNotEmpty) {
      for (final tag in tags) {
        result = searchTag(result, tag);
      }
    }

    if (minPriority != null || maxPriority != null) {
      result = searchPriority(
        result,
        min: minPriority,
        max: maxPriority,
      );
    }

    if (minEmotional != null || maxEmotional != null) {
      result = searchEmotional(
        result,
        min: minEmotional,
        max: maxEmotional,
      );
    }

    if (minFatigue != null || maxFatigue != null) {
      result = searchFatigue(
        result,
        min: minFatigue,
        max: maxFatigue,
      );
    }

    return result;
  }

  // -----------------------------
  // SEARCH SCORING (FUTURE AI HOOK)
  // -----------------------------
  int score(TaskModel task, String query) {
    final q = normalize(query);
    int score = 0;

    if (task.title.toLowerCase().contains(q)) score += 5;
    if ((task.description ?? "").toLowerCase().contains(q)) score += 3;

    if (_fuzzyMatch(task.title, q)) score += 2;

    return score;
  }
}
