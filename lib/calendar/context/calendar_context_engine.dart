import 'package:flutter/foundation.dart';

import '../models/calendar_event.dart';

/// CalendarContextEngine analyzes the user's schedule at a given time
/// and produces a context object describing:
/// - Deep-work windows
/// - Recovery windows
/// - Overload blocks
/// - Free blocks
/// - Meeting blocks
/// - Heavy blocks
///
/// This is the layer the Mode Engine reads to understand
/// what the calendar *means*.
class CalendarContextEngine {
  // Singleton
  static final CalendarContextEngine instance =
      CalendarContextEngine._internal();
  CalendarContextEngine._internal();

  // -----------------------------
  // MAIN ENTRY
  // -----------------------------
  CalendarContext getContext({
    required DateTime now,
    required List<CalendarEvent> events,
  }) {
    final active = _getActiveEvent(now, events);
    final upcoming = _getUpcomingEvent(now, events);

    final isDeepWork = active?.type == CalendarEventType.deepWork;
    final isRecovery = active?.type == CalendarEventType.recovery;
    final isMeeting = active?.type == CalendarEventType.meeting;
    final isHeavy = active?.type == CalendarEventType.heavy;
    final isOverloaded = _isOverloaded(events, now);
    final isFree = active == null;

    return CalendarContext(
      isDeepWorkWindow: isDeepWork,
      isRecoveryWindow: isRecovery,
      isMeeting: isMeeting,
      isHeavyBlock: isHeavy,
      isOverloaded: isOverloaded,
      isFreeBlock: isFree,
      activeEvent: active,
      upcomingEvent: upcoming,
    );
  }

  // -----------------------------
  // ACTIVE EVENT
  // -----------------------------
  CalendarEvent? _getActiveEvent(DateTime now, List<CalendarEvent> events) {
    for (final e in events) {
      if (now.isAfter(e.start) && now.isBefore(e.end)) {
        return e;
      }
    }
    return null;
  }

  // -----------------------------
  // UPCOMING EVENT
  // -----------------------------
  CalendarEvent? _getUpcomingEvent(DateTime now, List<CalendarEvent> events) {
    final upcoming = events
        .where((e) => e.start.isAfter(now))
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));

    return upcoming.isNotEmpty ? upcoming.first : null;
  }

  // -----------------------------
  // OVERLOAD DETECTION
  // -----------------------------
  bool _isOverloaded(List<CalendarEvent> events, DateTime now) {
    // Count events in a 3-hour window
    final windowStart = now.subtract(const Duration(hours: 1));
    final windowEnd = now.add(const Duration(hours: 2));

    final count = events.where((e) {
      return e.start.isBefore(windowEnd) && e.end.isAfter(windowStart);
    }).length;

    return count >= 4; // threshold for overload
  }
}

// -----------------------------
// CONTEXT MODEL
// -----------------------------
@immutable
class CalendarContext {
  final bool isDeepWorkWindow;
  final bool isRecoveryWindow;
  final bool isMeeting;
  final bool isHeavyBlock;
  final bool isOverloaded;
  final bool isFreeBlock;

  final CalendarEvent? activeEvent;
  final CalendarEvent? upcomingEvent;

  const CalendarContext({
    required this.isDeepWorkWindow,
    required this.isRecoveryWindow,
    required this.isMeeting,
    required this.isHeavyBlock,
    required this.isOverloaded,
    required this.isFreeBlock,
    required this.activeEvent,
    required this.upcomingEvent,
  });
}
