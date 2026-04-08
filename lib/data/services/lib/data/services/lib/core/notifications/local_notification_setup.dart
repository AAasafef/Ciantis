import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class LocalNotificationSetup {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // -----------------------------
  // INITIALIZE
  // -----------------------------
  static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    await _requestPermissions();
  }

  // -----------------------------
  // REQUEST PERMISSIONS
  // -----------------------------
  static Future<void> _requestPermissions() async {
    // iOS
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Android 13+ runtime permission
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // -----------------------------
  // ON NOTIFICATION TAP
  // -----------------------------
  static void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;

    // You can route to a screen based on payload if needed.
    debugPrint("Notification tapped: $payload");
  }

  // -----------------------------
  // ANDROID CHANNEL CREATION
  // -----------------------------
  static Future<void> createDefaultChannel() async {
    const channel = AndroidNotificationChannel(
      'ciantis_channel',
      'Ciantis Notifications',
      description: 'General notifications for Ciantis',
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
