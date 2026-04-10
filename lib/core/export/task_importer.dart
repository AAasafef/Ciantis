import 'dart:convert';
import '../../data/models/task_model.dart';

/// TaskImporter converts external data formats into TaskModel objects.
/// Supports:
/// - JSON import
/// - CSV import
/// - Plain text summary import (lightweight)
///
/// This does NOT save tasks.
/// It only parses them into TaskModel objects.
///
/// Used by:
/// - Backup restore
/// - Cloud sync (future)
/// - Developer tools
/// - Bulk task creation
class TaskImporter {
  // Singleton
  static final TaskImporter instance = TaskImporter._internal();
  TaskImporter._internal();

  // -----------------------------
  // IMPORT FROM JSON
  // -----------------------------
  List<TaskModel> fromJson(String jsonString) {
    final decoded = json.decode(jsonString);

    if (decoded is! List) return [];

    return decoded.map<TaskModel>((item) {
      return TaskModel.fromMap(Map<String, dynamic>.from(item));
    }).toList();
  }

  // -----------------------------
  // IMPORT FROM CSV
  // -----------------------------
  List<TaskModel> fromCsv(String csvString) {
    final lines = csvString.split('\n').where((l) => l.trim().isNotEmpty);

    final List<TaskModel> tasks = [];

    bool isHeader = true;

    for (final line in lines) {
      if (isHeader) {
        isHeader = false;
        continue;
      }

      final parts = _parseCsvLine(line);
      if (parts.length < 9) continue;

      tasks.add(
        TaskModel(
          id: parts[0],
          title: parts[1],
          description: parts[2].isEmpty ? null : parts[2],
          category: parts[3],
          priority: int.tryParse(parts[4]) ?? 1,
          emotionalLoad: int.tryParse(parts[5]) ?? 1,
          fatigueImpact: int.tryParse(parts[6]) ?? 1,
          isCompleted: parts[7].toLowerCase() == "true",
          dueDate: parts[8].isEmpty ? null : DateTime.tryParse(parts[8]),
        ),
      );
    }

    return tasks;
  }

  // -----------------------------
  // IMPORT FROM TEXT SUMMARY
  // (Very lightweight parser)
  // -----------------------------
  List<TaskModel> fromTextSummary(String text) {
    final lines = text.split('\n');

    final List<TaskModel> tasks = [];
    String? title;
    String category = "personal";
    int priority = 3;
    int emotional = 3;
    int fatigue = 3;
    bool completed = false;
    DateTime? due;

    for (final line in lines) {
      final trimmed = line.trim();

      if (trimmed.startsWith("• ")) {
        // Save previous task if exists
        if (title != null) {
          tasks.add(
            TaskModel.create(
              title: title!,
              description: "",
              category: category,
              priority: priority,
              emotionalLoad: emotional,
              fatigueImpact: fatigue,
              dueDate: due,
            ).copyWith(isCompleted: completed),
          );
        }

        // Start new task
        title = trimmed.substring(2);
        category = "personal";
        priority = 3;
        emotional = 3;
        fatigue = 3;
        completed = false;
        due = null;
      } else if (trimmed.startsWith("Category:")) {
        category = trimmed.replaceFirst("Category:", "").trim();
      } else if (trimmed.startsWith("Priority:")) {
        priority = int.tryParse(
              trimmed.replaceFirst("Priority:", "").trim(),
            ) ??
            3;
      } else if (trimmed.startsWith("Emotional Load:")) {
        emotional = int.tryParse(
              trimmed.replaceFirst("Emotional Load:", "").trim(),
            ) ??
            3;
      } else if (trimmed.startsWith("Fatigue Impact:")) {
        fatigue = int.tryParse(
              trimmed.replaceFirst("Fatigue Impact:", "").trim(),
            ) ??
            3;
      } else if (trimmed.startsWith("Completed:")) {
        completed =
            trimmed.replaceFirst("Completed:", "").trim().toLowerCase() ==
                "true";
      } else if (trimmed.startsWith("Due:")) {
        due = DateTime.tryParse(
          trimmed.replaceFirst("Due:", "").trim(),
        );
      }
    }

    // Save last task
    if (title != null) {
      tasks.add(
        TaskModel.create(
          title: title!,
          description: "",
          category: category,
          priority: priority,
          emotionalLoad: emotional,
          fatigueImpact: fatigue,
          dueDate: due,
        ).copyWith(isCompleted: completed),
      );
    }

    return tasks;
  }

  // -----------------------------
  // INTERNAL CSV PARSER
  // -----------------------------
  List<String> _parseCsvLine(String line) {
    final List<String> result = [];
    final buffer = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          buffer.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        result.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }

    result.add(buffer.toString());
    return result;
  }
}
