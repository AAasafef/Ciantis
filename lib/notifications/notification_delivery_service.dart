import 'package:flutter/foundation.dart';

import 'notification_behavior_engine.dart';

/// NotificationDeliveryService is responsible for:
/// - Consulting NotificationBehaviorEngine
/// - Deciding whether to show, soften, delay, or batch
/// - Calling the underlying notification plugin (to be wired later)
///
/// This is the bridge between:
/// - Intelligence (behavior engine)
/// - Actual delivery (local/remote notifications)
class NotificationDeliveryService {
  // Singleton
  static final NotificationDeliveryService instance =
      NotificationDeliveryService._internal();
  NotificationDeliveryService._internal();

  final _behavior = NotificationBehaviorEngine.instance;

  // Simple in-memory batch queue for now.
  final List<_PendingNotification> _batchQueue = [];

  // -----------------------------
  // PUBLIC API: REQUEST NOTIFICATION
  // -----------------------------
  Future<void> requestNotification({
    required String id,
    required String title,
    required String body,
    required String type, // "message", "task", "event", "critical", etc.
    DateTime? scheduledAt,
  }) async {
    final now = DateTime.now();
    final decision = _behavior.evaluate(
      now: now,
      notificationType: type,
    );

    if (!decision.allow) {
      if (decision.delay || decision.batch) {
        // Store for later if batching/delaying
        _batchQueue.add(
          _PendingNotification(
            id: id,
            title: title,
            body: body,
            type: type,
            createdAt: now,
          ),
        );
      }
      return;
    }

    if (decision.batch) {
      _batchQueue.add(
        _PendingNotification(
          id: id,
          title: title,
          body: body,
          type: type,
          createdAt: now,
        ),
      );
      return;
    }

    if (decision.delay && scheduledAt == null) {
      // Simple delay strategy: push it 15 minutes later.
      final delayedTime = now.add(const Duration(minutes: 15));
      await _sendNotification(
        id: id,
        title: title,
        body: body,
        scheduledAt: delayedTime,
        soften: decision.soften,
      );
      return;
    }

    await _sendNotification(
      id: id,
      title: title,
      body: body,
      scheduledAt: scheduledAt,
      soften: decision.soften,
    );
  }

  // -----------------------------
  // FLUSH BATCHED NOTIFICATIONS
  // (e.g., called at safe times)
  // -----------------------------
  Future<void> flushBatch() async {
    if (_batchQueue.isEmpty) return;

    final now = DateTime.now();
    final pending = List<_PendingNotification>.from(_batchQueue);
    _batchQueue.clear();

    for (final n in pending) {
      final decision = _behavior.evaluate(
        now: now,
        notificationType: n.type,
      );

      if (!decision.allow) {
        // Still not allowed → keep suppressed.
        continue;
      }

      await _sendNotification(
        id: n.id,
        title: n.title,
        body: n.body,
        scheduledAt: null,
        soften: decision.soften,
      );
    }
  }

  // -----------------------------
  // UNDERLYING SEND (TO BE WIRED)
  // -----------------------------
  Future<void> _sendNotification({
    required String id,
    required String title,
    required String body,
    DateTime? scheduledAt,
    required bool soften,
  }) async {
    // TODO: Wire this to your actual notification plugin:
    // - flutter_local_notifications
    // - Firebase Cloud Messaging
    // - OneSignal
    //
    // For now, this is just a placeholder hook.

    // Example of how "soften" might be interpreted:
    // - Use lower priority channel
    // - No sound / gentle sound
    // - No vibration

    debugPrint(
      "[NotificationDeliveryService] SEND → "
      "id=$id, title=$title, soften=$soften, scheduledAt=$scheduledAt",
    );
  }
}

// -----------------------------
// INTERNAL PENDING MODEL
// -----------------------------
class _PendingNotification {
  final String id;
  final String title;
  final String body;
  final String type;
  final DateTime createdAt;

  _PendingNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
  });
}
