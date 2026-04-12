import 'package:flutter/foundation.dart';

import 'calendar_facade.dart';
import 'analytics/calendar_insights_orchestrator.dart';
import 'notifications/calendar_notifications_engine.dart';
import 'export/calendar_backup_service.dart';
import 'sync/calendar_sync_service.dart';

/// CalendarLifecycleOrchestrator initializes and wires together:
/// - CalendarFacade
/// - Insights Orchestrator
/// - Notifications Engine
/// - Backup Service
/// - Sync Service
///
/// This is the master controller for the entire Calendar subsystem.
class CalendarLifecycleOrchestrator extends ChangeNotifier {
  // Singleton
  static final CalendarLifecycleOrchestrator instance =
      CalendarLifecycleOrchestrator._internal();
  CalendarLifecycleOrchestrator._internal();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  // -----------------------------
  // INITIALIZE EVERYTHING
  // -----------------------------
  Future<void> initialize() async {
    if (_initialized) return;

    // 1. Facade (core data layer)
    CalendarFacade.instance.initialize();

    // 2. Insights Orchestrator
    CalendarInsightsOrchestrator.instance.initialize();

    // 3. Notifications Engine
    CalendarNotificationsEngine.instance.initialize();

    // 4. Backup Service
    CalendarBackupService.instance.initialize();

    // 5. Sync Service
    CalendarSyncService.instance.initialize();

    _initialized = true;
    notifyListeners();
  }

  // -----------------------------
  // DISPOSE EVERYTHING
  // -----------------------------
  void disposeAll() {
    CalendarNotificationsEngine.instance.dispose();
    CalendarBackupService.instance.dispose();
    CalendarSyncService.instance.dispose();
  }
}
