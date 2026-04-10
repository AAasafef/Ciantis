import 'package:flutter/material.dart';
import 'task_model.dart';

/// Extensions that add convenience helpers, computed properties,
/// and intelligence-ready metadata to TaskModel.
extension TaskModelExtensions on TaskModel {
  // -----------------------------
  // PRIORITY COLOR
  // -----------------------------
  Color get priorityColor {
    switch (priority) {
      case 5:
        return const Color(0xFFE57373); // red
      case 4:
        return const Color(0xFFFF8A3D); // orange
      case 3:
        return const Color(0xFFFFC94A); // yellow
      case 2:
        return const Color(0xFF8A4FFF); // purple
      default:
        return const Color(0xFFB6AFC8); // soft gray
    }
  }

  // -----------------------------
  // EMOTIONAL LOAD LABEL
  // -----------------------------
  String get emotionalLabel {
    if (emotionalLoad >= 8) return "Heavy";
    if (emotionalLoad >= 5) return "Moderate";
    return "Light";
  }

  // -----------------------------
  // FATIGUE IMPACT LABEL
  // -----------------------------
  String get fatigueLabel {
    if (fatigueImpact >= 8) return "Draining";
    if (fatigueImpact >= 5) return "Manageable";
    return "Light";
  }

  // -----------------------------
  // DUE TODAY?
  // -----------------------------
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  // -----------------------------
  // OVERDUE?
  // -----------------------------
  bool get isOverdue {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return !isCompleted && dueDate!.isBefore(now);
  }

  // -----------------------------
  // URGENCY SCORE (AI HOOK)
  // -----------------------------
  /// A combined score used later by:
  /// - Mode Engine
  /// - Next Best Action Engine
  /// - AI Suggestion Engine
  ///
  /// Formula (modifiable later):
  /// priority * 2 + emotionalLoad + fatigueImpact + (isDueToday ? 5 : 0) + (isOverdue ? 8 : 0)
  int get urgencyScore {
    int score = 0;

    score += priority * 2;
    score += emotionalLoad;
    score += fatigueImpact;

    if (isDueToday) score += 5;
    if (isOverdue) score += 8;

    return score;
  }
}
