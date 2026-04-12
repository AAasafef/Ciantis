import '../models/task.dart';

/// TaskSortingEngine defines the universal sorting logic for Tasks OS.
/// 
/// Sorting factors (in order of weight):
/// 1. Completion status
/// 2. Due date urgency
/// 3. Priority
/// 4. Energy requirement
/// 5. Flexibility
/// 6. Starred tasks
/// 7. Alphabetical fallback
///
/// This ensures consistent ordering across:
/// - Today view
/// - Overdue list
/// - Smart suggestions
/// - Daily planning
/// - Academic + Routine integrations
class TaskSortingEngine {
  // Singleton
  static final TaskSortingEngine instance =
      TaskSortingEngine._internal();
  TaskSortingEngine._internal();

  // -----------------------------
  // SORT LIST
  // -----------------------------
  List<Task> sort(List<Task> tasks) {
    final list = List<Task>.from(tasks);

    list.sort((a, b) {
      // 1. Completed always go last
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }

      // 2. Due date urgency
      final dueA = a.dueDate;
      final dueB = b.dueDate;

      if (dueA != null && dueB != null) {
        final cmp = dueA.compareTo(dueB);
        if (cmp != 0) return cmp;
      } else if (dueA != null) {
        return -1; // tasks with due dates come first
      } else if (dueB != null) {
        return 1;
      }

      // 3. Priority
      final priorityCmp = b.priority.index.compareTo(a.priority.index);
      if (priorityCmp != 0) return priorityCmp;

      // 4. Energy (lower energy first for accessibility)
      final energyCmp = a.energy.index.compareTo(b.energy.index);
      if (energyCmp != 0) return energyCmp;

      // 5. Flexibility (fixed tasks first)
      final flexCmp = a.flexibility.index.compareTo(b.flexibility.index);
      if (flexCmp != 0) return flexCmp;

      // 6. Starred tasks
      if (a.isStarred != b.isStarred) {
        return a.isStarred ? -1 : 1;
      }

      // 7. Alphabetical fallback
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });

    return list;
  }
}
