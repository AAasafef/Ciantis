import 'package:flutter/material.dart';

/// TaskPriority defines how important a task is.
/// This affects:
/// - Sorting
/// - Insights
/// - Smart scheduling
enum TaskPriority {
  low,
  medium,
  high,
  critical,
}

/// TaskEnergy defines how much energy the task requires.
/// This integrates with:
/// - Mode Engine
/// - Daily energy load
/// - Smart scheduling
enum TaskEnergy {
  low,
  medium,
  high,
}

/// TaskFlexibility defines how movable a task is.
/// This affects:
/// - Auto‑scheduling
/// - Reshuffling
/// - Daily planning
enum TaskFlexibility {
  fixed,      // must be done today
  flexible,   // can move within a few days
  anytime,    // no strict date
}

/// Core Task model for Ciantis Tasks OS.
class Task {
  final String id;
  String title;
  String? notes;

  DateTime? dueDate;
  DateTime? scheduledStart;
  DateTime? scheduledEnd;

  TaskPriority priority;
  TaskEnergy energy;
  TaskFlexibility flexibility;

  bool isCompleted;
  bool isStarred; // user‑flagged importance

  // For routines + academic integration
  String? source; // "routine", "course", "manual", etc.

  Task({
    required this.id,
    required this.title,
    this.notes,
    this.dueDate,
    this.scheduledStart,
    this.scheduledEnd,
    this.priority = TaskPriority.medium,
    this.energy = TaskEnergy.medium,
    this.flexibility = TaskFlexibility.flexible,
    this.isCompleted = false,
    this.isStarred = false,
    this.source,
  });

  // -----------------------------
  // COPY WITH
  // -----------------------------
  Task copyWith({
    String? title,
    String? notes,
    DateTime? dueDate,
    DateTime? scheduledStart,
    DateTime? scheduledEnd,
    TaskPriority? priority,
    TaskEnergy? energy,
    TaskFlexibility? flexibility,
    bool? isCompleted,
    bool? isStarred,
    String? source,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      dueDate: dueDate ?? this.dueDate,
      scheduledStart: scheduledStart ?? this.scheduledStart,
      scheduledEnd: scheduledEnd ?? this.scheduledEnd,
      priority: priority ?? this.priority,
      energy: energy ?? this.energy,
      flexibility: flexibility ?? this.flexibility,
      isCompleted: isCompleted ?? this.isCompleted,
      isStarred: isStarred ?? this.isStarred,
      source: source ?? this.source,
    );
  }

  // -----------------------------
  // SERIALIZATION
  // -----------------------------
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "notes": notes,
      "dueDate": dueDate?.toIso8601String(),
      "scheduledStart": scheduledStart?.toIso8601String(),
      "scheduledEnd": scheduledEnd?.toIso8601String(),
      "priority": priority.name,
      "energy": energy.name,
      "flexibility": flexibility.name,
      "isCompleted": isCompleted,
      "isStarred": isStarred,
      "source": source,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map["id"],
      title: map["title"],
      notes: map["notes"],
      dueDate: map["dueDate"] != null
          ? DateTime.parse(map["dueDate"])
          : null,
      scheduledStart: map["scheduledStart"] != null
          ? DateTime.parse(map["scheduledStart"])
          : null,
      scheduledEnd: map["scheduledEnd"] != null
          ? DateTime.parse(map["scheduledEnd"])
          : null,
      priority: TaskPriority.values.firstWhere(
        (p) => p.name == map["priority"],
        orElse: () => TaskPriority.medium,
      ),
      energy: TaskEnergy.values.firstWhere(
        (e) => e.name == map["energy"],
        orElse: () => TaskEnergy.medium,
      ),
      flexibility: TaskFlexibility.values.firstWhere(
        (f) => f.name == map["flexibility"],
        orElse: () => TaskFlexibility.flexible,
      ),
      isCompleted: map["isCompleted"] ?? false,
      isStarred: map["isStarred"] ?? false,
      source: map["source"],
    );
  }
}
