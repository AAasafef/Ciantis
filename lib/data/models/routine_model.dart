import 'package:cloud_firestore/cloud_firestore.dart';

class RoutineStep {
  final String id;
  final String title;
  final int? durationMinutes;
  final bool isCompleted;
  final String? emotionalNote;
  final int order;

  RoutineStep({
    required this.id,
    required this.title,
    this.durationMinutes,
    required this.isCompleted,
    this.emotionalNote,
    required this.order,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted ? 1 : 0,
      'emotionalNote': emotionalNote,
      'order': order,
    };
  }

  factory RoutineStep.fromMap(Map<String, dynamic> map) {
    return RoutineStep(
      id: map['id'],
      title: map['title'],
      durationMinutes: map['durationMinutes'],
      isCompleted: map['isCompleted'] == 1,
      emotionalNote: map['emotionalNote'],
      order: map['order'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
      'emotionalNote': emotionalNote,
      'order': order,
    };
  }

  factory RoutineStep.fromFirestore(Map<String, dynamic> data, String id) {
    return RoutineStep(
      id: id,
      title: data['title'],
      durationMinutes: data['durationMinutes'],
      isCompleted: data['isCompleted'],
      emotionalNote: data['emotionalNote'],
      order: data['order'],
    );
  }
}

class RoutineModel {
  final String id;
  final String title;
  final String? description;
  final String category; // morning, night, kids, salon, health, custom
  final List<RoutineStep> steps;
  final DateTime createdAt;
  final DateTime updatedAt;

  RoutineModel({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.steps,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'steps': steps.map((s) => s.toMap()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory RoutineModel.fromMap(Map<String, dynamic> map) {
    return RoutineModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      steps: (map['steps'] as List)
          .map((s) => RoutineStep.fromMap(s))
          .toList(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'steps': steps.map((s) => s.toFirestore()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory RoutineModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final stepsData = data['steps'] as List<dynamic>;

    return RoutineModel(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      category: data['category'],
      steps: stepsData
          .asMap()
          .entries
          .map((entry) => RoutineStep.fromFirestore(
                entry.value,
                entry.key.toString(),
              ))
          .toList(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}
