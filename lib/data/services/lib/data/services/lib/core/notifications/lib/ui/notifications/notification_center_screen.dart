import 'package:flutter/material.dart';
import '../../data/services/notification_service.dart';
import '../../data/models/notification_model.dart';
import '../appointments/appointment_details_screen.dart';
import '../tasks/task_details_screen.dart';

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  final NotificationService _notificationService = NotificationService();

  List<NotificationModel> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final list = await _notificationService.getAllNotifications();
    setState(() {
      _notifications = list.reversed.toList(); // newest first
      _loading = false;
    });
  }

  Future<void> _markRead(NotificationModel n) async {
    if (!n.read) {
      await _notificationService.markRead(n.id);
      _loadNotifications();
    }
  }

  Future<void> _delete(NotificationModel n) async {
    await _notificationService.deleteNotification(n.id);
    _loadNotifications();
  }

  void _openLinked(NotificationModel n) async {
    if (n.linkedId == null) return;

    if (n.type == "task") {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TaskDetailsScreen(taskId: n.linkedId!),
        ),
      );
    } else if (n.type == "appointment") {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              AppointmentDetailsScreen(appointmentId: n.linkedId!),
        ),
      );
    }

    _markRead(n);
  }

  Widget _notificationTile(NotificationModel n) {
    final isUnread = !n.read;

    return Dismissible(
      key: Key(n.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF8A4FFF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _delete(n),
      child: GestureDetector(
        onTap: () {
          _openLinked(n);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isUnread ? const Color(0xFFF1E9FF) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE8E2F0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Unread dot
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 6, right: 12),
                decoration: BoxDecoration(
                  color: isUnread
                      ? const Color(0xFF8A4FFF)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      n.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5A4A6A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      n.body,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7A6F8F),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _formatDate(n.scheduledTime),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9A8FB0),
                      ),
                    ),
                  ],
                ),
              ),

              // Type badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF8A4FFF).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  n.type[0].toUpperCase() + n.type.substring(1),
                  style: const TextStyle(
                    color: Color(0xFF8A4FFF),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? "PM" : "AM";
    return "${dt.month}/${dt.day}/${dt.year}  $h:$m $ampm";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? const Center(
                  child: Text(
                    'No notifications',
                    style: TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: _notifications.map(_notificationTile).toList(),
                ),
    );
  }
}
