import '../models/calendar_event_model.dart';

/// CalendarEventParsingEngine normalizes raw event data into
/// CalendarEventModel objects that the rest of the system can trust.
///
/// Responsibilities:
/// - Validate raw event data
/// - Normalize all-day events
/// - Expand multi-day events
/// - Clean titles/descriptions
/// - Auto-assign colors if missing
/// - Extract tags
/// - Detect duplicates
/// - Normalize external calendar sources
class CalendarEventParsingEngine {
  // Singleton
  static final CalendarEventParsingEngine instance =
      CalendarEventParsingEngine._internal();
  CalendarEventParsingEngine._internal();

  // -----------------------------
  // MAIN ENTRY: PARSE RAW EVENTS
  // -----------------------------
  List<CalendarEventModel> parseRawEvents(List<Map<String, dynamic>> raw) {
    final List<CalendarEventModel> parsed = [];

    for (final r in raw) {
      final event = _parseSingle(r);
      if (event == null) continue;

      // Expand multi-day events into daily segments
      final expanded = _expandMultiDay(event);
      parsed.addAll(expanded);
    }

    return _dedupe(parsed);
  }

  // -----------------------------
  // PARSE A SINGLE RAW EVENT
  // -----------------------------
  CalendarEventModel? _parseSingle(Map<String, dynamic> raw) {
    try {
      final id = raw["id"]?.toString() ?? _generateId();
      final title = (raw["title"] ?? "").toString().trim();
      if (title.isEmpty) return null;

      final start = DateTime.parse(raw["start"]);
      final end = DateTime.parse(raw["end"]);

      final allDay = raw["allDay"] == true;

      return CalendarEventModel(
        id: id,
        title: title,
        description: raw["description"]?.toString().trim(),
        start: start,
        end: end,
        allDay: allDay,
        location: raw["location"]?.toString(),
        calendarId: raw["calendarId"]?.toString(),
        tags: _extractTags(raw),
        color: _resolveColor(raw),
        isPinned: raw["isPinned"] == true,
        isBusy: raw["isBusy"] != false,
        isFromExternalSource: raw["externalSource"] != null,
        externalSource: raw["externalSource"]?.toString(),
        externalEventId: raw["externalEventId"]?.toString(),
        reminderOffset: _parseReminder(raw),
      );
    } catch (_) {
      return null;
    }
  }

  // -----------------------------
  // EXPAND MULTI-DAY EVENTS
  // -----------------------------
  List<CalendarEventModel> _expandMultiDay(CalendarEventModel event) {
    if (!event.isMultiDay) return [event];

    final List<CalendarEventModel> expanded = [];

    DateTime cursor = DateTime(event.start.year, event.start.month, event.start.day);
    final endDay = DateTime(event.end.year, event.end.month, event.end.day);

    while (!cursor.isAfter(endDay)) {
      final dayStart = DateTime(cursor.year, cursor.month, cursor.day, event.start.hour, event.start.minute);
      final dayEnd = DateTime(cursor.year, cursor.month, cursor.day, event.end.hour, event.end.minute);

      expanded.add(event.copyWith(
        start: dayStart,
        end: dayEnd,
      ));

      cursor = cursor.add(const Duration(days: 1));
    }

    return expanded;
  }

  // -----------------------------
  // TAG EXTRACTION
  // -----------------------------
  List<String> _extractTags(Map<String, dynamic> raw) {
    if (raw["tags"] is List) {
      return (raw["tags"] as List).map((e) => e.toString()).toList();
    }

    if (raw["title"] is String) {
      final title = raw["title"].toString().toLowerCase();
      final tags = <String>[];

      if (title.contains("exam")) tags.add("exam");
      if (title.contains("appointment")) tags.add("appointment");
      if (title.contains("meeting")) tags.add("meeting");
      if (title.contains("class")) tags.add("class");

      return tags;
    }

    return [];
  }

  // -----------------------------
  // COLOR RESOLUTION
  // -----------------------------
  int _resolveColor(Map<String, dynamic> raw) {
    if (raw["color"] is int) return raw["color"];

    // Default color palette
    return 0xFF4A90E2; // Calm blue
  }

  // -----------------------------
  // REMINDER PARSING
  // -----------------------------
  Duration? _parseReminder(Map<String, dynamic> raw) {
    if (raw["reminderMinutes"] is int) {
      return Duration(minutes: raw["reminderMinutes"]);
    }
    return null;
  }

  // -----------------------------
  // DEDUPLICATION
  // -----------------------------
  List<CalendarEventModel> _dedupe(List<CalendarEventModel> events) {
    final Map<String, CalendarEventModel> map = {};

    for (final e in events) {
      map[e.id] = e; // last write wins
    }

    return map.values.toList();
  }

  // -----------------------------
  // ID GENERATION
  // -----------------------------
  String _generateId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}
