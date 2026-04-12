import '../ui/developer_logs_screen.dart';

/// DeveloperLogger
/// ----------------
/// A simple wrapper around DeveloperLogStore
/// so the rest of the system can log events easily.
///
/// Usage:
/// DeveloperLogger.log("Something happened");
class DeveloperLogger {
  static void log(String message) {
    DeveloperLogStore.instance.add(message);
  }
}
