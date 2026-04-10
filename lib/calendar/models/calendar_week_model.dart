import 'package:equatable/equatable.dart';
import 'calendar_day_model.dart';

/// CalendarWeekModel represents a full week in the calendar system.
/// It aggregates:
/// - 7 CalendarDayModels
/// - Weekly busy score
/// - Weekly emotional load
/// - Weekly fatigue load
/// - AI insights
/// - Overload detection
/// - Smart scheduling windows
///
/// This is used by:
/// - Week View
/// - Smart Scheduling Engine
/// - Calendar Analytics
/// - Mode Engine
/// - Next Best Action Engine
class CalendarWeekModel extends Equatable {
  final DateTime weekStart; // Monday (or user preference)
  final List<CalendarDayModel> days;

  /// Total busy minutes across the week.
  final int totalBusyMinutes;

  /// Average emotional load across the week.
  final double avgEmotionalLoad;

  /// Average fatigue load across the week.
  final double avgFatigueLoad;

  /// Whether this week is overloaded (emotional + fatigue > threshold).
  final bool isOverloaded;

  /// Whether this week is unusually dense with events.
  final bool isHighDensity;

  /// Whether this week is unusually light.
  final bool isLightWeek;

  /// AI-generated insight summarizing the week.
  final String? aiInsight;

  const CalendarWeekModel({
    required this.weekStart,
    required this.days,
    required this.totalBusyMinutes,
    required this.avgEmotionalLoad,
    required this.avgFatigueLoad,
    required this.isOverloaded,
    required this.isHighDensity,
    required this.isLightWeek,
    this.aiInsight,
  });

  /// Convenience: returns the week end date.
  DateTime get weekEnd => weekStart.add(const Duration(days: 6));

  /// Convenience: returns the number of events across the week.
  int get totalEvents =>
      days.fold(0, (sum, d) => sum + d.events.length);

  CalendarWeekModel copyWith({
    DateTime? weekStart,
    List<CalendarDayModel>? days,
    int? totalBusyMinutes,
    double? avgEmotionalLoad,
    double? avgFatigueLoad,
    bool? isOverloaded,
    bool? isHighDensity,
    bool? isLightWeek,
    String? aiInsight,
  }) {
    return CalendarWeekModel(
      weekStart: weekStart ?? this.weekStart,
      days: days ?? this.days,
      totalBusyMinutes: totalBusyMinutes ?? this.totalBusyMinutes,
      avgEmotionalLoad: avgEmotionalLoad ?? this.avgEmotionalLoad,
      avgFatigueLoad: avgFatigueLoad ?? this.avgFatigueLoad,
      isOverloaded: isOverloaded ?? this.isOverloaded,
      isHighDensity: isHighDensity ?? this.isHighDensity,
      isLightWeek: isLightWeek ?? this.isLightWeek,
      aiInsight: aiInsight ?? this.aiInsight,
    );
  }

  @override
  List<Object?> get props => [
        weekStart,
        days,
        totalBusyMinutes,
        avgEmotionalLoad,
        avgFatigueLoad,
        isOverloaded,
        isHighDensity,
        isLightWeek,
        aiInsight,
      ];
}
