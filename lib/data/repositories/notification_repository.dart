import '../dao/notification_dao.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final NotificationDao _dao = NotificationDao();

  // -----------------------------
  // ADD NOTIFICATION
  // -----------------------------
  Future<void> addNotification(NotificationModel notification) async {
    await _dao.insertNotification(notification);
  }

  // -----------------------------
  // UPDATE NOTIFICATION
  // -----------------------------
  Future<void> updateNotification(NotificationModel notification) async {
    await _dao.updateNotification(notification);
  }

  // -----------------------------
  // DELETE NOTIFICATION
  // -----------------------------
  Future<void> deleteNotification(String id) async {
    await _dao.deleteNotification(id);
  }

  // -----------------------------
  // GET ALL NOTIFICATIONS
  // -----------------------------
  Future<List<NotificationModel>> getAllNotifications() async {
    return await _dao.getAllNotifications();
  }

  // -----------------------------
  // GET UNREAD NOTIFICATIONS
  // -----------------------------
  Future<List<NotificationModel>> getUnreadNotifications() async {
    return await _dao.getUnreadNotifications();
  }

  // -----------------------------
  // GET UPCOMING NOTIFICATIONS
  // -----------------------------
  Future<List<NotificationModel>> getUpcomingNotifications() async {
    return await _dao.getUpcomingNotifications();
  }

  // -----------------------------
  // GET NOTIFICATIONS BY LINKED ENTITY
  // -----------------------------
  Future<List<NotificationModel>> getNotificationsByLinkedId(
      String linkedId) async {
    return await _dao.getNotificationsByLinkedId(linkedId);
  }
}
