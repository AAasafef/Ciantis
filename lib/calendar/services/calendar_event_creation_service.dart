import '../models/calendar_event_model.dart';
import 'calendar_service.dart';

/// CalendarEventCreationService is a high-level helper for:
/// - Building new events with defaults
/// - Integrating conflict detection
/// - Integrating smart scheduling
/// - Providing a clean API for UI event creation
///
/// It does NOT own storage or builders; it orchestrates CalendarService.
class CalendarEventCreationService {
  // Singleton
  static final CalendarEventCreationService instance =
      CalendarEventCreationService._internal();
  CalendarEventCreationService._internal();

  final _calendar = CalendarService.instance;

  // -----------------------------
  // BUILD A NEW EVENT MODEL
  // -----------------------------
  CalendarEventModel buildEvent({
    required String id,
    required String title,
    required DateTime start,
    required DateTime end,
    String? description,
    String? location,
    String? categoryId,
    String? colorHex,
    double emotionalLoad = 5,
    double fatigueLoad = 5,
    bool isAllDay = false,
  }) {
    return CalendarEventModel(
      id: id,
      title: title,
      description: description,
      start: start,
      end: end,
      location: location,
      categoryId: categoryId,
      colorHex: colorHex,
      emotionalLoad: emotionalLoad,
      fatigueLoad: fatigueLoad,
      isAllDay: isAllDay,
    );
  }

  // -----------------------------
  // CREATE EVENT WITH CONFLICT CHECK
  // -----------------------------
  Future<Map<String, dynamic>> createEventWithConflicts({
    required String id,
    required String title,
    required DateTime start,
    required DateTime end,
    String? description,
    String? location,
    String? categoryId,
    String? colorHex,
    double emotionalLoad = 5,
    double fatigueLoad = 5,
    bool isAllDay = false,
  }) async {
    final event = buildEvent(
      id: id,
      title: title,
      start: start,
      end: end,
      description: description,
      location: location,
      categoryId: categoryId,
      colorHex: colorHex,
      emotionalLoad: emotionalLoad,
      fatigueLoad: fatigueLoad,
      isAllDay: isAllDay,
    );

    final conflictResult =
        _calendar.detectConflictsForNewEvent(event);

    final hasConflicts = conflictResult["hasConflicts"] as bool;

    if (!hasConflicts) {
      await _calendar.addEvent(event);
      return {
        "success": true,
        "event": event,
        "conflicts": [],
        "summary": "Event created with no conflicts.",
      };
    }

    return {
      "success": false,
      "event": event,
      "conflicts": conflictResult["conflicts"],
      "summary": conflictResult["summary"],
      "suggestions": conflictResult["suggestions"],
    };
  }

  // -----------------------------
  // SUGGEST BEST TIME, THEN BUILD EVENT
  // -----------------------------
  Future<Map<String, dynamic>> suggestAndCreateEventInWeek({
    required String id,
    required String title,
    required DateTime weekStart,
    required Duration duration,
    String? description,
    String? location,
    String? categoryId,
    String? colorHex,
    double emotionalLoad = 5,
    double fatigueLoad = 5,
    bool isAllDay = false,
  }) async {
    final best = _calendar.bestTimeInWeek(
      weekStart: weekStart,
      duration: duration,
    );

    if (best["success"] != true) {
      return {
        "success": false,
        "reason": best["reason"],
      };
    }

    final DateTime start = best["start"] as DateTime;
    final DateTime end = best["end"] as DateTime;

    final event = buildEvent(
      id: id,
      title: title,
      start: start,
      end: end,
      description: description,
      location: location,
      categoryId: categoryId,
      colorHex: colorHex,
      emotionalLoad: emotionalLoad,
      fatigueLoad: fatigueLoad,
      isAllDay: isAllDay,
    );

    await _calendar.addEvent(event);

    return {
      "success": true,
      "event": event,
      "reason": best["reason"],
      "minutes": best["minutes"],
    };
  }
}
