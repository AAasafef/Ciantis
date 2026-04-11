import 'package:flutter/foundation.dart';

import '../calendar_facade.dart';
import '../models/calendar_event.dart';
import '../sources/calendar_source_adapter.dart';

/// CalendarSyncOrchestrator coordinates:
/// - Loading events from all sources
/// - Merging and deduplicating
/// - Normalizing metadata
/// - Updating the CalendarFacade
/// - Running periodic sync cycles
///
/// This ensures Ciantis always has an accurate, unified schedule.
class CalendarSyncOrchestrator {
  // Singleton
  static final CalendarSyncOrchestrator instance =
      CalendarSyncOrchestrator._internal();
  CalendarSyncOrchestrator._internal();

  final _facade = CalendarFacade.instance;
  final _sources = CalendarSourceAdapter.instance;

  bool _isSyncing = false;

  // -----------------------------
  // PUBLIC SYNC METHOD
  // -----------------------------
  Future<void> sync() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final rawEvents = await _sources.loadAllEvents();
      final merged = _merge(rawEvents);
      final normalized = _normalize(merged);

      _facade.setEvents(normalized);

      debugPrint("[CalendarSync] Sync complete: ${normalized.length} events");
    } catch (e) {
      debugPrint("[CalendarSync] Error: $e");
    } finally {
      _isSyncing = false;
    }
  }

  // -----------------------------
  // MERGE LOGIC
  // -----------------------------
  List<CalendarEvent> _merge(List<CalendarEvent> events) {
    final Map<String, CalendarEvent> map = {};

    for (final e in events) {
      // If event ID already exists, keep the one with the longest duration
      if (map.containsKey(e.id)) {
        final existing = map[e.id]!;
        if (e.duration > existing.duration) {
          map[e.id] = e;
        }
      } else {
        map[e.id] = e;
      }
    }

    return map.values.toList();
  }

  // -----------------------------
  // NORMALIZATION LOGIC
  // -----------------------------
  List<CalendarEvent> _normalize(List<CalendarEvent> events) {
    return events.map((e) {
      // Normalize metadata (future expansion)
      return CalendarEvent(
        id: e.id,
        title: e.title.trim(),
        start: e.start,
        end: e.end,
        type: e.type,
        isFlexible: e.isFlexible,
        isImportant: e.isImportant,
        isEnergyHeavy: e.isEnergyHeavy,
        notes: e.notes?.trim(),
        source: e.source,
      );
    }).toList();
  }

  // -----------------------------
  // PERIODIC SYNC (CALL FROM APP)
  // -----------------------------
  Future<void> tick() async {
    await sync();
  }
}
