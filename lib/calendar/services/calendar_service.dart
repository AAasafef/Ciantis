import '../models/calendar_event_model.dart';
import '../models/calendar_day_model.dart';
import '../models/calendar_week_model.dart';
import '../models/calendar_month_model.dart';

import '../repositories/calendar_repository.dart';
import '../repositories/calendar_repository_integrator.dart';

import '../engines/calendar_smart_scheduling_engine.dart';
import '../engines/calendar_event_conflict_engine.dart';
import '../engines/calendar_insights_engine.dart';
import '../engines/calendar_free_time_engine.dart';
import '../sync/calendar_sync_engine.dart';

/// CalendarService is the unified API for the entire calendar subsystem.
///
/// It wraps:
/// - Repository
/// - Repository Integrator
/// - Sync Engine
/// - Smart Scheduling
/// - Conflict Detection
/// - Insights
/// - Free Time Engine
///
/// This is the layer the rest of Ciantis interacts with.
class CalendarService {
  // Singleton
  static final CalendarService instance = CalendarService._internal();
  CalendarService._internal();

  final _repo = CalendarRepository.instance;
  final _integrator = CalendarRepositoryIntegrator.instance;

  final _smart = CalendarSmartSchedulingEngine.instance;
  final _conflicts = CalendarEventConflictEngine.instance;
  final _insights = CalendarInsightsEngine.instance;
  final _free = CalendarFreeTimeEngine.instance;
  final _sync = CalendarSyncEngine.instance;

  // -----------------------------
  // INITIALIZE SYSTEM
  // -----------------------------
  Future<void> initialize() async {
    await _integrator.initialize();
  }

  // -----------------------------
  // EVENT CRUD
  // -----------------------------
  Future<void> addEvent(CalendarEventModel event) async {
    await _integrator.addEvent(event);
  }

  Future<void> updateEvent(CalendarEventModel event) async {
    await _integrator.updateEvent(event);
  }

  Future<void> deleteEvent(String eventId) async {
    await _integrator.deleteEvent(eventId);
  }

  List<CalendarEventModel> getAllEvents() {
    return _repo.getAllEvents();
  }

  // -----------------------------
  // DAY / WEEK / MONTH ACCESS
  // -----------------------------
  CalendarDayModel getDay(DateTime date) {
    return _repo.getDay(date);
  }

  CalendarWeekModel getWeek(DateTime weekStart) {
    return _repo.getWeek(weekStart);
  }

  CalendarMonthModel getMonth(int year, int month) {
    return _repo.getMonth(year, month);
  }

  // -----------------------------
  // INSIGHTS
  // -----------------------------
  String getDailyInsight(DateTime date) {
    return _insights.dailyInsight(getDay(date));
  }

  String getWeeklyInsight(DateTime weekStart) {
    return _insights.weeklyInsight(getWeek(weekStart));
  }

  String getMonthlyInsight(int year, int month) {
    return _insights.monthlyInsight(getMonth(year, month));
  }

  // -----------------------------
  // CONFLICT DETECTION
  // -----------------------------
  Map<String, dynamic> detectConflictsForDay(DateTime date) {
    return _conflicts.detectConflictsForDay(getDay(date));
  }

  Map<String, dynamic> detectConflictsForNewEvent(
    CalendarEventModel event,
  ) {
    return _conflicts.detectConflictsForNewEvent(
      newEvent: event,
      existingEvents: _repo.getAllEvents(),
    );
  }

  // -----------------------------
  // SMART SCHEDULING
  // -----------------------------
  Map<String, dynamic> bestTimeInWeek({
    required DateTime weekStart,
    required Duration duration,
  }) {
    return _smart.bestTimeInWeek(
      week: getWeek(weekStart),
      duration: duration,
    );
  }

  Map<String, dynamic> bestTimeInMonth({
    required int year,
    required int month,
    required Duration duration,
  }) {
    final monthModel = getMonth(year, month);
    return _smart.bestTimeInMonth(
      weeks: monthModel.weeks,
      duration: duration,
    );
  }

  // -----------------------------
  // FREE TIME WINDOWS
  // -----------------------------
  List<Map<String, dynamic>> freeBlocksForDay(DateTime date) {
    return _free.freeBlocksForDay(getDay(date));
  }

  List<Map<String, dynamic>> deepWorkWindowsForDay(DateTime date) {
    return _free.deepWorkWindowsForDay(getDay(date));
  }

  List<Map<String, dynamic>> recoveryWindowsForDay(DateTime date) {
    return _free.recoveryWindowsForDay(getDay(date));
  }

  // -----------------------------
  // SYNC HOOKS
  // -----------------------------
  Future<void> pushToCloud() async {
    await _sync.pushEvents(_repo.getAllEvents());
  }

  Future<void> pullFromCloud() async {
    final remote = await _sync.pullEvents();
    final merged = _sync.mergeEvents(
      local: _repo.getAllEvents(),
      remote: remote,
    );

    // Replace local with merged
    await _integrator.clear();
    for (final e in merged) {
      await _integrator.addEvent(e);
    }
  }

  SyncStatus get syncStatus => _sync.status;
}
