import '../models/task_model.dart';
import 'task_service.dart';

/// Extensions that add search and filtering capabilities to TaskService.
/// Keeps UI clean and prepares for future AI + Mode Engine integration.
extension TaskServiceExtensions on TaskService {
  // -----------------------------
  // SEARCH
  // -----------------------------
  List<TaskModel> searchTasks(
    List<TaskModel> tasks,
    String query,
  ) {
    if (query.trim().isEmpty) return tasks;

    final q = query.toLowerCase();

    return tasks.where((t) {
      return t.title.toLowerCase().contains(q) ||
          (t.description ?? "").toLowerCase().contains(q);
    }).toList();
  }

  // -----------------------------
  // CATEGORY FILTER
  // -----------------------------
  List<TaskModel> filterByCategory(
    List<TaskModel> tasks,
    String category,
  ) {
    if (category == "all") return tasks;
    return tasks.where((t) => t.category == category).toList();
  }

  // -----------------------------
  // PRIORITY FILTER
  // -----------------------------
  List<TaskModel> filterByPriority(
    List<TaskModel> tasks,
    int priority,
  ) {
    if (priority == 0) return tasks;
    return tasks.where((t) => t.priority == priority).toList();
  }

  // -----------------------------
  // COMBINED FILTER
  // -----------------------------
  List<TaskModel> applyAllFilters({
    required List<TaskModel> tasks,
    required String searchQuery,
    required String category,
    required int priority,
  }) {
    var filtered = tasks;

    filtered = searchTasks(filtered, searchQuery);
    filtered = filterByCategory(filtered, category);
    filtered = filterByPriority(filtered, priority);

    return filtered;
  }
}
