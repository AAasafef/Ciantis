import 'package:flutter/foundation.dart';

import 'models/calendar_event.dart';
import 'context/calendar_context_engine.dart';

/// CalendarFacade is the unified access layer for all calendar data.
///
/// It:
/// - Stores the current list of events
/// - Provides listeners for updates
/// - Exposes context for any given time
/// - Acts as the bridge between external calendar sources and internal engines
///
/// This is the single source of truth for calendar state.
class CalendarFacade extends ChangeNotifier {
  // Singleton
  static final CalendarFacade instance = CalendarFacade._internal();
  CalendarFacade._internal();

  final List<CalendarEvent> _events = [];
  final _contextEngine = CalendarContextEngine.instance;

  // -----------------------------
  // PUBLIC API
  // -----------------------------
  List<CalendarEvent> get events => List.unmodifiable(_events);

  void setEvents(List<CalendarEvent> newEvents) {
    _events
      ..clear()
      ..addAll(newEvents);

    notifyListeners();
  }

  void addEvent(CalendarEvent event) {
    _events.add(event);
    notifyListeners();
  }

  void removeEvent(String id) {
    _events.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void updateEvent(CalendarEvent updated) {
    final index = _events.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      _events[index] = updated;
      notifyListeners();
    }
  }

  // -----------------------------
  // CONTEXT FOR A GIVEN TIME
  // -----------------------------
  CalendarContext getContextForTime(DateTime time) {
    return _contextEngine.getContext(
      now: time,
      events: _events,
    );
  }

  // -----------------------------
  // GET EVENTS FOR A DAY
  // -----------------------------
  List<CalendarEvent> getEventsForDay(DateTime day) {
    return _events.where((e) {
      return e.start.year == day.year &&
          e.start.month == day.month &&
          e.start.day == day.day;
    }).toList();
  }

  // -----------------------------
  // GET EVENTS FOR A WEEK
  // -----------------------------
  List<CalendarEvent> getEventsForWeek(DateTime weekStart) {
    final end = weekStart.add(const Duration(days: 7));
    return _events.where((e) {
      return e.start.isAfter(weekStart) && e.start.isBefore(end);
    }).toList();
  }

  // -----------------------------
  // GET EVENTS FOR A MONTH
  // -----------------------------
  List<CalendarEvent> getEventsForMonth(int year, int month) {
    return _events.where((e) {
      return e.start.year == year && e.start.month == month;
    }).toList();
  }

  // -----------------------------
  // REFRESH HOOK (OPTIONAL)
  // -----------------------------
  void refresh() {
    notifyListeners();
  }
}
