import 'package:equatable/equatable.dart';
import 'calendar_event_model.dart';

/// CalendarDayModel represents a single day in the calendar system.
/// It aggregates:
/// - Events
/// - Busy score
/// - Emotional load
/// - Fatigue load
/// - AI insights
/// - Linked tasks, routines, habits, appointments
///
/// This is the core model used by:
/// - Day View
/// - Agenda View
/// - Month View indicators
/// - Smart scheduling
/// - Mode Engine
/// - Next Best Action Engine
class CalendarDayModel extends Equatable {
  final DateTime date;

  /// All events occurring on this day (including multi-day events).
  final List<CalendarEventModel> events;

  /// Total minutes of scheduled time.
  final int totalBusyMinutes;

  /// Emotional load score (0–10).
  final double emotionalLoad;

  /// Fatigue impact score (0–10).
  final double fatigueLoad;

  /// AI-generated insight string for the day.
  final String? aiInsight;

  /// Whether this day is overloaded (emotional or fatigue > 20 combined).
  final bool isOverloaded;

  /// Whether this day is a “high density” day (many events).
  final bool isHighDensity;

  /// Whether this day is a “light day” (few events).
  final bool isLightDay;

  /// Linked task IDs (for cross-system intelligence).
  final List<String> linkedTaskIds;

  /// Linked routine IDs.
  final List<String> linkedRoutineIds;

  /// Linked habit IDs.
  final List<String> linkedHabitIds;

  /// Linked appointment IDs.
  final List<String> linkedAppointmentIds;

  const CalendarDayModel({
    required this.date,
    required this.events,
    required this.totalBusyMinutes,
    required this.emotionalLoad,
    required this.fatigueLoad,
    required this.aiInsight,
    required this.isOverloaded,
    required this.isHighDensity,
    required this.isLightDay,
    this.linkedTaskIds = const [],
    this.linkedRoutineIds = const [],
    this.linkedHabitIds = const [],
    this.linkedAppointmentIds = const [],
  });

  CalendarDayModel copyWith({
    DateTime? date,
    List<CalendarEventModel>? events,
    int? totalBusyMinutes,
    double? emotionalLoad,
    double? fatigueLoad,
    String? aiInsight,
    bool? isOverloaded,
    bool? isHighDensity,
    bool? isLightDay,
    List<String>? linkedTaskIds,
    List<String>? linkedRoutineIds,
    List<String>? linkedHabitIds,
    List<String>? linkedAppointmentIds,
  }) {
    return CalendarDayModel(
      date: date ?? this.date,
      events: events ?? this.events,
      totalBusyMinutes: totalBusyMinutes ?? this.totalBusyMinutes,
      emotionalLoad: emotionalLoad ?? this.emotionalLoad,
      fatigueLoad: fatigueLoad ?? this.fatigueLoad,
      aiInsight: aiInsight ?? this.aiInsight,
      isOverloaded: isOverloaded ?? this.isOverloaded,
      isHighDensity: isHighDensity ?? this.isHighDensity,
      isLightDay: isLightDay ?? this.isLightDay,
      linkedTaskIds: linkedTaskIds ?? this.linkedTaskIds,
      linkedRoutineIds: linkedRoutineIds ?? this.linkedRoutineIds,
      linkedHabitIds: linkedHabitIds ?? this.linkedHabitIds,
      linkedAppointmentIds:
          linkedAppointmentIds ?? this.linkedAppointmentIds,
    );
  }

  @override
  List<Object?> get props => [
        date,
        events,
        totalBusyMinutes,
        emotionalLoad,
        fatigueLoad,
        aiInsight,
        isOverloaded,
        isHighDensity,
        isLightDay,
        linkedTaskIds,
        linkedRoutineIds,
        linkedHabitIds,
        linkedAppointmentIds,
      ];
}
