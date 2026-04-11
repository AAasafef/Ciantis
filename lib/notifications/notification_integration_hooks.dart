import 'package:flutter/foundation.dart';

import '../mode/engine/mode_engine.dart';
import 'notification_queue_manager.dart';

/// NotificationIntegrationHooks listens to ModeEngine changes
/// and triggers notification behavior updates.
///
/// This ensures:
/// - When mode changes → queue flush or suppression
/// - When overload protection activates → notifications pause
/// - When entering safe time → queued notifications release
class NotificationIntegrationHooks {
  // Singleton
  static final NotificationIntegrationHooks instance =
      NotificationIntegrationHooks._internal();
  NotificationIntegrationHooks._internal();

  final _mode = ModeEngine.instance;
  final _queue = NotificationQueueManager.instance;

  bool _initialized = false;

  // -----------------------------
  // INITIALIZE HOOKS
  // -----------------------------
  void initialize() {
    if (_initialized) return;
    _initialized = true;

    _mode.addListener(_onModeChanged);
  }

  // -----------------------------
  // MODE CHANGE HANDLER
  // -----------------------------
  void _onModeChanged() {
    final mode = _mode.activeMode;

    // Overload Protection → suppress everything
    if (mode == "overload_protection") {
      debugPrint("[Hooks] Overload Protection active → suppressing notifications");
      return;
    }

    // Focus Mode → do not flush
    if (mode == "focus") {
      debugPrint("[Hooks] Focus Mode active → holding notifications");
      return;
    }

    // Recovery Mode → hold notifications
    if (mode == "recovery") {
      debugPrint("[Hooks] Recovery Mode active → holding notifications");
      return;
    }

    // Night Goddess Mode → hold notifications
    if (mode == "night_goddess") {
      debugPrint("[Hooks] Night Goddess Mode active → holding notifications");
      return;
    }

    // Balanced / Calm / Light modes → safe to flush
    debugPrint("[Hooks] Safe mode detected → flushing queue");
    _queue.flush();
  }

  // -----------------------------
  // MANUAL TICK (OPTIONAL)
  // -----------------------------
  Future<void> tick() async {
    await _queue.tick();
  }
}
