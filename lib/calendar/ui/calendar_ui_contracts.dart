import '../models/calendar_day_model.dart';
import '../models/calendar_week_model.dart';
import '../models/calendar_month_model.dart';

/// Base interface for any Calendar ViewModel.
abstract class CalendarViewModel {
  /// Called when the view should refresh its data.
  Future<void> refresh();

  /// Human-readable title for the view (e.g., "April 2026", "Week of Apr 6").
  String get title;
}

/// Contract for a Month View model.
abstract class CalendarMonthViewModel extends CalendarViewModel {
  /// The underlying month model.
  CalendarMonthModel get monthModel;

  /// All days in the month grid (including leading/trailing days).
  List<CalendarDayModel> get gridDays;

  /// Called when a day is tapped.
  void onDaySelected(CalendarDayModel day);
}

/// Contract for a Week View model.
abstract class CalendarWeekViewModel extends CalendarViewModel {
  /// The underlying week model.
  CalendarWeekModel get weekModel;

  /// Days in the week.
  List<CalendarDayModel> get days;

  /// Called when a day is tapped.
  void onDaySelected(CalendarDayModel day);
}

/// Contract for a Day View model.
abstract class CalendarDayViewModel extends CalendarViewModel {
  /// The underlying day model.
  CalendarDayModel get dayModel;

  /// Called when an event is tapped.
  void onEventSelected(String eventId);
}
