import 'package:uuid/uuid.dart';

class TaskModel {
  final String id;
  final String title;
  final String? description;

  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? completedAt;

  final bool isCompleted;

  final int emotionalLoad;   // 1–10
  final int fatigueImpact;   // 1–10

  final String category;     // school, kids, salon, health, personal
  final String? location;

  final bool hasSubtasks;
  final List<String> subtaskIds;

  final bool reminderEnabled;
  final int reminderMinutesBefore;

  final bool isRecurring;
  final String? recurrenceRule; // e.g. "daily", "weekly", "monthly"

  TaskModel({
    String? id,
    required this.title,
    this.description,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
    this.isCompleted = false,
    this.emotionalLoad = 3,
    this.fatigueImpact = 3,
    this.category = "personal",
    this.location,
    this.hasSubtasks = false,
    this.subtaskIds = const [],
    this.reminderEnabled = false,
    this.reminderMinutesBefore = 30,
    this.isRecurring = false,
    this.recurrenceRule,
  }) : id = id ?? const Uuid().v4();

  TaskModel copyWith({
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
    bool? isCompleted,
    int? emotionalLoad,
    int? fatigueImpact,
    String? category,
    String? location,
    bool? hasSubtasks,
    List<String>? subtaskIds,
    bool? reminderEnabled,
    int? reminderMinutesBefore,
    bool? isRecurring,
    String? recurrenceRule,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      emotionalLoad: emotionalLoad ?? this.emotionalLoad,
      fatigueImpact: fatigueImpact ?? this.fatigueImpact,
      category: category ?? this.category,
      location: location ?? this.location,
      hasSubtasks: hasSubtasks ?? this.hasSubtasks,
      subtaskIds: subtaskIds ?? this.subtaskIds,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderMinutesBefore:
          reminderMinutesBefore ?? this.reminderMinutesBefore,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "createdAt": createdAt.toIso8601String(),
      "dueDate": dueDate?.toIso8601String(),
      "completedAt": completedAt?.toIso8601String(),
      "isCompleted": isCompleted,
      "emotionalLoad": emotionalLoad,
      "fatigueImpact": fatigueImpact,
      "category": category,
      "location": location,
      "hasSubtasks": hasSubtasks,
      "subtaskIds": subtaskIds,
      "reminderEnabled": reminderEnabled,
      "reminderMinutesBefore": reminderMinutesBefore,
      "isRecurring": isRecurring,
      "recurrenceRule": recurrenceRule,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map["id"],
      title: map["title"],
      description: map["description"],
      createdAt: DateTime.parse(map["createdAt"]),
      dueDate:
          map["dueDate"] != null ? DateTime.parse(map["dueDate"]) : null,
      completedAt: map["completedAt"] != null
          ? DateTime.parse(map["completedAt"])
          : null,
      isCompleted: map["isCompleted"] ?? false,
      emotionalLoad: map["emotionalLoad"] ?? 3,
      fatigueImpact: map["fatigueImpact"] ?? 3,
      category: map["category"] ?? "personal",
      location: map["location"],
      hasSubtasks: map["hasSubtasks"] ?? false,
      subtaskIds: List<String>.from(map["subtaskIds"] ?? []),
      reminderEnabled: map["reminderEnabled"] ?? false,
      reminderMinutesBefore: map["reminderMinutesBefore"] ?? 30,
      isRecurring: map["isRecurring"] ?? false,
      recurrenceRule: map["recurrenceRule"],
    );
  }
}
