import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/calendar_event_model.dart';

/// CalendarStorageAdapter handles:
/// - Saving events to local storage
/// - Loading events on startup
/// - Serializing/deserializing CalendarEventModel
///
/// This is the persistence backend for CalendarRepository.
/// It keeps storage logic separate from business logic.
class CalendarStorageAdapter {
  // Singleton
  static final CalendarStorageAdapter instance =
      CalendarStorageAdapter._internal();
  CalendarStorageAdapter._internal();

  static const String _eventsKey = "ciantis_calendar_events";

  // -----------------------------
  // SAVE EVENTS
  // -----------------------------
  Future<void> saveEvents(List<CalendarEventModel> events) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = events.map((e) => e.toJson()).toList();
    final encoded = jsonEncode(jsonList);

    await prefs.setString(_eventsKey, encoded);
  }

  // -----------------------------
  // LOAD EVENTS
  // -----------------------------
  Future<List<CalendarEventModel>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(_eventsKey);
    if (raw == null) return [];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => CalendarEventModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // -----------------------------
  // CLEAR EVENTS
  // -----------------------------
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_eventsKey);
  }
}
