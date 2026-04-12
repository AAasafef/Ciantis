import 'dart:convert';

import '../calendar_facade.dart';
import '../models/calendar_event.dart';

/// CalendarImportEngine handles importing calendar data from JSON.
///
/// It supports:
/// - Full restore
/// - Merge restore
/// - Validation
/// - Conversion to CalendarEvent
class CalendarImportEngine {
  // Singleton
  static final CalendarImportEngine instance =
      CalendarImportEngine._internal();
  CalendarImportEngine._internal();

  final _facade = CalendarFacade.instance;

  // -----------------------------
  // IMPORT (REPLACE ALL)
  // -----------------------------
  bool importReplaceAll(String jsonString) {
    try {
      final decoded = json.decode(jsonString);

      if (decoded is! List) return false;

      final events = decoded
          .map((e) => _mapToEvent(e as Map<String, dynamic>))
          .whereType<CalendarEvent>()
          .toList();

      _facade.replaceAll(events);
      return true;
    } catch (_) {
      return false;
    }
  }

  // -----------------------------
  // IMPORT (MERGE)
  // -----------------------------
  bool importMerge(String jsonString) {
    try {
      final decoded = json.decode(jsonString);

      if (decoded is! List) return false;

      final events = decoded
          .map((e) => _mapToEvent(e as Map<String, dynamic>))
          .whereType<CalendarEvent>()
          .toList();

      for (final event in events) {
        _facade.upsertEvent(event);
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  // -----------------------------
  // MAP → EVENT
  // -----------------------------
  CalendarEvent? _mapToEvent(Map<String, dynamic> map) {
    try {
      return CalendarEvent(
        id: map["id"],
        title: map["title"],
        start: DateTime.parse(map["start"]),
        end: DateTime.parse(map["end"]),
        type: _parseType(map["type"]),
        isFlexible: map["isFlexible"] ?? false,
        isImportant: map["isImportant"] ?? false,
        isEnergyHeavy: map["isEnergyHeavy"] ?? false,
        notes: map["notes"],
        source: map["source"] ?? "import",
      );
    } catch (_) {
      return null;
    }
  }

  // -----------------------------
  // PARSE EVENT TYPE
  // -----------------------------
  CalendarEventType _parseType(String? value) {
    switch (value) {
      case "deepWork":
        return CalendarEventType.deepWork;
      case "recovery":
        return CalendarEventType.recovery;
      case "meeting":
        return CalendarEventType.meeting;
      case "other":
      default:
        return CalendarEventType.other;
    }
  }
}
