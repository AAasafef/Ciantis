import 'package:equatable/equatable.dart';
import 'calendar_week_model.dart';
import 'calendar_day_model.dart';

/// CalendarMonthModel represents a full month in the calendar system.
/// It aggregates:
/// - Weeks
/// - Days
/// - Event density
/// - Emotional + fatigue heatmaps
/// - AI insights
/// - Overload detection
/// - Smart scheduling windows
///
/// This is used by:
/// - Month View
/// - Calendar Analytics
/// - Smart Scheduling Engine
/// - Mode Engine
/// - Next Best Action Engine
class CalendarMonthModel extends Equatable {
  final int year;
  final int month;

  /// All weeks in this month (typically 4–6).
  final List<CalendarWeekModel> weeks;

  /// Flattened list of all days in the month.
  final List<CalendarDayModel> days;

  /// Total events across the month.
  final int totalEvents;

  /// Total busy minutes across the month.
  final int totalBusyMinutes;

  /// Average emotional load across the month.
  final double avgEmotionalLoad;

  /// Average fatigue load across the month.
  final double avgFatigueLoad;

  /// Whether this month is overloaded (emotional + fatigue > threshold).
  final bool isOverloaded;

  /// Whether this month is unusually dense with events.
  final bool isHighDensity;

  /// Whether this month is unusually light.
  final bool isLightMonth;

  /// AI-generated insight summarizing the month.
  final String? aiInsight;

  const CalendarMonthModel({
    required this.year,
    required this.month,
    required this.weeks,
    required this.days,
    required this.totalEvents,
    required this.totalBusyMinutes,
    required this.avgEmotionalLoad,
    required this.avgFatigueLoad,
    required this.isOverloaded,
    required this.isHighDensity,
    required this.isLightMonth,
    this.aiInsight,
  });

  /// Convenience: returns the first day of the month.
  DateTime get firstDay => DateTime(year, month, 1);

  /// Convenience: returns the last day of the month.
  DateTime get lastDay => DateTime(year, month + 1, 0);

  /// Convenience: number of days in the month.
  int get numberOfDays => lastDay.day;

  CalendarMonthModel copyWith({
    int? year,
    int? month,
    List<CalendarWeekModel>? weeks,
    List<CalendarDayModel>? days,
    int? totalEvents,
    int? totalBusyMinutes,
    double? avgEmotionalLoad,
    double? avgFatigueLoad,
    bool? isOverloaded,
    bool? isHighDensity,
    bool? isLightMonth,
    String? aiInsight,
  }) {
    return CalendarMonthModel(
      year: year ?? this.year,
      month: month ?? this.month,
      weeks: weeks ?? this.weeks,
      days: days ?? this.days,
      totalEvents: totalEvents ?? this.totalEvents,
      totalBusyMinutes: totalBusyMinutes ?? this.totalBusyMinutes,
      avgEmotionalLoad: avgEmotionalLoad ?? this.avgEmotionalLoad,
      avgFatigueLoad: avgFatigueLoad ?? this.avgFatigueLoad,
      isOverloaded: isOverloaded ?? this.isOverloaded,
      isHighDensity: isHighDensity ?? this.isHighDensity,
      isLightMonth: isLightMonth ?? this.isLightMonth,
      aiInsight: aiInsight ?? this.aiInsight,
    );
  }

  @override
  List<Object?> get props => [
        year,
        month,
        weeks,
        days,
        totalEvents,
        totalBusyMinutes,
        avgEmotionalLoad,
        avgFatigueLoad,
        isOverloaded,
        isHighDensity,
        isLightMonth,
        aiInsight,
      ];
}
