import 'package:flutter/foundation.dart';

import '../models/calendar_event.dart';

/// EventEditorModel is the UI-facing structure used when
/// creating or editing a calendar event.
///
/// It ensures:
/// - Clean data
/// - Validation
/// - Conversion to CalendarEvent
@immutable
class EventEditorModel {
  final String id;
  final String title;
  final DateTime start;
  final DateTime end;

  final CalendarEventType type;

  final bool isFlexible;
  final bool isImportant;
  final bool isEnergyHeavy;

  final String? notes;

  const EventEditorModel({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.type,
    required this.isFlexible,
    required this.isImportant,
    required this.isEnergyHeavy,
    this.notes,
  });

  // -----------------------------
  // VALIDATION
  // -----------------------------
  bool get isValid {
    if (title.trim().isEmpty) return false;
    if (!end.isAfter(start)) return false;
    return true;
  }

  // -----------------------------
  // CONVERT TO CALENDAR EVENT
  // -----------------------------
  CalendarEvent toEvent() {
    return CalendarEvent(
      id: id,
      title: title.trim(),
      start: start,
      end: end,
      type: type,
      isFlexible: isFlexible,
      isImportant: isImportant,
      isEnergyHeavy: isEnergyHeavy,
      notes: notes?.trim(),
      source: "local",
    );
  }

  // -----------------------------
  // COPY WITH
  // -----------------------------
  EventEditorModel copyWith({
    String? id,
    String? title,
    DateTime? start,
    DateTime? end,
    CalendarEventType? type,
    bool? isFlexible,
    bool? isImportant,
    bool? isEnergyHeavy,
    String? notes,
  }) {
    return EventEditorModel(
      id: id ?? this.id,
      title: title ?? this.title,
      start: start ?? this.start,
      end: end ?? this.end,
      type: type ?? this.type,
      isFlexible: isFlexible ?? this.isFlexible,
      isImportant: isImportant ?? this.isImportant,
      isEnergyHeavy: isEnergyHeavy ?? this.isEnergyHeavy,
      notes: notes ?? this.notes,
    );
  }
}
