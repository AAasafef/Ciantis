import 'package:uuid/uuid.dart';
import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';
import 'mode_engine_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final NotificationRepository _repository = NotificationRepository();
  final ModeEngineService _modeEngine = ModeEngineService();
  final Uuid _uuid = const Uuid();

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initializeLocalNotifications();
  }

  // -----------------------------
  // INITIALIZE LOCAL NOTIFICATIONS
  // -----------------------------
  Future<void> _initializeLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(android: android, iOS: ios);

    await _local.initialize(settings);
  }

  // -----------------------------
  // CREATE NOTIFICATION
  // -----------------------------
  Future<void> createNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String type, // task, appointment, routine, system
    String? linkedId,
  }) async {
    final now = DateTime.now();

    final notification = NotificationModel(
      id: _uuid.v4(),
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      type: type,
      linkedId: linkedId,
      delivered: false,
      read: false,
      createdAt: now,
      updatedAt: now,
    );

    await _repository.addNotification(notification);

    await _scheduleLocalNotification(notification);
  }

  // -----------------------------
  // SCHEDULE LOCAL NOTIFICATION
  // -----------------------------
  Future<void> _scheduleLocalNotification(
      NotificationModel notification) async {
    final androidDetails = AndroidNotificationDetails(
      'ciantis_channel',
      'Ciantis Notifications',
      channelDescription: 'General notifications for Ciantis',
      importance: Importance.high,
      priority: Priority.high,
    );

    final iosDetails = DarwinNotificationDetails();

    final details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _local.zonedSchedule(
      notification.id.hashCode,
      notification.title,
      notification.body,
      notification.scheduledTime.toLocal().toUtc(),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: notification.id,
    );
  }

  // -----------------------------
  // MARK AS DELIVERED
  // -----------------------------
  Future<void> markDelivered(String id) async {
    final all = await _repository.getAllNotifications();
    final n = all.firstWhere((e) => e.id == id, orElse: () => null);

    if (n == null) return;

    final updated = n.copyWith(
      delivered: true,
      updatedAt: DateTime.now(),
    );

    await _repository.updateNotification(updated);
  }

  // -----------------------------
  // MARK AS READ
  // -----------------------------
  Future<void> markRead(String id) async {
    final all = await _repository.getAllNotifications();
    final n = all.firstWhere((e) => e.id == id, orElse: () => null);

    if (n == null) return;

    final updated = n.copyWith(
      read: true,
      updatedAt: DateTime.now(),
    );

    await _repository.updateNotification(updated);
  }

  // -----------------------------
  // DELETE NOTIFICATION
  // -----------------------------
  Future<void> deleteNotification(String id) async {
    await _repository.deleteNotification(id);
    await _local.cancel(id.hashCode);
  }

  // -----------------------------
  // GET ALL NOTIFICATIONS
  // -----------------------------
  Future<List<NotificationModel>> getAllNotifications() async {
    return await _repository.getAllNotifications();
  }

  // -----------------------------
  // GET UNREAD NOTIFICATIONS
  // -----------------------------
  Future<List<NotificationModel>> getUnreadNotifications() async {
    return await _repository.getUnreadNotifications();
  }

  // -----------------------------
  // GET UPCOMING NOTIFICATIONS
  // -----------------------------
  Future<List<NotificationModel>> getUpcomingNotifications() async {
    return await _repository.getUpcomingNotifications();
  }

  // -----------------------------
  // SYSTEM NOTIFICATION: MODE-AWARE NUDGE
  // -----------------------------
  Future<void> sendModeAwareNudge() async {
    final mode = _modeEngine.currentMode;

    String title = "Ciantis Insight";
    String body = "";

    switch (mode) {
      case AppMode.recovery:
        body = "Your system is in recovery mode. Slow down and breathe.";
        break;
      case AppMode.focus:
        body = "You’re in focus mode. Protect your deep work window.";
        break;
      case AppMode.overloaded:
        body = "You’re carrying a lot. Simplify your commitments today.";
        break;
      default:
        body = "Move with intention today.";
    }

    await createNotification(
      title: title,
      body: body,
      scheduledTime: DateTime.now().add(const Duration(seconds: 1)),
      type: "system",
    );
  }

  // -----------------------------
  // SYSTEM NOTIFICATION: DAILY PREVIEW
  // -----------------------------
  Future<void> sendDailyPreview({
    required int emotionalScore,
    required int fatigueScore,
    required int busyScore,
  }) async {
    String body =
        "Today’s outlook — Emotional: $emotionalScore, Fatigue: $fatigueScore, Busy: $busyScore.";

    await createNotification(
      title: "Daily Preview",
      body: body,
      scheduledTime: DateTime.now().add(const Duration(seconds: 1)),
      type: "system",
    );
  }
}
