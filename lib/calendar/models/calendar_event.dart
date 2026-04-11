import 'package:flutter/foundation.dart';

/// CalendarEvent represents a single block in the user's schedule.
///
/// It includes:
/// - Start/end times
/// - Event type (deep work, recovery, meeting, heavy, etc.)
/// - Metadata (title, notes, source)
/// - Flags (isFlexible, isImportant, isEnergyHeavy)
///
/// This model is used by:
/// - CalendarContextEngine
/// - CalendarModeHooks
/// - ModeEngine integrations
@immutable
class CalendarEvent {
  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final CalendarEventType type;

  final bool isFlexible;
  final bool isImportant;
  final bool isEnergyHeavy;

  final String? notes;
  final String? source; // e.g., "google", "apple", "manual"

  const CalendarEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.type,
    this.isFlexible = false,
    this.isImportant = false,
    this.isEnergyHeavy = false,
    this.notes,
    this.source,
  });

  Duration get duration => end.difference(start);

  bool get isShort => duration.inMinutes <= 30;
  bool get isLong => duration.inMinutes >= 90;

  bool overlaps(DateTime time) {
    return time.isAfter(start) && time.isBefore(end);
  }

  bool overlapsRange(DateTime a, DateTime b) {
    return start.isBefore(b) && end.isAfter(a);
  }
}

// -----------------------------
// EVENT TYPES
// -----------------------------
enum CalendarEventType {
  deepWork,
  recovery,
  meeting,
  heavy,
  light,
  personal,
  travel,
  sleep,
  focusBlock,
  breakBlock,
}
