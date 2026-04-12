import 'developer_logger.dart';

/// AiState
/// --------
/// Stores all explainability strings for:
/// - Mode reasoning
/// - Next Best Action reasoning
/// - Daily Briefing reasoning
/// - Summary reasoning
/// - Adaptive signals
///
/// This is what the Explainability Panel reads.
class AiState {
  static final AiState instance = AiState._internal();
  AiState._internal();

  String modeReason = "";
  String nextBestActionReason = "";
  String dailyBriefingReason = "";
  String summaryReason = "";
  Map<String, dynamic> adaptiveSignals = {};

  void clear() {
    modeReason = "";
    nextBestActionReason = "";
    dailyBriefingReason = "";
    summaryReason = "";
    adaptiveSignals = {};

    DeveloperLogger.log("AI State cleared");
  }

  void updateAdaptiveSignal(String key, dynamic value) {
    adaptiveSignals[key] = value;
    DeveloperLogger.log("Adaptive signal updated: $key = $value");
  }
}
