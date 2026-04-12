import '../task_facade.dart';
import '../models/task.dart';

/// TaskSearchEngine provides:
/// - Global search
/// - Smart filters
/// - Natural-language style matching
/// - Mode-aware filtering
///
/// This powers search bars, filtered views, and quick filters.
class TaskSearchEngine {
  // Singleton
  static final TaskSearchEngine instance =
      TaskSearchEngine._internal();
  TaskSearchEngine._internal();

  final _facade = TaskFacade.instance;

  // -----------------------------
  // BASIC SEARCH (title + notes)
  // -----------------------------
  List<Task> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return _facade.all;

    return _facade.all.where((t) {
      return t.title.toLowerCase().contains(q) ||
          (t.notes?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  // -----------------------------
  // FILTER BY PRIORITY
  // -----------------------------
  List<Task> byPriority(TaskPriority priority) {
    return _facade.all.where((t) => t.priority == priority).toList();
  }

  // -----------------------------
  // FILTER BY ENERGY
  // -----------------------------
  List<Task> byEnergy(TaskEnergy energy) {
    return _facade.all.where((t) => t.energy == energy).toList();
  }

  // -----------------------------
  // FILTER BY FLEXIBILITY
  // -----------------------------
  List<Task> byFlexibility(TaskFlexibility flex) {
    return _facade.all.where((t) => t.flexibility == flex).toList();
  }

  // -----------------------------
  // FILTER BY STARRED
  // -----------------------------
  List<Task> starred() {
    return _facade.all.where((t) => t.isStarred).toList();
  }

  // -----------------------------
  // FILTER BY COMPLETED
  // -----------------------------
  List<Task> completed() {
    return _facade.all.where((t) => t.isCompleted).toList();
  }

  // -----------------------------
  // FILTER BY OVERDUE
  // -----------------------------
  List<Task> overdue(DateTime now) {
    return _facade.all.where((t) {
      return t.dueDate != null &&
          t.dueDate!.isBefore(now) &&
          !t.isCompleted;
    }).toList();
  }

  // -----------------------------
  // FILTER BY DUE TODAY
  // -----------------------------
  List<Task> dueToday(DateTime now) {
    return _facade.all.where((t) {
      if (t.dueDate == null) return false;
      return t.dueDate!.year == now.year &&
          t.dueDate!.month == now.month &&
          t.dueDate!.day == now.day;
    }).toList();
  }

  // -----------------------------
  // MODE-AWARE FILTERING
  // -----------------------------
  List<Task> modeFilter(String mode, DateTime now) {
    switch (mode) {
      case "focus":
        return _facade.all.where((t) {
          return !t.isCompleted &&
              t.priority == TaskPriority.high;
        }).toList();

      case "fatigue":
        return _facade.all.where((t) {
          return !t.isCompleted &&
              t.energy == TaskEnergy.low;
        }).toList();

      case "recovery":
        return _facade.all.where((t) {
          return !t.isCompleted &&
              t.flexibility == TaskFlexibility.flexible;
        }).toList();

      default:
        return _facade.all;
    }
  }

  // -----------------------------
  // COMBINED FILTERS
  // -----------------------------
  List<Task> advanced({
    String? query,
    TaskPriority? priority,
    TaskEnergy? energy,
    TaskFlexibility? flexibility,
    bool? starred,
    bool? completed,
    bool? overdue,
    bool? dueToday,
    String? mode,
    DateTime? now,
  }) {
    final n = now ?? DateTime.now();
    var list = _facade.all;

    if (query != null && query.trim().isNotEmpty) {
      list = search(query);
    }

    if (priority != null) {
      list = list.where((t) => t.priority == priority).toList();
    }

    if (energy != null) {
      list = list.where((t) => t.energy == energy).toList();
    }

    if (flexibility != null) {
      list = list.where((t) => t.flexibility == flexibility).toList();
    }

    if (starred == true) {
      list = list.where((t) => t.isStarred).toList();
    }

    if (completed == true) {
      list = list.where((t) => t.isCompleted).toList();
    }

    if (overdue == true) {
      list = list.where((t) =>
          t.dueDate != null &&
          t.dueDate!.isBefore(n) &&
          !t.isCompleted).toList();
    }

    if (dueToday == true) {
      list = list.where((t) {
        if (t.dueDate == null) return false;
        return t.dueDate!.year == n.year &&
            t.dueDate!.month == n.month &&
            t.dueDate!.day == n.day;
      }).toList();
    }

    if (mode != null) {
      list = modeFilter(mode, n);
    }

    return list;
  }
}
