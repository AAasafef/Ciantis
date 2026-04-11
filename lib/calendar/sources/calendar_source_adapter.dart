import 'package:flutter/foundation.dart';

import '../models/calendar_event.dart';

/// CalendarSourceAdapter is the abstraction layer for importing
/// calendar data from external sources:
/// - Google Calendar
/// - Apple Calendar
/// - Local device calendars
/// - Custom Ciantis calendars
///
/// This file defines:
/// - The interface for any calendar source
/// - The conversion logic → CalendarEvent
/// - A registry for multiple sources
///
/// Actual API integrations will plug into this interface.
class CalendarSourceAdapter {
  // Singleton
  static final CalendarSourceAdapter instance =
      CalendarSourceAdapter._internal();
  CalendarSourceAdapter._internal();

  final List<CalendarSource> _sources = [];

  // -----------------------------
  // REGISTER A SOURCE
  // -----------------------------
  void registerSource(CalendarSource source) {
    _sources.add(source);
  }

  // -----------------------------
  // LOAD EVENTS FROM ALL SOURCES
  // -----------------------------
  Future<List<CalendarEvent>> loadAllEvents() async {
    final List<CalendarEvent> all = [];

    for (final source in _sources) {
      final events = await source.loadEvents();
      all.addAll(events);
    }

    return all;
  }
}

// -----------------------------
// CALENDAR SOURCE INTERFACE
// -----------------------------
abstract class CalendarSource {
  /// Load events from this source and convert them
  /// into Ciantis CalendarEvent objects.
  Future<List<CalendarEvent>> loadEvents();
}

// -----------------------------
// GOOGLE CALENDAR SOURCE (SKELETON)
// -----------------------------
class GoogleCalendarSource implements CalendarSource {
  @override
  Future<List<CalendarEvent>> loadEvents() async {
    // TODO: Integrate Google Calendar API
    debugPrint("[GoogleCalendarSource] Loading events (stub)");
    return [];
  }
}

// -----------------------------
// APPLE CALENDAR SOURCE (SKELETON)
// -----------------------------
class AppleCalendarSource implements CalendarSource {
  @override
  Future<List<CalendarEvent>> loadEvents() async {
    // TODO: Integrate Apple Calendar API
    debugPrint("[AppleCalendarSource] Loading events (stub)");
    return [];
  }
}

// -----------------------------
// LOCAL DEVICE CALENDAR SOURCE (SKELETON)
// -----------------------------
class LocalDeviceCalendarSource implements CalendarSource {
  @override
  Future<List<CalendarEvent>> loadEvents() async {
    // TODO: Integrate device calendar APIs
    debugPrint("[LocalDeviceCalendarSource] Loading events (stub)");
    return [];
  }
}
