import 'package:flutter/foundation.dart';

import 'notification_delivery_service.dart';
import 'notification_plugin_adapter.dart';
import 'notification_channels.dart';

/// NotificationDispatcher is the final bridge:
/// - DeliveryService decides *how* a notification should behave
/// - PluginAdapter actually sends it
///
/// This class simply forwards the final decision to the plugin.
class NotificationDispatcher {
  // Singleton
  static final NotificationDispatcher instance =
      NotificationDispatcher._internal();
  NotificationDispatcher._internal();

  final _delivery = NotificationDeliveryService.instance;
  final _plugin = NotificationPluginAdapter.instance;

  // -----------------------------
  // PUBLIC API
  // -----------------------------
  Future<void> send({
    required String id,
    required String title,
    required String body,
    required String type, // "message", "task", "event", etc.
    DateTime? scheduledAt,
  }) async {
    // Delivery service decides behavior (allow, soften, delay, batch)
    await _delivery.requestNotification(
      id: id,
      title: title,
      body: body,
      type: type,
      scheduledAt: scheduledAt,
    );
  }

  // -----------------------------
  // INTERNAL HOOK (CALLED BY DELIVERY SERVICE)
  // -----------------------------
  Future<void> deliverNow({
    required String id,
    required String channelId,
    required String title,
    required String body,
    bool soften = false,
    DateTime? scheduledAt,
  }) async {
    if (scheduledAt != null) {
      await _plugin.schedule(
        id: id,
        channelId: channelId,
        title: title,
        body: body,
        scheduledAt: scheduledAt,
        soften: soften,
      );
    } else {
      await _plugin.showNow(
        id: id,
        channelId: channelId,
        title: title,
        body: body,
        soften: soften,
      );
    }
  }
}
