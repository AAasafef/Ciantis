class RoutineModel {
  final String id;
  final String title;
  final String? description;

  final String category; // school, kids, salon, health, personal
  final int priority; // 1–5

  final int emotionalLoad; // auto-calculated from steps
  final int fatigueImpact; // auto-calculated from steps

  final List<RoutineStepModel> steps;

  final bool active;
  final int streak;
  final DateTime? lastCompletedDate;

  final DateTime createdAt;
  final DateTime updatedAt;

  RoutineModel({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.priority,
    required this.emotionalLoad,
    required this.fatigueImpact,
    required this.steps,
    required this.active,
    required this.streak,
    required this.lastCompletedDate,
    required this.createdAt,
    required this.updatedAt,
  });

  RoutineModel copyWith({
    String? title,
    String? description,
    String? category,
    int? priority,
    int? emotionalLoad,
    int? fatigueImpact,
    List<RoutineStepModel>? steps,
    bool? active,
    int? streak,
    DateTime? lastCompletedDate,
    DateTime? updatedAt,
  }) {
    return RoutineModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      emotionalLoad: emotionalLoad ?? this.emotionalLoad,
      fatigueImpact: fatigueImpact ?? this.fatigueImpact,
      steps: steps ?? this.steps,
      active: active ?? this.active,
      streak: streak ?? this.streak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory RoutineModel.fromMap(Map<String, dynamic> map) {
    return RoutineModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      priority: map['priority'],
      emotionalLoad: map['emotionalLoad'],
      fatigueImpact: map['fatigueImpact'],
      steps: (map['steps'] as List)
          .map((e) => RoutineStepModel.fromMap(e))
          .toList(),
      active: map['active'] == 1,
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
      'steps': steps.map((e) => e.toMap()).toList(),
      'active': active ? 1 : 0,
      'streak': streak,
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class RoutineStepModel {
  final String id;
  final String title;
  final int order;
  final int durationMinutes; // estimated duration
  final int emotionalLoad; // 1–10
  final int fatigueImpact; // 1–10

  RoutineStepModel({
    required this.id,
    required this.title,
    required this.order,
    required this.durationMinutes,
    required this.emotionalLoad,
    required this.fatigueImpact,
  });

  RoutineStepModel copyWith({
    String? title,
    int? order,
    int? durationMinutes,
    int? emotionalLoad,
    int? fatigueImpact,
  }) {
    return RoutineStepModel(
      id: id,
      title: title ?? this.title,
      order: order ?? this.order,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      emotionalLoad: emotionalLoad ?? this.emotionalLoad,
      fatigueImpact: fatigueImpact ?? this.fatigueImpact,
    );
  }

  factory RoutineStepModel.fromMap(Map<String, dynamic> map) {
    return RoutineStepModel(
      id: map['id'],
      title: map['title'],
      order: map['order'],
      durationMinutes: map['durationMinutes'],
      emotionalLoad: map['emotionalLoad'],
      fatigueImpact: map['fatigueImpact'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'order': order,
      'durationMinutes': durationMinutes,
      'emotionalLoad': emotionalLoad,
      'fatigueImpact': fatigueImpact,
    };
  }
}
