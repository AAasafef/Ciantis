import 'package:flutter/foundation.dart';

import '../mode/engine/mode_engine.dart';
import '../mode/integrations/mode_calendar_behavior_modifiers.dart';

/// NotificationBehaviorEngine adjusts how notifications behave
/// based on:
/// - Active Mode
/// - Behavioral Modifiers
/// - Overload Protection
/// - Emotional/Fatigue load
/// - Deep-work or Recovery windows
///
/// This engine does NOT send notifications.
/// It decides:
/// - Should this notification be shown?
/// - Should it be softened?
/// - Should it be delayed?
/// - Should it be batched?
/// - Should it be suppressed?
///
/// The actual notification delivery layer reads these rules.
class NotificationBehaviorEngine {
  // Singleton
  static final NotificationBehaviorEngine instance =
      NotificationBehaviorEngine._internal();
  NotificationBehaviorEngine._internal();

  final _mode = ModeEngine.instance;
  final _modifiers = ModeCalendarBehaviorModifiers.instance;

  // -----------------------------
  // DECISION STRUCTURE
  // -----------------------------
  NotificationDecision evaluate({
    required DateTime now,
    required String notificationType, // "message", "task", "event", etc.
  }) {
    final activeMode = _mode.activeMode;
    final dailyModifiers = _modifiers.getDailyModifiers(now);

    bool allow = true;
    bool soften = false;
    bool delay = false;
    bool batch = false;

    // -----------------------------
    // OVERLOAD PROTECTION MODE
    // -----------------------------
    if (activeMode == "overload_protection") {
      allow = false;
      return NotificationDecision(
        allow: false,
        soften: false,
        delay: true,
        batch: true,
        reason: "Overload Protection Mode active",
      );
    }

    // -----------------------------
    // RECOVERY MODE
    // -----------------------------
    if (activeMode == "recovery") {
      soften = true;
      delay = true;
      batch = true;
    }

    // -----------------------------
    // FOCUS MODE
    // -----------------------------
    if (activeMode == "focus") {
      // Only allow essential notifications
      if (notificationType != "critical") {
        allow = false;
        delay = true;
      }
    }

    // -----------------------------
    // NIGHT GODDESS MODE
    // -----------------------------
    if (activeMode == "night_goddess") {
      soften = true;
      delay = true;
      batch = true;
    }

    // -----------------------------
    // BEHAVIORAL MODIFIERS
    // -----------------------------
    if (dailyModifiers.softenNotifications) soften = true;
    if (dailyModifiers.reduceInterruptions) {
      delay = true;
      batch = true;
    }

    return NotificationDecision(
      allow: allow,
      soften: soften,
      delay: delay,
      batch: batch,
      reason: "Mode: $activeMode",
    );
  }
}

// -----------------------------
// DATA CLASS
// -----------------------------
@immutable
class NotificationDecision {
  final bool allow;
  final bool soften;
  final bool delay;
  final bool batch;
  final String reason;

  const NotificationDecision({
    required this.allow,
    required this.soften,
    required this.delay,
    required this.batch,
    required this.reason,
  });
}
