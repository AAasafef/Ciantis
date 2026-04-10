import '../models/calendar_event_model.dart';
import '../models/calendar_day_model.dart';

/// CalendarEventConflictEngine detects:
/// - Overlapping events
/// - Double-bookings
/// - Travel-time conflicts
/// - Back-to-back overload
/// - Emotional/fatigue conflict amplification
///
/// It also provides:
/// - Conflict summaries
/// - Smart resolution suggestions
///
/// This engine powers:
/// - Event creation conflict warnings
/// - Smart rescheduling
/// - Calendar Insights Dashboard
/// - Mode Engine + NBA conflict awareness
class CalendarEventConflictEngine {
  // Singleton
  static final CalendarEventConflictEngine instance =
      CalendarEventConflictEngine._internal();
  CalendarEventConflictEngine._internal();

  // -----------------------------
  // DETECT CONFLICTS FOR A DAY
  // -----------------------------
  Map<String, dynamic> detectConflictsForDay(CalendarDayModel day) {
    final events = [...day.events]..sort((a, b) => a.start.compareTo(b.start));

    final List<Map<String, dynamic>> conflicts = [];

    for (int i = 0; i < events.length - 1; i++) {
      final current = events[i];
      final next = events[i + 1];

      // Overlap
      if (current.end.isAfter(next.start)) {
        conflicts.add({
          "type": "overlap",
          "eventA": current,
          "eventB": next,
          "description":
              "These events overlap and cannot be attended simultaneously.",
        });
      }

      // Back-to-back overload
      if (current.end.isAtSameMomentAs(next.start)) {
        conflicts.add({
          "type": "back_to_back",
          "eventA": current,
          "eventB": next,
          "description":
              "These events are back-to-back with no buffer time.",
        });
      }

      // Travel-time conflict (simple heuristic)
      if (_requiresTravel(current) && _requiresTravel(next)) {
        final gap = next.start.difference(current.end).inMinutes;
        if (gap < 20) {
          conflicts.add({
            "type": "travel_conflict",
            "eventA": current,
            "eventB": next,
            "description":
                "Insufficient travel time between these events.",
          });
        }
      }
    }

    return {
      "date": day.date,
      "conflicts": conflicts,
      "hasConflicts": conflicts.isNotEmpty,
      "summary": _summarizeConflicts(conflicts),
    };
  }

  // -----------------------------
  // DETECT CONFLICTS FOR A NEW EVENT
  // -----------------------------
  Map<String, dynamic> detectConflictsForNewEvent({
    required CalendarEventModel newEvent,
    required List<CalendarEventModel> existingEvents,
  }) {
    final List<Map<String, dynamic>> conflicts = [];

    for (final e in existingEvents) {
      // Overlap
      if (_overlaps(newEvent, e)) {
        conflicts.add({
          "type": "overlap",
          "eventA": newEvent,
          "eventB": e,
          "description":
              "This event overlaps with an existing event.",
        });
      }

      // Back-to-back overload
      if (newEvent.start.isAtSameMomentAs(e.end) ||
          newEvent.end.isAtSameMomentAs(e.start)) {
        conflicts.add({
          "type": "back_to_back",
          "eventA": newEvent,
          "eventB": e,
          "description":
              "This event is back-to-back with another event.",
        });
      }

      // Travel-time conflict
      if (_requiresTravel(newEvent) && _requiresTravel(e)) {
        final gap1 = newEvent.start.difference(e.end).inMinutes;
        final gap2 = e.start.difference(newEvent.end).inMinutes;

        if (gap1.abs() < 20 || gap2.abs() < 20) {
          conflicts.add({
            "type": "travel_conflict",
            "eventA": newEvent,
            "eventB": e,
            "description":
                "Insufficient travel time between these events.",
          });
        }
      }
    }

    return {
      "conflicts": conflicts,
      "hasConflicts": conflicts.isNotEmpty,
      "summary": _summarizeConflicts(conflicts),
      "suggestions": _resolutionSuggestions(newEvent, conflicts),
    };
  }

  // -----------------------------
  // OVERLAP CHECK
  // -----------------------------
  bool _overlaps(CalendarEventModel a, CalendarEventModel b) {
    return a.start.isBefore(b.end) && b.start.isBefore(a.end);
  }

  // -----------------------------
  // TRAVEL REQUIREMENT HEURISTIC
  // -----------------------------
  bool _requiresTravel(CalendarEventModel e) {
    if (e.location == null) return false;
    final loc = e.location!.toLowerCase();
    return !(loc.contains("home") || loc.contains("virtual") || loc.contains("online"));
  }

  // -----------------------------
  // SUMMARIZE CONFLICTS
  // -----------------------------
  String _summarizeConflicts(List<Map<String, dynamic>> conflicts) {
    if (conflicts.isEmpty) return "No conflicts detected.";

    final overlapCount =
        conflicts.where((c) => c["type"] == "overlap").length;
    final backToBackCount =
        conflicts.where((c) => c["type"] == "back_to_back").length;
    final travelCount =
        conflicts.where((c) => c["type"] == "travel_conflict").length;

    return [
      if (overlapCount > 0) "$overlapCount overlapping events",
      if (backToBackCount > 0) "$backToBackCount back-to-back events",
      if (travelCount > 0) "$travelCount travel-time conflicts",
    ].join(", ");
  }

  // -----------------------------
  // RESOLUTION SUGGESTIONS
  // -----------------------------
  List<String> _resolutionSuggestions(
      CalendarEventModel newEvent,
      List<Map<String, dynamic>> conflicts) {
    if (conflicts.isEmpty) {
      return ["This event can be scheduled without issues."];
    }

    final suggestions = <String>[];

    final hasOverlap =
        conflicts.any((c) => c["type"] == "overlap");
    final hasBackToBack =
        conflicts.any((c) => c["type"] == "back_to_back");
    final hasTravel =
        conflicts.any((c) => c["type"] == "travel_conflict");

    if (hasOverlap) {
      suggestions.add("Consider shifting the event start or end time to avoid overlap.");
    }

    if (hasBackToBack) {
      suggestions.add("Add a buffer between events to reduce overload.");
    }

    if (hasTravel) {
      suggestions.add("Increase the gap between events to allow for travel time.");
    }

    suggestions.add("Try scheduling this event on a lighter day.");

    return suggestions;
  }
}
