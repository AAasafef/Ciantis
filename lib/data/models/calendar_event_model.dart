import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarEventModel {
  final String id;
  final String title;
  final String? description;

  final DateTime startTime;
  final DateTime endTime;

  final String category; // school, kids, salon, health, personal, etc.
  final bool isAllDay;

  final String? location;

  // Emotional intelligence fields
  final int emotionalLoad; // 0–10
  final int fatigueImpact; // 0–10

  final DateTime createdAt;
  final DateTime updatedAt;

  CalendarEventModel({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.category,
    required this.isAllDay,
    this.location,
    required this.emotionalLoad,
    required this.fatigueImpact,
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
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'category': category,
      'isAllDay': isAllDay ? 1 : 0,
      'location': location,
      'emotionalLoad': emotionalLoad,
      'fatigueImpact': fatigueImpact,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory CalendarEventModel.fromMap(Map<String, dynamic> map) {
    return CalendarEventModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime']),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime']),
      category: map['category'],
      isAllDay: map['isAllDay'] == 1,
      location: map['location'],
      emotionalLoad: map['emotionalLoad'],
      fatigueImpact: map['fatigueImpact'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  // -----------------------------
  // FIRESTORE
  // -----------------------------
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
