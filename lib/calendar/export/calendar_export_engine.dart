import 'dart:convert';

import '../calendar_facade.dart';
import '../models/calendar_event.dart';

/// CalendarExportEngine provides export utilities:
/// - Export all events
/// - Export a date range
/// - JSON export
/// - CSV export
///
/// This is a backend utility with no UI.
class CalendarExportEngine {
  // Singleton
  static final CalendarExportEngine instance =
      CalendarExportEngine._internal();
  CalendarExportEngine._internal();

  final _facade = CalendarFacade.instance;

  // -----------------------------
  // EXPORT ALL EVENTS (JSON)
  // -----------------------------
  String exportAllAsJson() {
    final events = _facade.events;
    final list = events.map(_eventToMap).toList();
    return const JsonEncoder.withIndent('  ').convert(list);
  }

  // -----------------------------
  // EXPORT DATE RANGE (JSON)
  // -----------------------------
  String exportRangeAsJson(DateTime start, DateTime end) {
    final events = _facade.events.where((e) {
      return e.start.isAfter(start) && e.end.isBefore(end);
    }).toList();

    final list = events.map(_eventToMap).toList();
    return const JsonEncoder.withIndent('  ').convert(list);
  }

  // -----------------------------
  // EXPORT ALL EVENTS (CSV)
  // -----------------------------
  String exportAllAsCsv() {
    final events = _facade.events;
    return _toCsv(events);
  }

  // -----------------------------
  // EXPORT DATE RANGE (CSV)
  // -----------------------------
  String exportRangeAsCsv(DateTime start, DateTime end) {
    final events = _facade.events.where((e) {
      return e.start.isAfter(start) && e.end.isBefore(end);
    }).toList();

    return _toCsv(events);
  }

  // -----------------------------
  // EVENT → MAP
  // -----------------------------
  Map<String, dynamic> _eventToMap(CalendarEvent e) {
    return {
      "id": e.id,
      "title": e.title,
      "start": e.start.toIso8601String(),
      "end": e.end.toIso8601String(),
      "type": e.type.name,
      "isFlexible": e.isFlexible,
      "isImportant": e.isImportant,
      "isEnergyHeavy": e.isEnergyHeavy,
      "notes": e.notes,
      "source": e.source,
    };
  }

  // -----------------------------
  // CSV BUILDER
  // -----------------------------
  String _toCsv(List<CalendarEvent> events) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln(
      "id,title,start,end,type,isFlexible,isImportant,isEnergyHeavy,notes,source",
    );

    for (final e in events) {
      buffer.writeln([
        e.id,
        _escape(e.title),
        e.start.toIso8601String(),
        e.end.toIso8601String(),
        e.type.name,
        e.isFlexible,
        e.isImportant,
        e.isEnergyHeavy,
        _escape(e.notes ?? ""),
        e.source,
      ].join(","));
    }

    return buffer.toString();
  }

  // -----------------------------
  // ESCAPE CSV FIELDS
  // -----------------------------
  String _escape(String value) {
    if (value.contains(",") || value.contains("\"")) {
      return "\"${value.replaceAll("\"", "\"\"")}\"";
    }
    return value;
  }
}
