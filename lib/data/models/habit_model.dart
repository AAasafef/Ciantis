import 'package:cloud_firestore/cloud_firestore.dart';

class HabitModel {
  final String id;
  final String title;
  final String? description;

  // daily, weekly, custom
  final String frequency;

  // for weekly habits: [1,3,5] = Mon, Wed, Fri
  final List<int>? targetDays;

  final int streakCount;
  final DateTime? lastCompletedDate;

  final DateTime createdAt;
  final DateTime updatedAt;

  HabitModel({
    required this.id,
    required this.title,
    this.description,
    required this.frequency,
    this.targetDays,
    required this.streakCount,
    this.lastCompletedDate,
    required this.createdAt,
    required this.updatedAt,
  });

  // -----------------------------
  // LOCAL MAP
  // -----------------------------
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'frequency': frequency,
      'targetDays': targetDays?.join(','),
      'streakCount': streakCount,
      'lastCompletedDate':
          lastCompletedDate?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      frequency: map['frequency'],
      targetDays: map['targetDays'] != null
          ? map['targetDays']
              .split(',')
              .map((e) => int.parse(e))
              .toList()
          : null,
      streakCount: map['streakCount'],
      lastCompletedDate: map['lastCompletedDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['lastCompletedDate'],
            )
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'],
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map['updatedAt'],
      ),
    );
  }

  // -----------------------------
  // FIRESTORE
  // -----------------------------
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'frequency': frequency,
      'targetDays': targetDays,
      'streakCount': streakCount,
      'lastCompletedDate': lastCompletedDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory HabitModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return HabitModel(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      frequency: data['frequency'],
      targetDays: data['targetDays'] != null
          ? List<int>.from(data['targetDays'])
          : null,
      streakCount: data['streakCount'],
      lastCompletedDate:
          (data['lastCompletedDate'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}
