class TaskModel {
  final String id;
  final String title;
  final String? description;

  final DateTime? dueDate;
  final bool completed;

  final String category; // school, kids, salon, health, personal
  final int priority; // 1–5
  final int emotionalLoad; // auto-calculated
  final int fatigueImpact; // auto-calculated

  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    required this.completed,
    required this.category,
    required this.priority,
    required this.emotionalLoad,
    required this.fatigueImpact,
    required this.createdAt,
    required this.updatedAt,
  });

  TaskModel copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    bool? completed,
    String? category,
    int? priority,
    int? emotionalLoad,
    int? fatigueImpact,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      emotionalLoad: emotionalLoad ?? this.emotionalLoad,
      fatigueImpact: fatigueImpact ?? this.fatigueImpact,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'] != null
          ? DateTime.parse(map['dueDate'])
          : null,
      completed: map['completed'] == 1,
      category: map['category'],
      priority: map['priority'],
      emotionalLoad: map['emotionalLoad'],
      fatigueImpact: map['fatigueImpact'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'completed': completed ? 1 : 0,
      'category': category,
      'priority': priority,
      'emotionalLoad': emotionalLoad,
      'fatigueImpact': fatigueImpact,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
