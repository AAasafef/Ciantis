import 'package:equatable/equatable.dart';

/// Core calendar event model for Ciantis.
/// This is the single source of truth for events across:
/// - Month / Week / Day views
/// - Agenda lists
/// - Reminders
/// - Smart scheduling
/// - Mode / NBA integrations
class CalendarEventModel extends Equatable {
  final String id;
  final String title;
  final String? description;

  final DateTime start;
  final DateTime end;

  final bool allDay;

  final String? location;
  final String? calendarId; // e.g. "personal", "school", "work"

  final List<String> tags;

  /// Visual / UX
  final int color; // ARGB or hex int
  final bool isPinned;
  final bool isBusy; // vs free/available

  /// Integration flags
  final bool isFromExternalSource; // Google, Outlook, etc.
  final String? externalSource;
  final String? externalEventId;

  /// Reminder / notification
  final Duration? reminderOffset; // e.g. 15 minutes before

  const CalendarEventModel({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    this.description,
    this.allDay = false,
    this.location,
    this.calendarId,
    this.tags = const [],
    this.color = 0xFF000000,
    this.isPinned = false,
    this.isBusy = true,
    this.isFromExternalSource = false,
    this.externalSource,
    this.externalEventId,
    this.reminderOffset,
  });

  bool get isMultiDay =>
      !allDay &&
      (end.difference(start).inDays >= 1 ||
          start.day != end.day ||
          start.month != end.month ||
          start.year != end.year);

  bool occursOnDate(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);

    return (d.isAtSameMomentAs(s) || d.isAfter(s)) &&
        (d.isAtSameMomentAs(e) || d.isBefore(e));
  }

  CalendarEventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? start,
    DateTime? end,
    bool? allDay,
    String? location,
    String? calendarId,
    List<String>? tags,
    int? color,
    bool? isPinned,
    bool? isBusy,
    bool? isFromExternalSource,
    String? externalSource,
    String? externalEventId,
    Duration? reminderOffset,
  }) {
    return CalendarEventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      start: start ?? this.start,
      end: end ?? this.end,
      allDay: allDay ?? this.allDay,
      location: location ?? this.location,
      calendarId: calendarId ?? this.calendarId,
      tags: tags ?? this.tags,
      color: color ?? this.color,
      isPinned: isPinned ?? this.isPinned,
      isBusy: isBusy ?? this.isBusy,
      isFromExternalSource:
          isFromExternalSource ?? this.isFromExternalSource,
      externalSource: externalSource ?? this.externalSource,
      externalEventId: externalEventId ?? this.externalEventId,
      reminderOffset: reminderOffset ?? this.reminderOffset,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        start,
        end,
        allDay,
        location,
        calendarId,
        tags,
        color,
        isPinned,
        isBusy,
        isFromExternalSource,
        externalSource,
        externalEventId,
        reminderOffset,
      ];
}
