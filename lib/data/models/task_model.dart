import 'package:uuid/uuid.dart';

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final String category;
  final int priority; // 1–5
  final bool isCompleted;

  final int emotionalLoad; // 1–10
  final int fatigueImpact; // 1–10

  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
    String? id,
    required this.title,
    this.description,
    this.dueDate,
    required this.category,
    required this.priority,
    this.isCompleted = false,
    required this.emotionalLoad,
    required this.fatigueImpact,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  TaskModel copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    String? category,
    int? priority,
    bool? isCompleted,
    int? emotionalLoad,
    int? fatigueImpact,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      emotionalLoad: emotionalLoad ?? this.emotionalLoad,
      fatigueImpact: fatigueImpact ?? this.fatigueImpact,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "dueDate": dueDate?.toIso8601String(),
      "category": category,
      "priority": priority,
      "isCompleted": isCompleted,
      "emotionalLoad": emotionalLoad,
      "fatigueImpact": fatigueImpact,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      dueDate:
          json["dueDate"] != null ? DateTime.parse(json["dueDate"]) : null,
      category: json["category"],
      priority: json["priority"],
      isCompleted: json["isCompleted"],
      emotionalLoad: json["emotionalLoad"],
      fatigueImpact: json["fatigueImpact"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }
}
