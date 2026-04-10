import '../models/calendar_event_model.dart';
import '../models/calendar_day_model.dart';

/// CalendarDayBuilderEngine constructs CalendarDayModels from:
/// - Parsed events
/// - A specific date
/// - Emotional + fatigue scoring rules
/// - Busy-minute calculations
/// - Overload detection
///
/// This is the foundation for:
/// - Day View
/// - Agenda View
/// - Month heatmaps
/// - Week summaries
/// - Smart scheduling
class CalendarDayBuilderEngine {
  // Singleton
  static final CalendarDayBuilderEngine instance =
      CalendarDayBuilderEngine._internal();
  CalendarDayBuilderEngine._internal();

  // -----------------------------
  // BUILD A SINGLE DAY
  // -----------------------------
  CalendarDayModel buildDay({
    required DateTime date,
    required List<CalendarEventModel> allEvents,
  }) {
    final events = _eventsForDate(date, allEvents);

    final busyMinutes = _calculateBusyMinutes(events);
    final emotionalLoad = _calculateEmotionalLoad(events);
    final fatigueLoad = _calculateFatigueLoad(events);

    final isOverloaded = (emotionalLoad + fatigueLoad) > 20;
    final isHighDensity = events.length >= 6;
    final isLightDay = events.length <= 1;

    return CalendarDayModel(
      date: date,
      events: events,
      totalBusyMinutes: busyMinutes,
      emotionalLoad: emotionalLoad,
      fatigueLoad: fatigueLoad,
      aiInsight: _generateAIInsight(
        events: events,
        emotionalLoad: emotionalLoad,
        fatigueLoad: fatigueLoad,
        busyMinutes: busyMinutes,
      ),
      isOverloaded: isOverloaded,
      isHighDensity: isHighDensity,
      isLightDay: isLightDay,
      linkedTaskIds: const [],
      linkedRoutineIds: const [],
      linkedHabitIds: const [],
      linkedAppointmentIds: const [],
    );
  }

  // -----------------------------
  // FILTER EVENTS FOR THIS DATE
  // -----------------------------
  List<CalendarEventModel> _eventsForDate(
      DateTime date, List<CalendarEventModel> all) {
    return all.where((e) => e.occursOnDate(date)).toList();
  }

  // -----------------------------
  // BUSY MINUTES
  // -----------------------------
  int _calculateBusyMinutes(List<CalendarEventModel> events) {
    int total = 0;

    for (final e in events) {
      if (e.allDay) {
        total += 8 * 60; // treat all-day as 8 hours
      } else {
        total += e.end.difference(e.start).inMinutes;
      }
    }

    return total;
  }

  // -----------------------------
  // EMOTIONAL LOAD
  // -----------------------------
  double _calculateEmotionalLoad(List<CalendarEventModel> events) {
    if (events.isEmpty) return 0;

    double score = 0;

    for (final e in events) {
      final title = e.title.toLowerCase();

      if (title.contains("exam")) score += 6;
      if (title.contains("appointment")) score += 4;
      if (title.contains("meeting")) score += 3;
      if (title.contains("court")) score += 8;
      if (title.contains("deadline")) score += 5;
    }

    return score.clamp(0, 10).toDouble();
  }

  // -----------------------------
  // FATIGUE LOAD
  // -----------------------------
  double _calculateFatigueLoad(List<CalendarEventModel> events) {
    if (events.isEmpty) return 0;

    double score = 0;

    for (final e in events) {
      if (e.allDay) score += 4;
      if (e.isBusy) score += 2;
      if (e.title.toLowerCase().contains("travel")) score += 5;
    }

    return score.clamp(0, 10).toDouble();
  }

  // -----------------------------
  // AI INSIGHT (PLACEHOLDER)
  // -----------------------------
  String? _generateAIInsight({
    required List<CalendarEventModel> events,
    required double emotionalLoad,
    required double fatigueLoad,
    required int busyMinutes,
  }) {
    if (events.isEmpty) {
      return "This is a light day with plenty of flexibility.";
    }

    if (emotionalLoad > 7) {
      return "This day carries a high emotional load. Consider pacing yourself.";
    }

    if (fatigueLoad > 7) {
      return "This day may feel physically draining. Build in recovery time.";
    }

    if (busyMinutes > 8 * 60) {
      return "This is a high-density day with limited free space.";
    }

    return "This day has a balanced schedule with manageable demands.";
  }
}
