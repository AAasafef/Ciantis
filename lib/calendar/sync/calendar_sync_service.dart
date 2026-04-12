import 'dart:async';

import '../calendar_facade.dart';
import '../models/calendar_event.dart';

/// CalendarSyncService is a future-ready sync abstraction.
///
/// It currently:
/// - Tracks changes
/// - Provides mock sync
/// - Defines hooks for real providers
///
/// Later, it can sync with:
/// - iCloud
/// - Google Calendar
/// - Ciantis Cloud
/// - Encrypted local network sync
class CalendarSyncService {
  // Singleton
  static final CalendarSyncService instance =
      CalendarSyncService._internal();
  CalendarSyncService._internal();

  final _facade = CalendarFacade.instance;

  final _changeController = StreamController<CalendarEvent>.broadcast();
  Stream<CalendarEvent> get changes => _changeController.stream;

  // -----------------------------
  // INITIALIZE
  // -----------------------------
  void initialize() {
    // Listen for event changes from the facade
    _facade.onEventChanged = (event) {
      _changeController.add(event);
      _mockSync(event);
    };
  }

  // -----------------------------
  // MOCK SYNC (LOCAL ONLY)
  // -----------------------------
  Future<void> _mockSync(CalendarEvent event) async {
    // Pretend to sync to cloud
    await Future.delayed(const Duration(milliseconds: 150));
    // No-op for now
  }

  // -----------------------------
  // FULL SYNC (FUTURE)
  // -----------------------------
  Future<void> syncAll() async {
    // Placeholder for real sync logic
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // -----------------------------
  // CONFLICT RESOLUTION (FUTURE)
  // -----------------------------
  CalendarEvent resolveConflict(CalendarEvent local, CalendarEvent remote) {
    // Placeholder: prefer remote for now
    return remote;
  }

  // -----------------------------
  // DISPOSE
  // -----------------------------
  void dispose() {
    _changeController.close();
  }
}
