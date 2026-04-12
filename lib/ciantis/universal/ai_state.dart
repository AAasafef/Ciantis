/// AiState
/// -------
/// Stores the internal reasoning state of Ciantis.
/// This is NOT the reasoning engine.
/// It is a transparent log of:
/// - Mode decisions
/// - Next Best Action reasoning
/// - Daily Briefing reasoning
/// - Adaptive Intelligence signals
/// - Universal Hub decisions
///
/// This will later power:
/// - Explainability UI
/// - Debug Console
/// - Developer Tools
class AiState {
  // Singleton
  static final AiState instance = AiState._internal();
  AiState._internal();

  // -----------------------------
  // CURRENT MODE REASONING
  // -----------------------------
  String modeReason = "";

  // -----------------------------
  // NEXT BEST ACTION REASONING
  // -----------------------------
  String nextBestActionReason = "";

  // -----------------------------
  // DAILY BRIEFING REASONING
  // -----------------------------
  String dailyBriefingReason = "";

  // -----------------------------
  // ADAPTIVE SIGNALS
  // -----------------------------
  Map<String, dynamic> adaptiveSignals = {};

  // -----------------------------
  // UNIVERSAL SUMMARY REASONING
  // -----------------------------
  String summaryReason = "";

  // -----------------------------
  // CLEAR ALL (for debugging)
  // -----------------------------
  void clear() {
    modeReason = "";
    nextBestActionReason = "";
    dailyBriefingReason = "";
    adaptiveSignals = {};
    summaryReason = "";
  }
}
