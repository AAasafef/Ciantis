class HabitModel {
  final String id;
  final String title;
  final String? description;

  final String category; // school, kids, salon, health, personal
  final int priority; // 1–5

  final int emotionalLoad; // auto-calculated
  final int fatigueImpact; // auto-calculated

  final List<int> days; // 1=Mon ... 7=Sun
  final bool active;

  final int streak;
  final DateTime? lastCompletedDate;

  final DateTime createdAt;
  final DateTime updatedAt;

  HabitModel({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.priority,
    required this.emotionalLoad,
    required this.fatigueImpact,
    required this.days,
    required this.active,
    required this.streak,
    required this.lastCompletedDate,
    required this.createdAt,
    required this.updatedAt,
  });

  HabitModel copyWith({
    String? title,
    String? description,
    String? category,
    int? priority,
    int? emotionalLoad,
    int? fatigueImpact,
    List<int>? days,
    bool? active,
    int? streak,
    DateTime? lastCompletedDate,
    DateTime? updatedAt,
  }) {
    return HabitModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      emotionalLoad: emotionalLoad ?? this.emotionalLoad,
      fatigueImpact: fatigueImpact ?? this.fatigueImpact,
      days: days ?? this.days,
      active: active ?? this.active,
      streak: streak ?? this.streak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      priority: map['priority'],
      emotionalLoad: map['emotionalLoad'],
      fatigueImpact: map['fatigueImpact'],
      days: (map['days'] as String)
          .split(',')
          .map((e) => int.parse(e))
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
      'days': days.join(','),
      'active': active ? 1 : 0,
      'streak': streak,
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
