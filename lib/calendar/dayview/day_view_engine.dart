import 'package:flutter/foundation.dart';

import '../models/calendar_event.dart';

/// DayViewEngine transforms raw calendar events into a
/// UI-friendly structure for the Day View screen.
///
/// It:
/// - Sorts events chronologically
/// - Detects gaps between events
/// - Marks heavy / deep-work / recovery blocks
/// - Produces a clean timeline model
class DayViewEngine {
  // Singleton
  static final DayViewEngine instance = DayViewEngine._internal();
  DayViewEngine._internal();

  // -----------------------------
  // MAIN ENTRY
  // -----------------------------
  DayViewModel buildDayView({
    required DateTime day,
    required List<CalendarEvent> events,
  }) {
    final dayEvents = events.where((e) {
      return e.start.year == day.year &&
          e.start.month == day.month &&
          e.start.day == day.day;
    }).toList()
      ..sort((a, b) => a.start.compareTo(b.start));

    final blocks = <DayBlock>[];

    for (int i = 0; i < dayEvents.length; i++) {
      final e = dayEvents[i];

      // Add event block
      blocks.add(
        DayBlock(
          type: DayBlockType.event,
          event: e,
          start: e.start,
          end: e.end,
        ),
      );

      // Add gap block (if next event exists)
      if (i < dayEvents.length - 1) {
        final next = dayEvents[i + 1];
        if (e.end.isBefore(next.start)) {
          blocks.add(
            DayBlock(
              type: DayBlockType.gap,
              event: null,
              start: e.end,
              end: next.start,
            ),
          );
        }
      }
    }

    return DayViewModel(
      day: day,
      blocks: blocks,
    );
  }
}

// -----------------------------
// DAY VIEW MODEL
// -----------------------------
@immutable
class DayViewModel {
  final DateTime day;
  final List<DayBlock> blocks;

  const DayViewModel({
    required this.day,
    required this.blocks,
  });
}

// -----------------------------
// DAY BLOCK
// -----------------------------
@immutable
class DayBlock {
  final DayBlockType type;
  final CalendarEvent? event;
  final DateTime start;
  final DateTime end;

  const DayBlock({
    required this.type,
    required this.event,
    required this.start,
    required this.end,
  });

  Duration get duration => end.difference(start);
}

// -----------------------------
// BLOCK TYPES
// -----------------------------
enum DayBlockType {
  event,
  gap,
}
