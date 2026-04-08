class TaskModel {
  final String id;
  final String title;
  final String? description;

  final String category; // school, kids, salon, health, personal
  final int priority; // 1–5

  final int emotionalLoad; // 1–10
  final int fatigueImpact; // 1–10

  final DateTime? dueDate;
  final bool completed;

  final int streak; // for recurring tasks
  final DateTime? lastCompletedDate;

  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.priority,
    required this.emotionalLoad,
    required this.fatigueImpact,
    required this.dueDate,
    required this.completed,
    required this.streak,
    required this.lastCompletedDate,
    required this.createdAt,
    required this.updatedAt,
  });

  TaskModel copyWith({
    String? title,
    String? description,
    String? category,
    int? priority,
    int? emotionalLoad,
    int? fatigueImpact,
    DateTime? dueDate,
    bool? completed,
    int? streak,
    DateTime? lastCompletedDate,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      emotionalLoad: emotionalLoad ?? this.emotionalLoad,
      fatigueImpact: fatigueImpact ?? this.fatigueImpact,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
      streak: streak ?? this.streak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      priority: map['priority'],
      emotionalLoad: map['emotionalLoad'],
      fatigueImpact: map['fatigueImpact'],
      dueDate:
          map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      completed: map['completed'] == 1,
      streak: map['streak'],
      lastCompletedDate: map['lastCompletedDate'] != null
          ? DateTime.parse(map['lastCompletedDate'])
          : null,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'emotionalLoad': emotionalLoad,
      'fatigueImpact': fatigueImpact,
      'dueDate': dueDate?.toIso8601String(),
      'completed': completed ? 1 : 0,
      'streak': streak,
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
