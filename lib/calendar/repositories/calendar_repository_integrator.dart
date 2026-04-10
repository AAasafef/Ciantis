import 'dart:async';

import '../models/calendar_event_model.dart';
import 'calendar_repository.dart';
import '../storage/calendar_storage_adapter.dart';

/// CalendarRepositoryIntegrator connects:
/// - CalendarRepository
/// - CalendarStorageAdapter
///
/// It ensures:
/// - Events load on startup
/// - Events save automatically on change
/// - Repository stays in sync with storage
///
/// This is the glue layer that makes the calendar persistent.
class CalendarRepositoryIntegrator {
  // Singleton
  static final CalendarRepositoryIntegrator instance =
      CalendarRepositoryIntegrator._internal();
  CalendarRepositoryIntegrator._internal();

  final _repo = CalendarRepository.instance;
  final _storage = CalendarStorageAdapter.instance;

  StreamController<List<CalendarEventModel>> _eventStreamController =
      StreamController.broadcast();

  Stream<List<CalendarEventModel>> get eventStream =>
      _eventStreamController.stream;

  // -----------------------------
  // INITIALIZE (LOAD EVENTS)
  // -----------------------------
  Future<void> initialize() async {
    final loaded = await _storage.loadEvents();
    for (final e in loaded) {
      _repo.addEvent(e);
    }

    _emit();
  }

  // -----------------------------
  // ADD EVENT + SAVE
  // -----------------------------
  Future<void> addEvent(CalendarEventModel event) async {
    _repo.addEvent(event);
    await _save();
  }

  // -----------------------------
  // UPDATE EVENT + SAVE
  // -----------------------------
  Future<void> updateEvent(CalendarEventModel event) async {
    _repo.updateEvent(event);
    await _save();
  }

  // -----------------------------
  // DELETE EVENT + SAVE
  // -----------------------------
  Future<void> deleteEvent(String eventId) async {
    _repo.deleteEvent(eventId);
    await _save();
  }

  // -----------------------------
  // CLEAR ALL EVENTS
  // -----------------------------
  Future<void> clear() async {
    _repo.clear();
    await _storage.clear();
    _emit();
  }

  // -----------------------------
  // SAVE TO STORAGE
  // -----------------------------
  Future<void> _save() async {
    final events = _repo.getAllEvents();
    await _storage.saveEvents(events);
    _emit();
  }

  // -----------------------------
  // EMIT STREAM UPDATE
  // -----------------------------
  void _emit() {
    _eventStreamController.add(_repo.getAllEvents());
  }
}
