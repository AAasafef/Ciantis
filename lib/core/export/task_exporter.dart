import 'dart:convert';
import '../../data/models/task_model.dart';

/// TaskExporter prepares task data for export into:
/// - JSON
/// - CSV
/// - Plain text summaries
///
/// It does NOT write files.
/// It only returns formatted strings.
///
/// Used by:
/// - Backup system
/// - Cloud sync (future)
/// - Developer tools
/// - Analytics exports
/// - Mode Engine snapshots
class TaskExporter {
  // Singleton
  static final TaskExporter instance = TaskExporter._internal();
  TaskExporter._internal();

  // -----------------------------
  // EXPORT AS JSON
  // -----------------------------
  String toJson(List<TaskModel> tasks) {
    final list = tasks.map((t) => t.toMap()).toList();
    return const JsonEncoder.withIndent('  ').convert(list);
  }

  // -----------------------------
  // EXPORT AS CSV
  // -----------------------------
  String toCsv(List<TaskModel> tasks) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln(
      "id,title,description,category,priority,emotionalLoad,fatigueImpact,isCompleted,dueDate",
    );

    for (final t in tasks) {
      buffer.writeln([
        t.id,
        _escape(t.title),
        _escape(t.description ?? ""),
        t.category,
        t.priority,
        t.emotionalLoad,
        t.fatigueImpact,
        t.isCompleted,
        t.dueDate?.toIso8601String() ?? "",
      ].join(","));
    }

    return buffer.toString();
  }

  // -----------------------------
  // EXPORT AS PLAIN TEXT SUMMARY
  // -----------------------------
  String toTextSummary(List<TaskModel> tasks) {
    final buffer = StringBuffer();

    buffer.writeln("TASK SUMMARY");
    buffer.writeln("------------");
    buffer.writeln("Total tasks: ${tasks.length}");
    buffer.writeln(
        "Completed: ${tasks.where((t) => t.isCompleted).length}");
    buffer.writeln("");

    for (final t in tasks) {
      buffer.writeln("• ${t.title}");
      buffer.writeln("  Category: ${t.category}");
      buffer.writeln("  Priority: ${t.priority}");
      buffer.writeln("  Emotional Load: ${t.emotionalLoad}");
      buffer.writeln("  Fatigue Impact: ${t.fatigueImpact}");
      buffer.writeln("  Completed: ${t.isCompleted}");
      if (t.dueDate != null) {
        buffer.writeln("  Due: ${t.dueDate}");
      }
      buffer.writeln("");
    }

    return buffer.toString();
  }

  // -----------------------------
  // INTERNAL HELPERS
  // -----------------------------
  String _escape(String value) {
    if (value.contains(",") || value.contains('"')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
