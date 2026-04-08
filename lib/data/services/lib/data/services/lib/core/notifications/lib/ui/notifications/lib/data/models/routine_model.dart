class RoutineModel {
  final String id;

  final String title;
  final String? description;

  final String category; // morning, night, self-care, kids, school, salon, health, personal

  final int emotionalLoad; // aggregated from steps
  final int fatigueImpact; // aggregated from steps
  final int estimatedDuration; // minutes

  final int streak;
  final DateTime? lastCompleted;

  final DateTime createdAt;
  final DateTime updatedAt;

  RoutineModel({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.emotionalLoad,
    required this.fatigueImpact,
    required this.estimatedDuration,
    required this.streak,
    this.lastCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  RoutineModel copyWith({
    String? title,
    String? description,
    String? category,
    int? emotionalLoad,
    int? fatigueImpact,
    int? estimatedDuration,
    int? streak,
    DateTime? lastCompleted,
    DateTime? updatedAt,
  }) {
    return RoutineModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      emotionalLoad: emotionalLoad ?? this.emotionalLoad,
      fatigueImpact: fatigueImpact ?? this.fatigueImpact,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      streak: streak ?? this.streak,
      lastCompleted: lastCompleted ?? this.lastCompleted,
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
      emotionalLoad: map['emotionalLoad'],
      fatigueImpact: map['fatigueImpact'],
      estimatedDuration: map['estimatedDuration'],
      streak: map['streak'],
      lastCompleted:
          map['lastCompleted'] != null ? DateTime.parse(map['lastCompleted']) : null,
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
      'emotionalLoad': emotionalLoad,
      'fatigueImpact': fatigueImpact,
      'estimatedDuration': estimatedDuration,
      'streak': streak,
      'lastCompleted': lastCompleted?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
