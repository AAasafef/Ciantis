import 'package:flutter/foundation.dart';

/// NotificationChannels defines the different notification
/// categories Ciantis uses, along with their priority levels
/// and behavior profiles.
///
/// This does NOT send notifications.
/// It simply defines the "tone" and "intensity" of each channel.
///
/// The NotificationDeliveryService will reference these profiles
/// when sending softened, delayed, or batched notifications.
class NotificationChannels {
  // Singleton
  static final NotificationChannels instance =
      NotificationChannels._internal();
  NotificationChannels._internal();

  // -----------------------------
  // CHANNEL DEFINITIONS
  // -----------------------------
  final Map<String, NotificationChannelProfile> channels = {
    "critical": NotificationChannelProfile(
      id: "critical",
      name: "Critical Alerts",
      priority: NotificationPriority.high,
      sound: NotificationSound.full,
      vibration: NotificationVibration.strong,
      allowDuringFocus: true,
      allowDuringOverloadProtection: true,
    ),
    "message": NotificationChannelProfile(
      id: "message",
      name: "Messages",
      priority: NotificationPriority.medium,
      sound: NotificationSound.normal,
      vibration: NotificationVibration.medium,
      allowDuringFocus: false,
      allowDuringOverloadProtection: false,
    ),
    "task": NotificationChannelProfile(
      id: "task",
      name: "Tasks & Reminders",
      priority: NotificationPriority.medium,
      sound: NotificationSound.soft,
      vibration: NotificationVibration.light,
      allowDuringFocus: false,
      allowDuringOverloadProtection: false,
    ),
    "event": NotificationChannelProfile(
      id: "event",
      name: "Calendar Events",
      priority: NotificationPriority.medium,
      sound: NotificationSound.normal,
      vibration: NotificationVibration.medium,
      allowDuringFocus: true,
      allowDuringOverloadProtection: false,
    ),
    "system": NotificationChannelProfile(
      id: "system",
      name: "System Notices",
      priority: NotificationPriority.low,
      sound: NotificationSound.soft,
      vibration: NotificationVibration.none,
      allowDuringFocus: false,
      allowDuringOverloadProtection: false,
    ),
  };

  NotificationChannelProfile getProfile(String id) {
    return channels[id] ??
        channels["system"]!; // fallback to low-intensity system channel
  }
}

// -----------------------------
// CHANNEL PROFILE
// -----------------------------
@immutable
class NotificationChannelProfile {
  final String id;
  final String name;
  final NotificationPriority priority;
  final NotificationSound sound;
  final NotificationVibration vibration;

  final bool allowDuringFocus;
  final bool allowDuringOverloadProtection;

  const NotificationChannelProfile({
    required this.id,
    required this.name,
    required this.priority,
    required this.sound,
    required this.vibration,
    required this.allowDuringFocus,
    required this.allowDuringOverloadProtection,
  });
}

// -----------------------------
// ENUMS
// -----------------------------
enum NotificationPriority {
  high,
  medium,
  low,
}

enum NotificationSound {
  full,
  normal,
  soft,
  none,
}

enum NotificationVibration {
  strong,
  medium,
  light,
  none,
}
