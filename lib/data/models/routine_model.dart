import 'package:uuid/uuid.dart';

class RoutineStepModel {
  final String id;
  final String title;
  final int order;
  final int durationMinutes; // for timers
  final int emotionalLoad;   // 1–10
  final int fatigueImpact;   // 1–10
  final bool isCompleted;

  RoutineStepModel({
    String? id,
    required this.title,
    required this.order,
    this.durationMinutes = 1,
    this.emotionalLoad = 3,
    this.fatigueImpact = 3,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v4();

  RoutineStepModel copyWith({
    String? title,
    int? order,
    int? durationMinutes,
    int? emotionalLoad,
    int? fatigueImpact,
    bool? isCompleted,
  }) {
    return RoutineStepModel(
      id: id,
      title: title ?? this.title,
      order: order ?? this.order,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      emotionalLoad: emotionalLoad ?? this.emotionalLoad,
      fatigueImpact: fatigueImpact ?? this.fatigueImpact,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "order": order,
      "durationMinutes": durationMinutes,
      "emotionalLoad": emotionalLoad,
      "fatigueImpact": fatigueImpact,
      "isCompleted": isCompleted,
    };
  }

  factory RoutineStepModel.fromMap(Map<String, dynamic> map) {
    return RoutineStepModel(
      id: map["id"],
      title: map["title"],
      order: map["order"],
      durationMinutes: map["durationMinutes"] ?? 1,
      emotionalLoad: map["emotionalLoad"] ?? 3,
      fatigueImpact: map["fatigueImpact"] ?? 3,
      isCompleted: map["isCompleted"] ?? false,
    );
  }
}

class RoutineModel {
  final String id;
  final String title;
  final String? description;

  final String category; // morning, night, kids, salon, health, study, custom
  final bool isActive;

  final int emotionalLoad;   // aggregated
  final int fatigueImpact;   // aggregated

  final List<RoutineStepModel> steps;

  final int streak;
  final DateTime? lastCompletedAt;

  final DateTime createdAt;
  final DateTime updatedAt;

  RoutineModel({
    String? id,
    required this.title,
    this.description,
    required this.category,
    this.isActive = true,
    this.emotionalLoad = 3,
    this.fatigueImpact = 3,
    this.steps = const [],
    this.streak = 0,
    this.lastCompletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  RoutineModel copyWith({
    String? title,
    String? description,
    String? category,
    bool? isActive,
    int? emotionalLoad,
    int? fatigueImpact,
    List<RoutineStepModel>? steps,
    int? streak,
    DateTime? lastCompletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RoutineModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      emotionalLoad: emotionalLoad ?? this.emotionalLoad,
      fatigueImpact: fatigueImpact ?? this.fatigueImpact,
      steps: steps ?? this.steps,
      streak: streak ?? this.streak,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "category": category,
      "isActive": isActive,
      "emotionalLoad": emotionalLoad,
      "fatigueImpact": fatigueImpact,
      "steps": steps.map((s) => s.toMap()).toList(),
      "streak": streak,
      "lastCompletedAt": lastCompletedAt?.toIso8601String(),
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }

  factory RoutineModel.fromMap(Map<String, dynamic> map) {
    return RoutineModel(
      id: map["id"],
      title: map["title"],
      description: map["description"],
      category: map["category"],
      isActive: map["isActive"] ?? true,
      emotionalLoad: map["emotionalLoad"] ?? 3,
      fatigueImpact: map["fatigueImpact"] ?? 3,
      steps: (map["steps"] as List<dynamic>? ?? [])
          .map((s) => RoutineStepModel.fromMap(s))
          .toList(),
      streak: map["streak"] ?? 0,
      lastCompletedAt: map["lastCompletedAt"] != null
          ? DateTime.parse(map["lastCompletedAt"])
          : null,
      createdAt: DateTime.parse(map["createdAt"]),
      updatedAt: DateTime.parse(map["updatedAt"]),
    );
  }
}
