import 'dart:async';
import 'package:flutter/foundation.dart';

import 'calendar_sync_orchestrator.dart';

/// CalendarSyncScheduler runs periodic sync cycles and triggers
/// background refreshes when the app resumes or wakes.
///
/// This ensures Ciantis always has fresh calendar data without
/// requiring manual refresh.
class CalendarSyncScheduler {
  // Singleton
  static final CalendarSyncScheduler instance =
      CalendarSyncScheduler._internal();
  CalendarSyncScheduler._internal();

  final _orchestrator = CalendarSyncOrchestrator.instance;

  Timer? _timer;
  bool _initialized = false;

  // -----------------------------
  // INITIALIZE SCHEDULER
  // -----------------------------
  void initialize() {
    if (_initialized) return;
    _initialized = true;

    // Run immediately on startup
    _orchestrator.sync();

    // Start periodic timer
    _timer = Timer.periodic(
      const Duration(minutes: 15),
      (_) => _orchestrator.sync(),
    );

    debugPrint("[CalendarSyncScheduler] Initialized");
  }

  // -----------------------------
  // MANUAL TRIGGER (APP RESUME)
  // -----------------------------
  Future<void> onAppResume() async {
    debugPrint("[CalendarSyncScheduler] App resumed → syncing");
    await _orchestrator.sync();
  }

  // -----------------------------
  // MANUAL TRIGGER (BACKGROUND WAKE)
  // -----------------------------
  Future<void> onBackgroundWake() async {
    debugPrint("[CalendarSyncScheduler] Background wake → syncing");
    await _orchestrator.sync();
  }

  // -----------------------------
  // DISPOSE
  // -----------------------------
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
