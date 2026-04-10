import '../models/calendar_day_model.dart';
import '../models/calendar_week_model.dart';
import '../models/calendar_month_model.dart';
import '../models/calendar_event_model.dart';

/// CalendarUiMapper converts rich calendar models into
/// lightweight UI-friendly maps/DTOs.
///
/// This keeps UI widgets simple and decoupled from
/// internal engine details.
class CalendarUiMapper {
  // Singleton
  static final CalendarUiMapper instance =
      CalendarUiMapper._internal();
  CalendarUiMapper._internal();

  // -----------------------------
  // DAY → UI MAP
  // -----------------------------
  Map<String, dynamic> dayToUi(CalendarDayModel day) {
    return {
      "date": day.date,
      "isToday": _isToday(day.date),
      "isOverloaded": day.isOverloaded,
      "isHighDensity": day.isHighDensity,
      "isLightDay": day.isLightDay,
      "totalBusyMinutes": day.totalBusyMinutes,
      "emotionalLoad": day.emotionalLoad,
      "fatigueLoad": day.fatigueLoad,
      "events": day.events.map(_eventToUi).toList(),
    };
  }

  // -----------------------------
  // WEEK → UI MAP
  // -----------------------------
  Map<String, dynamic> weekToUi(CalendarWeekModel week) {
    return {
      "weekStart": week.weekStart,
      "weekEnd": week.weekEnd,
      "totalBusyMinutes": week.totalBusyMinutes,
      "avgEmotionalLoad": week.avgEmotionalLoad,
      "avgFatigueLoad": week.avgFatigueLoad,
      "isOverloaded": week.isOverloaded,
      "isHighDensity": week.isHighDensity,
      "isLightWeek": week.isLightWeek,
      "days": week.days.map(dayToUi).toList(),
    };
  }

  // -----------------------------
  // MONTH → UI MAP
  // -----------------------------
  Map<String, dynamic> monthToUi(CalendarMonthModel month) {
    return {
      "year": month.year,
      "month": month.month,
      "totalEvents": month.totalEvents,
      "totalBusyMinutes": month.totalBusyMinutes,
      "avgEmotionalLoad": month.avgEmotionalLoad,
      "avgFatigueLoad": month.avgFatigueLoad,
      "isOverloaded": month.isOverloaded,
      "isHighDensity": month.isHighDensity,
      "isLightMonth": month.isLightMonth,
      "weeks": month.weeks.map(weekToUi).toList(),
      "days": month.days.map(dayToUi).toList(),
    };
  }

  // -----------------------------
  // EVENT → UI MAP
  // -----------------------------
  Map<String, dynamic> _eventToUi(CalendarEventModel e) {
    return {
      "id": e.id,
      "title": e.title,
      "description": e.description,
      "start": e.start,
      "end": e.end,
      "location": e.location,
      "categoryId": e.categoryId,
      "colorHex": e.colorHex,
      "emotionalLoad": e.emotionalLoad,
      "fatigueLoad": e.fatigueLoad,
      "isAllDay": e.isAllDay,
    };
  }

  // -----------------------------
  // TODAY CHECK
  // -----------------------------
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year &&
        now.month == date.month &&
        now.day == date.day;
  }
}
