import 'developer_logger.dart';

/// AiState
/// --------
/// Stores all AI reasoning strings for:
/// - Mode
/// - Next Best Action
/// - Daily Briefing
/// - Summary
/// - Adaptive signals
///
/// This is what powers the AI Explainability Screen.
class AiState {
  static final AiState instance = AiState._internal();
  AiState._internal();

  String modeReason = "";
  String nextBestActionReason = "";
  String dailyBriefingReason = "";
  String summaryReason = "";

  final Map<String, dynamic> adaptiveSignals = {};

  /// Update a single adaptive signal.
  void updateAdaptiveSignal(String key, dynamic value) {
    adaptiveSignals[key] = value;
    DeveloperLogger.log("AI State: adaptive signal updated → $key = $value");
  }

  /// Clear all AI reasoning + signals.
  void clear() {
    modeReason = "";
    nextBestActionReason = "";
    dailyBriefingReason = "";
    summaryReason = "";
    adaptiveSignals.clear();

    DeveloperLogger.log("AI State cleared");
  }
}
