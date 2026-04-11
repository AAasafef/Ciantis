import 'package:flutter/foundation.dart';

import '../mode/engine/mode_engine.dart';
import 'notification_dispatcher.dart';
import 'notification_behavior_engine.dart';

/// NotificationQueueManager handles:
/// - Smart batching
/// - Safe-time release
/// - Automatic flush triggers
///
/// This is the brain that decides *when* queued notifications
/// should be released.
class NotificationQueueManager {
  // Singleton
  static final NotificationQueueManager instance =
      NotificationQueueManager._internal();
  NotificationQueueManager._internal();

  final _dispatcher = NotificationDispatcher.instance;
  final _behavior = NotificationBehaviorEngine.instance;
  final _mode = ModeEngine.instance;

  final List<_QueuedNotification> _queue = [];

  // -----------------------------
  // ADD TO QUEUE
  // -----------------------------
  void enqueue({
    required String id,
    required String channelId,
    required String title,
    required String body,
    required String type,
  }) {
    _queue.add(
      _QueuedNotification(
        id: id,
        channelId: channelId,
        title: title,
        body: body,
        type: type,
        createdAt: DateTime.now(),
      ),
    );
  }

  // -----------------------------
  // SAFE-TIME CHECK
  // -----------------------------
  bool _isSafeTime(DateTime now) {
    final active = _mode.activeMode;

    // Never release during overload protection
    if (active == "overload_protection") return false;

    // Avoid deep-work windows
    if (active == "focus") return false;

    // Avoid recovery windows
    if (active == "recovery") return false;

    // Night Goddess Mode → gentle only
    if (active == "night_goddess") return false;

    return true;
  }

  // -----------------------------
  // FLUSH QUEUE
  // -----------------------------
  Future<void> flush() async {
    if (_queue.isEmpty) return;

    final now = DateTime.now();
    if (!_isSafeTime(now)) return;

    final pending = List<_QueuedNotification>.from(_queue);
    _queue.clear();

    for (final n in pending) {
      final decision = _behavior.evaluate(
        now: now,
        notificationType: n.type,
      );

      if (!decision.allow) {
        // Still not allowed → keep suppressed
        continue;
      }

      await _dispatcher.deliverNow(
        id: n.id,
        channelId: n.channelId,
        title: n.title,
        body: n.body,
        soften: decision.soften,
        scheduledAt: null,
      );
    }
  }

  // -----------------------------
  // PERIODIC CHECK
  // (Call this from app lifecycle or timer)
  // -----------------------------
  Future<void> tick() async {
    await flush();
  }
}

// -----------------------------
// INTERNAL MODEL
// -----------------------------
class _QueuedNotification {
  final String id;
  final String channelId;
  final String title;
  final String body;
  final String type;
  final DateTime createdAt;

  _QueuedNotification({
    required this.id,
    required this.channelId,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
  });
}
