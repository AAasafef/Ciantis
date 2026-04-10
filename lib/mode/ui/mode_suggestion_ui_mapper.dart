import 'package:flutter/foundation.dart';

import '../integrations/mode_recommendation_engine.dart';
import '../integrations/mode_calendar_behavior_modifiers.dart';

/// ModeSuggestionUiMapper converts:
/// - ModeRecommendation
/// - ModeBehaviorModifiers
///
/// Into a UI-friendly DTO for rendering:
/// - Suggested mode
/// - Secondary modes
/// - Reason
/// - Insight
/// - Behavioral cues (soften notifications, reduce interruptions, etc.)
class ModeSuggestionUiMapper {
  // Singleton
  static final ModeSuggestionUiMapper instance =
      ModeSuggestionUiMapper._internal();
  ModeSuggestionUiMapper._internal();

  final _recommend = ModeRecommendationEngine.instance;
  final _modifiers = ModeCalendarBehaviorModifiers.instance;

  // -----------------------------
  // DAILY SUGGESTION → UI DTO
  // -----------------------------
  ModeSuggestionUiModel suggestionForDay(DateTime date) {
    final rec = _recommend.recommendForDay(date);
    final mod = _modifiers.getDailyModifiers(date);

    return ModeSuggestionUiModel(
      primaryMode: rec.primaryMode,
      secondaryModes: rec.secondaryModes,
      reason: rec.reason,
      insight: rec.insight,
      softenNotifications: mod.softenNotifications,
      reduceInterruptions: mod.reduceInterruptions,
      boostFocusMode: mod.boostFocusMode,
      boostRecoveryMode: mod.boostRecoveryMode,
      activateOverloadProtection: mod.activateOverloadProtection,
      recommendations: mod.recommendations,
    );
  }

  // -----------------------------
  // WEEKLY SUGGESTION → UI DTO
  // -----------------------------
  ModeSuggestionUiModel suggestionForWeek(DateTime weekStart) {
    final rec = _recommend.recommendForWeek(weekStart);
    final mod = _modifiers.getWeeklyModifiers(weekStart);

    return ModeSuggestionUiModel(
      primaryMode: rec.primaryMode,
      secondaryModes: rec.secondaryModes,
      reason: rec.reason,
      insight: rec.insight,
      softenNotifications: mod.softenNotifications,
      reduceInterruptions: mod.reduceInterruptions,
      boostFocusMode: mod.boostFocusMode,
      boostRecoveryMode: mod.boostRecoveryMode,
      activateOverloadProtection: mod.activateOverloadProtection,
      recommendations: mod.recommendations,
    );
  }

  // -----------------------------
  // MONTHLY SUGGESTION → UI DTO
  // -----------------------------
  ModeSuggestionUiModel suggestionForMonth(int year, int month) {
    final rec = _recommend.recommendForMonth(year, month);
    final mod = _modifiers.getMonthlyModifiers(year, month);

    return ModeSuggestionUiModel(
      primaryMode: rec.primaryMode,
      secondaryModes: rec.secondaryModes,
      reason: rec.reason,
      insight: rec.insight,
      softenNotifications: mod.softenNotifications,
      reduceInterruptions: mod.reduceInterruptions,
      boostFocusMode: mod.boostFocusMode,
      boostRecoveryMode: mod.boostRecoveryMode,
      activateOverloadProtection: mod.activateOverloadProtection,
      recommendations: mod.recommendations,
    );
  }
}

// -----------------------------
// UI DTO
// -----------------------------
@immutable
class ModeSuggestionUiModel {
  final String primaryMode;
  final List<String> secondaryModes;

  final String reason;
  final String insight;

  final bool softenNotifications;
  final bool reduceInterruptions;
  final bool boostFocusMode;
  final bool boostRecoveryMode;
  final bool activateOverloadProtection;

  final List<String> recommendations;

  const ModeSuggestionUiModel({
    required this.primaryMode,
    required this.secondaryModes,
    required this.reason,
    required this.insight,
    required this.softenNotifications,
    required this.reduceInterruptions,
    required this.boostFocusMode,
    required this.boostRecoveryMode,
    required this.activateOverloadProtection,
    required this.recommendations,
  });
}
