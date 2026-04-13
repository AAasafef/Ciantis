import 'dart:async';
import 'developer_logger.dart';
import 'universal_tick.dart';

/// UniversalTickScheduler
/// -----------------------
/// Runs the Universal Tick on a fixed interval.
/// This is the heartbeat of Ciantis.
/// Everything updates from here.
class UniversalTickScheduler {
  static final UniversalTickScheduler instance =
      UniversalTickScheduler._internal();
  UniversalTickScheduler._internal();

  Timer? _timer;

  void start({required Duration interval}) {
    stop(); // ensure no duplicate timers

    DeveloperLogger.log(
      "UniversalTickScheduler started (interval = ${interval.inSeconds}s)"
    );

    _timer = Timer.periodic(interval, (_) {
      DeveloperLogger.log("UniversalTickScheduler fired → running tick");
      UniversalTick.instance.run();
    });
  }

  void stop() {
    if (_timer != null) {
      DeveloperLogger.log("UniversalTickScheduler stopped");
      _timer?.cancel();
      _timer = null;
    }
  }

  bool get isRunning => _timer != null;
}
