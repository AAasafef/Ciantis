import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_channels.dart';

/// NotificationPluginAdapter is a thin wrapper around
/// flutter_local_notifications.
///
/// It:
/// - Initializes channels
/// - Maps our profiles → platform channels
/// - Exposes simple show/schedule methods
class NotificationPluginAdapter {
  // Singleton
  static final NotificationPluginAdapter instance =
      NotificationPluginAdapter._internal();
  NotificationPluginAdapter._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(initSettings);
    await _setupChannels();

    _initialized = true;
  }

  // -----------------------------
  // CHANNEL SETUP
  // -----------------------------
  Future<void> _setupChannels() async {
    final channels = NotificationChannels.instance.channels.values;

    for (final profile in channels) {
      final androidChannel = AndroidNotificationChannel(
        profile.id,
        profile.name,
        description: 'Ciantis ${profile.name}',
        importance: _mapPriority(profile.priority),
        playSound: profile.sound != NotificationSound.none,
        enableVibration: profile.vibration != NotificationVibration.none,
      );

      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);
    }
  }

  // -----------------------------
  // SHOW NOW
  // -----------------------------
  Future<void> showNow({
    required String id,
    required String channelId,
    required String title,
    required String body,
    bool soften = false,
  }) async {
    await initialize();

    final profile =
        NotificationChannels.instance.getProfile(channelId);

    final androidDetails = AndroidNotificationDetails(
      profile.id,
      profile.name,
      channelDescription: 'Ciantis ${profile.name}',
      importance: _mapPriority(
        soften ? NotificationPriority.low : profile.priority,
      ),
      priority: _mapAndroidPriority(
        soften ? NotificationPriority.low : profile.priority,
      ),
      playSound: profile.sound != NotificationSound.none && !soften,
      enableVibration:
          profile.vibration != NotificationVibration.none && !soften,
    );

    const iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id.hashCode,
      title,
      body,
      details,
    );
  }

  // -----------------------------
  // SCHEDULE
  // -----------------------------
  Future<void> schedule({
    required String id,
    required String channelId,
    required String title,
    required String body,
    required DateTime scheduledAt,
    bool soften = false,
  }) async {
    await initialize();

    final profile =
        NotificationChannels.instance.getProfile(channelId);

    final androidDetails = AndroidNotificationDetails(
      profile.id,
      profile.name,
      channelDescription: 'Ciantis ${profile.name}',
      importance: _mapPriority(
        soften ? NotificationPriority.low : profile.priority,
      ),
      priority: _mapAndroidPriority(
        soften ? NotificationPriority.low : profile.priority,
      ),
      playSound: profile.sound != NotificationSound.none && !soften,
      enableVibration:
          profile.vibration != NotificationVibration.none && !soften,
    );

    const iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      id.hashCode,
      title,
      body,
      scheduledAt.toLocal(),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  // -----------------------------
  // MAPPERS
  // -----------------------------
  Importance _mapPriority(NotificationPriority p) {
    switch (p) {
      case NotificationPriority.high:
        return Importance.max;
      case NotificationPriority.medium:
        return Importance.defaultImportance;
      case NotificationPriority.low:
        return Importance.low;
    }
  }

  Priority _mapAndroidPriority(NotificationPriority p) {
    switch (p) {
      case NotificationPriority.high:
        return Priority.high;
      case NotificationPriority.medium:
        return Priority.defaultPriority;
      case NotificationPriority.low:
        return Priority.low;
    }
  }
}
