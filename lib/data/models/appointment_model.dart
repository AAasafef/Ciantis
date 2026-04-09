class AppointmentModel {
  final String id;

  final String title;
  final String? description;
  final String? location;

  final String category; // school, kids, salon, health, personal

  final DateTime startTime;
  final DateTime endTime;

  final int emotionalLoad; // 1–10
  final int fatigueImpact; // 1–10

  final bool isCompleted;

  final bool reminderEnabled;
  final int? reminderMinutesBefore; // e.g., 10, 30, 60

  final DateTime createdAt;
  final DateTime updatedAt;

  AppointmentModel({
    required this.id,
    required this.title,
    this.description,
    this.location,
    required this.category,
    required this.startTime,
    required this.endTime,
    required this.emotionalLoad,
    required this.fatigueImpact,
    required this.isCompleted,
    required this.reminderEnabled,
    this.reminderMinutesBefore,
    required this.createdAt,
    required this.updatedAt,
  });

  AppointmentModel copyWith({
    String? title,
    String? description,
    String? location,
    String? category,
    DateTime? startTime,
    DateTime? endTime,
    int? emotionalLoad,
    int? fatigueImpact,
    bool? isCompleted,
    bool? reminderEnabled,
    int? reminderMinutesBefore,
    DateTime? updatedAt,
  }) {
    return AppointmentModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      category: category ?? this.category,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      emotionalLoad: emotionalLoad ?? this.emotionalLoad,
      fatigueImpact: fatigueImpact ?? this.fatigueImpact,
      isCompleted: isCompleted ?? this.isCompleted,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderMinutesBefore:
          reminderMinutesBefore ?? this.reminderMinutesBefore,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      location: map['location'],
      category: map['category'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      emotionalLoad: map['emotionalLoad'],
      fatigueImpact: map['fatigueImpact'],
      isCompleted: map['isCompleted'] == 1,
      reminderEnabled: map['reminderEnabled'] == 1,
      reminderMinutesBefore: map['reminderMinutesBefore'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'category': category,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'emotionalLoad': emotionalLoad,
      'fatigueImpact': fatigueImpact,
      'isCompleted': isCompleted ? 1 : 0,
      'reminderEnabled': reminderEnabled ? 1 : 0,
      'reminderMinutesBefore': reminderMinutesBefore,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
