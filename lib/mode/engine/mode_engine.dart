import 'package:flutter/foundation.dart';

import '../auto/mode_auto_switching_engine.dart';
import '../integrations/mode_recommendation_engine.dart';
import '../integrations/mode_calendar_behavior_modifiers.dart';
import '../ui/mode_suggestion_ui_mapper.dart';

/// ModeEngine is the unified brain of the entire Mode system.
///
/// It integrates:
/// - Auto Mode Switching
/// - Mode Recommendations
/// - Behavioral Modifiers
/// - Calendar Signals
/// - UI Suggestions
///
/// This is the single source of truth for:
/// - Current mode
/// - Why that mode is active
/// - What the system recommends
/// - How the UI should adapt
class ModeEngine with ChangeNotifier {
  // Singleton
  static final ModeEngine instance = ModeEngine._internal();
  ModeEngine._internal();

  final _auto = ModeAutoSwitchingEngine.instance;
  final _recommend = ModeRecommendationEngine.instance;
  final _modifiers = ModeCalendarBehaviorModifiers.instance;
  final _uiMapper = ModeSuggestionUiMapper.instance;

  String _activeMode = "balanced";
  String get activeMode => _activeMode;

  ModeSuggestionUiModel? _currentSuggestion;
  ModeSuggestionUiModel? get currentSuggestion => _currentSuggestion;

  // -----------------------------
  // INITIALIZE FOR TODAY
  // -----------------------------
  void initializeForToday(DateTime date) {
    _activeMode = _auto.autoSwitchForDay(date);
    _currentSuggestion = _uiMapper.suggestionForDay(date);
    notifyListeners();
  }

  // -----------------------------
  // MANUAL OVERRIDE
  // -----------------------------
  void overrideMode(String modeId) {
    _auto.overrideMode(modeId);
    _activeMode = modeId;
    notifyListeners();
  }

  // -----------------------------
  // REFRESH DAILY MODE
  // -----------------------------
  void refreshDailyMode(DateTime date) {
    _activeMode = _auto.autoSwitchForDay(date);
    _currentSuggestion = _uiMapper.suggestionForDay(date);
    notifyListeners();
  }

  // -----------------------------
  // REFRESH WEEKLY MODE
  // -----------------------------
  void refreshWeeklyMode(DateTime weekStart) {
    _activeMode = _auto.autoSwitchForWeek(weekStart);
    notifyListeners();
  }

  // -----------------------------
  // REFRESH MONTHLY MODE
  // -----------------------------
  void refreshMonthlyMode(int year, int month) {
    _activeMode = _auto.autoSwitchForMonth(year, month);
    notifyListeners();
  }

  // -----------------------------
  // REAL-TIME ADAPTATION
  // -----------------------------
  void adaptInRealTime({
    required DateTime now,
    required bool isInDeepWorkWindow,
    required bool isInRecoveryWindow,
  }) {
    _activeMode = _auto.adaptInRealTime(
      now: now,
      isInDeepWorkWindow: isInDeepWorkWindow,
      isInRecoveryWindow: isInRecoveryWindow,
    );

    notifyListeners();
  }

  // -----------------------------
  // GET UI SUGGESTION
  // -----------------------------
  ModeSuggestionUiModel getSuggestionForDay(DateTime date) {
    return _uiMapper.suggestionForDay(date);
  }

  ModeSuggestionUiModel getSuggestionForWeek(DateTime weekStart) {
    return _uiMapper.suggestionForWeek(weekStart);
  }

  ModeSuggestionUiModel getSuggestionForMonth(int year, int month) {
    return _uiMapper.suggestionForMonth(year, month);
  }
}
