import '../models/calendar_event_model.dart';
import '../models/calendar_day_model.dart';
import '../models/calendar_week_model.dart';
import '../models/calendar_month_model.dart';

import '../engines/calendar_event_parsing_engine.dart';
import '../engines/calendar_day_builder_engine.dart';
import '../engines/calendar_week_builder_engine.dart';
import '../engines/calendar_month_builder_engine.dart';

/// CalendarRepository is the central access point for:
/// - Event storage
/// - Day/Week/Month retrieval
/// - Adding/updating/deleting events
/// - Querying by date range
/// - Syncing with local/cloud storage (future)
///
/// This repository powers:
/// - Calendar UI
/// - Smart Scheduling
/// - Insights Dashboard
/// - Mode Engine + NBA
class CalendarRepository {
  // Singleton
  static final CalendarRepository instance =
      CalendarRepository._internal();
  CalendarRepository._internal();

  // In-memory event store (replace with database/cloud later)
  final List<CalendarEventModel> _events = [];

  final _parser = CalendarEventParsingEngine.instance;
  final _dayBuilder = CalendarDayBuilderEngine.instance;
  final _weekBuilder = CalendarWeekBuilderEngine.instance;
  final _monthBuilder = CalendarMonthBuilderEngine.instance;

  // -----------------------------
  // ADD EVENTS (RAW OR MODEL)
  // -----------------------------
  void addRawEvents(List<Map<String, dynamic>> raw) {
    final parsed = _parser.parseRawEvents(raw);
    _events.addAll(parsed);
  }

  void addEvent(CalendarEventModel event) {
    _events.add(event);
  }

  // -----------------------------
  // UPDATE EVENT
  // -----------------------------
  void updateEvent(CalendarEventModel updated) {
    final index = _events.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      _events[index] = updated;
    }
  }

  // -----------------------------
  // DELETE EVENT
  // -----------------------------
  void deleteEvent(String eventId) {
    _events.removeWhere((e) => e.id == eventId);
  }

  // -----------------------------
  // GET EVENTS FOR DATE
  // -----------------------------
  List<CalendarEventModel> eventsForDate(DateTime date) {
    return _events.where((e) => e.occursOnDate(date)).toList();
  }

  // -----------------------------
  // GET EVENTS IN RANGE
  // -----------------------------
  List<CalendarEventModel> eventsInRange(DateTime start, DateTime end) {
    return _events.where((e) {
      return e.start.isBefore(end) && e.end.isAfter(start);
    }).toList();
  }

  // -----------------------------
  // BUILD DAY
  // -----------------------------
  CalendarDayModel getDay(DateTime date) {
    return _dayBuilder.buildDay(
      date: date,
      allEvents: _events,
    );
  }

  // -----------------------------
  // BUILD WEEK
  // -----------------------------
  CalendarWeekModel getWeek(DateTime weekStart) {
    return _weekBuilder.buildWeek(
      weekStart: weekStart,
      allEvents: _events,
    );
  }

  // -----------------------------
  // BUILD MONTH
  // -----------------------------
  CalendarMonthModel getMonth(int year, int month) {
    return _monthBuilder.buildMonth(
      year: year,
      month: month,
      allEvents: _events,
    );
  }

  // -----------------------------
  // CLEAR ALL EVENTS (RESET)
  // -----------------------------
  void clear() {
    _events.clear();
  }

  // -----------------------------
  // GET ALL EVENTS
  // -----------------------------
  List<CalendarEventModel> getAllEvents() {
    return List.unmodifiable(_events);
  }
}
