import 'package:flutter/foundation.dart';

import 'task_facade.dart';
import 'analytics/task_insights_engine.dart';
import 'logic/task_suggestions_engine.dart';
import 'logic/task_scheduling_engine.dart';
import 'export/task_backup_service.dart';
import 'sync/task_sync_service.dart';

/// TaskLifecycleOrchestrator initializes and wires together:
/// - TaskFacade
/// - Insights Engine
/// - Suggestions Engine
/// - Scheduling Engine
/// - Backup Service
/// - Sync Service
///
/// This is the master controller for the entire Tasks subsystem.
class TaskLifecycleOrchestrator extends ChangeNotifier {
  // Singleton
  static final TaskLifecycleOrchestrator instance =
      TaskLifecycleOrchestrator._internal();
  TaskLifecycleOrchestrator._internal();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  // -----------------------------
  // INITIALIZE EVERYTHING
  // -----------------------------
  Future<void> initialize() async {
    if (_initialized) return;

    // 1. Facade (core data layer)
    TaskFacade.instance;

    // 2. Insights Engine
    TaskInsightsEngine.instance;

    // 3. Suggestions Engine
    TaskSuggestionsEngine.instance;

    // 4. Scheduling Engine
    TaskSchedulingEngine.instance;

    // 5. Backup Service
    await TaskBackupService.instance.initialize();

    // 6. Sync Service
    TaskSyncService.instance.initialize();

    _initialized = true;
    notifyListeners();
  }

  // -----------------------------
  // DISPOSE EVERYTHING
  // -----------------------------
  void disposeAll() {
    TaskBackupService.instance.dispose();
    TaskSyncService.instance.dispose();
  }
}
