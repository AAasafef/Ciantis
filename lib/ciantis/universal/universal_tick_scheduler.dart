import 'dart:async';

import 'universal_notifications_engine.dart';

/// UniversalTickScheduler
/// -----------------------
/// Runs the universal tick every X minutes.
/// This keeps Ciantis alive:
/// - Updates mode
/// - Sends reminders
/// - Sends mode-change notifications
/// - Updates context time
///
/// This is the heartbeat of the Life OS.
class UniversalTickScheduler {
  // Singleton
  static final UniversalTickScheduler instance =
      UniversalTickScheduler._internal();
  UniversalTickScheduler._internal();

  Timer? _timer;

  // -----------------------------
  // START SCHEDULER
  // -----------------------------
  void start({Duration interval = const Duration(minutes: 5)}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) {
      UniversalNotificationsEngine.instance.tick();
    });
  }

  // -----------------------------
  // STOP SCHEDULER
  // -----------------------------
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  // -----------------------------
  // MANUAL TICK (for debugging)
  // -----------------------------
  void tick() {
    UniversalNotificationsEngine.instance.tick();
  }
}
