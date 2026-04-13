import 'dart:async';

import 'developer_logger.dart';
import 'system_load_engine.dart';
import 'memory_engine.dart';
import 'emotion_engine.dart';
import 'mode_engine.dart';
import 'opportunity_engine.dart';
import 'opportunity_delta_engine.dart';
import 'prediction_engine.dart';
import 'cognitive_load_engine.dart';
import 'cognitive_health_engine.dart';
import 'cognitive_strain_delta_engine.dart';
import 'context_delta_engine.dart';
import 'daily_briefing_engine.dart';
import 'summary_engine.dart';
import 'nba_engine.dart';

/// CognitiveEngineOrchestrator
/// ----------------------------
/// The master synchronization layer for all cognitive engines.
/// Ensures:
/// - Ordered updates
/// - Stable tick rhythm
/// - No race conditions
/// - Unified cognitive pulse
/// - Predictable cascading updates
///
/// This is the brainstem of Ciantis’ cognitive architecture.
class CognitiveEngineOrchestrator {
  static final CognitiveEngineOrchestrator instance =
      CognitiveEngineOrchestrator._internal();

  CognitiveEngineOrchestrator._internal();

  Timer? _timer;

  /// Tick rate (ms)
  static const int tickMs = 500;

  void start() {
    DeveloperLogger.log("CognitiveEngineOrchestrator → START");

    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(milliseconds: tickMs),
      (_) => _tick(),
    );
  }

  void stop() {
    DeveloperLogger.log("CognitiveEngineOrchestrator → STOP");
    _timer?.cancel();
    _timer = null;
  }

  void _tick() {
    DeveloperLogger.log("CognitiveEngineOrchestrator → TICK");

    // ORDER MATTERS — this is the cognitive cascade.

    /// 1. System Load (base performance metrics)
    SystemLoadEngine.instance.update();

    /// 2. Memory Engine (short-term, long-term, churn)
    MemoryEngine.instance.update();

    /// 3. Emotion Engine (valence, arousal, stability)
    EmotionEngine.instance.update();

    /// 4. Mode Engine (contextual emotional mode)
    ModeEngine.instance.update();

    /// 5. Context Delta Engine (ΔE, ΔS, ΔT, ΔC)
    ContextDeltaEngine.instance.update();

    /// 6. Opportunity Engine (label, score, confidence)
    OpportunityEngine.instance.update();

    /// 7. Opportunity Delta Engine (ΔOpp, ΔConf, volatility)
    OpportunityDeltaEngine.instance.update();

    /// 8. Prediction Engine (future forecasting)
    PredictionEngine.instance.update();

    /// 9. Cognitive Load Engine (strain)
    CognitiveLoadEngine.instance.update();

    /// 10. Cognitive Health Engine (global integrity)
    CognitiveHealthEngine.instance.update();

    /// 11. Cognitive Strain Delta Engine (rate of change)
    CognitiveStrainDeltaEngine.instance.update();

    /// 12. Daily Briefing Engine (narrative synthesis)
    DailyBriefingEngine.instance.update();

    /// 13. Summary Engine (high-level synthesis)
    SummaryEngine.instance.update();

    /// 14. NBA Engine (Next Best Action)
    NbaEngine.instance.update();

    /// Emit unified cognitive pulse
    DeveloperLogger.log("CognitiveEngineOrchestrator → PULSE");
  }
}
