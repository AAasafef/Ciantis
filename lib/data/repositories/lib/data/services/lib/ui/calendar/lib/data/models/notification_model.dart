class NotificationModel {
  final String id;

  final String title;
  final String body;

  final DateTime scheduledTime;

  final String type; // task, appointment, routine, system
  final String? linkedId; // taskId, appointmentId, etc.

  final bool delivered;
  final bool read;

  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
    required this.type,
    this.linkedId,
    required this.delivered,
    required this.read,
    required this.createdAt,
    required this.updatedAt,
  });

  NotificationModel copyWith({
    String? title,
    String? body,
    DateTime? scheduledTime,
    String? type,
    String? linkedId,
    bool? delivered,
    bool? read,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      type: type ?? this.type,
      linkedId: linkedId ?? this.linkedId,
      delivered: delivered ?? this.delivered,
      read: read ?? this.read,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      scheduledTime: DateTime.parse(map['scheduledTime']),
      type: map['type'],
      linkedId: map['linkedId'],
      delivered: map['delivered'] == 1,
      read: map['read'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'scheduledTime': scheduledTime.toIso8601String(),
      'type': type,
      'linkedId': linkedId,
      'delivered': delivered ? 1 : 0,
      'read': read ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
