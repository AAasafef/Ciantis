class RoutineStepModel {
  final String id;

  final String routineId;

  final String title;
  final int duration; // minutes

  final int emotionalLoad;
  final int fatigueImpact;

  final int orderIndex;

  final bool completed; // used during execution flow

  final DateTime createdAt;
  final DateTime updatedAt;

  RoutineStepModel({
    required this.id,
    required this.routineId,
    required this.title,
    required this.duration,
    required this.emotionalLoad,
    required this.fatigueImpact,
    required this.orderIndex,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });

  RoutineStepModel copyWith({
    String? title,
    int? duration,
    int? emotionalLoad,
    int? fatigueImpact,
    int? orderIndex,
    bool? completed,
    DateTime? updatedAt,
  }) {
    return RoutineStepModel(
      id: id,
      routineId: routineId,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      emotionalLoad: emotionalLoad ?? this.emotionalLoad,
      fatigueImpact: fatigueImpact ?? this.fatigueImpact,
      orderIndex: orderIndex ?? this.orderIndex,
      completed: completed ?? this.completed,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory RoutineStepModel.fromMap(Map<String, dynamic> map) {
    return RoutineStepModel(
      id: map['id'],
      routineId: map['routineId'],
      title: map['title'],
      duration: map['duration'],
      emotionalLoad: map['emotionalLoad'],
      fatigueImpact: map['fatigueImpact'],
      orderIndex: map['orderIndex'],
      completed: map['completed'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'routineId': routineId,
      'title': title,
      'duration': duration,
      'emotionalLoad': emotionalLoad,
      'fatigueImpact': fatigueImpact,
      'orderIndex': orderIndex,
      'completed': completed ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
