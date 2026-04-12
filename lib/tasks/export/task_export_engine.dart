import 'dart:convert';

import '../task_facade.dart';
import '../models/task.dart';

/// TaskExportEngine handles exporting tasks to:
/// - JSON (full backup)
/// - CSV (developer/debug)
///
/// This mirrors the CalendarExportEngine for consistency.
class TaskExportEngine {
  // Singleton
  static final TaskExportEngine instance =
      TaskExportEngine._internal();
  TaskExportEngine._internal();

  final _facade = TaskFacade.instance;

  // -----------------------------
  // EXPORT AS JSON
  // -----------------------------
  String exportAllAsJson() {
    final tasks = _facade.all;
    final list = tasks.map((t) => t.toMap()).toList();
    return const JsonEncoder.withIndent('  ').convert(list);
  }

  // -----------------------------
  // EXPORT AS CSV
  // -----------------------------
  String exportAllAsCsv() {
    final tasks = _facade.all;

    final buffer = StringBuffer();
    buffer.writeln(
      "id,title,notes,dueDate,scheduledStart,scheduledEnd,priority,energy,flexibility,isCompleted,isStarred,source",
    );

    for (final t in tasks) {
      buffer.writeln(
        [
          t.id,
          _escape(t.title),
          _escape(t.notes ?? ""),
          t.dueDate?.toIso8601String() ?? "",
          t.scheduledStart?.toIso8601String() ?? "",
          t.scheduledEnd?.toIso8601String() ?? "",
          t.priority.name,
          t.energy.name,
          t.flexibility.name,
          t.isCompleted,
          t.isStarred,
          t.source ?? "",
        ].join(","),
      );
    }

    return buffer.toString();
  }

  // -----------------------------
  // ESCAPE CSV FIELDS
  // -----------------------------
  String _escape(String value) {
    if (value.contains(",") || value.contains("\"")) {
      return "\"${value.replaceAll("\"", "\"\"")}\"";
    }
    return value;
  }
}
