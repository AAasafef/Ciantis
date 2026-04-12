import 'dart:async';

import '../calendar_facade.dart';
import '../models/calendar_event.dart';
import '../analytics/calendar_insights_orchestrator.dart';

/// CalendarNotificationsEngine handles:
/// - Event reminders
/// - Pre-event prep notifications
/// - Energy-heavy day warnings
/// - Recovery encouragement
///
/// This is a logic-only layer. Real OS notifications will be added later.
class CalendarNotificationsEngine {
  // Singleton
  static final CalendarNotificationsEngine instance =
      CalendarNotificationsEngine._internal();
  CalendarNotificationsEngine._internal();

  final _facade = CalendarFacade.instance;

  Timer? _timer;

  // -----------------------------
  // INITIALIZE
  // -----------------------------
  void initialize() {
    // Check every minute
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _tick(),
    );
  }

  // -----------------------------
  // TICK LOOP
  // -----------------------------
  void _tick() {
    final now = DateTime.now();
    final events = _facade.events;

    for (final event in events) {
      _checkEventReminder(event, now);
      _checkPreEventPrep(event, now);
    }

    _checkEnergyLoad(now);
  }

  // -----------------------------
  // EVENT REMINDER
  // -----------------------------
  void _checkEventReminder(CalendarEvent event, DateTime now) {
    final diff = event.start.difference(now).inMinutes;

    if (diff == 10) {
      _notify("Upcoming Event", "${event.title} starts in 10 minutes.");
    }
    if (diff == 0) {
      _notify("Event Starting", "${event.title} is starting now.");
    }
  }

  // -----------------------------
  // PRE-EVENT PREP
  // -----------------------------
  void _checkPreEventPrep(CalendarEvent event, DateTime now) {
    if (!event.isEnergyHeavy) return;

    final diff = event.start.difference(now).inMinutes;

    if (diff == 30) {
      _notify(
        "Prep for Energy-Heavy Event",
        "Take a moment to breathe and prepare for ${event.title}.",
      );
    }
  }

  // -----------------------------
  // ENERGY LOAD CHECK
  // -----------------------------
  void _checkEnergyLoad(DateTime now) {
    final insights = CalendarInsightsOrchestrator.instance.latest;

    if (insights == null) return;

    if (insights.daily.energyLoad > 80) {
      _notify(
        "High Energy Load",
        "Today is intense. Pace yourself and hydrate.",
      );
    }

    if (insights.daily.recoveryScore > 70) {
      _notify(
        "Recovery Opportunity",
        "Your schedule has recovery space today. Use it well.",
      );
    }
  }

  // -----------------------------
  // NOTIFICATION (LOGIC ONLY)
  // -----------------------------
  void _notify(String title, String body) {
    // Placeholder for OS-level notifications
    // For now, just print
    // ignore: avoid_print
    print("[NOTIFY] $title — $body");
  }

  // -----------------------------
  // DISPOSE
  // -----------------------------
  void dispose() {
    _timer?.cancel();
  }
}
