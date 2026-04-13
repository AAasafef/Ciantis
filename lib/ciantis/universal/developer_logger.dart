import 'developer_logs_screen.dart';

/// DeveloperLogger
/// ----------------
/// Central logging utility for Ciantis.
/// All logs go through here.
/// Logs are stored in DeveloperLogStore.
class DeveloperLogger {
  static bool _initialized = false;

  static void _init() {
    if (_initialized) return;
    _initialized = true;

    DeveloperLogStore.instance.add("DeveloperLogger initialized");
  }

  static void log(String message) {
    _init();
    DeveloperLogStore.instance.add(message);
  }
}
