import 'package:flutter/animation.dart';
import 'mode_engine.dart';
import 'emotion_engine.dart';
import 'cognitive_load_engine.dart';

/// AmbientMotionEngine
/// --------------------
/// Global motion identity for Ciantis.
/// All animations pull from this engine.
/// Motion adapts to cognitive + emotional state.
class AmbientMotionEngine {
  AmbientMotionEngine._private();
  static final AmbientMotionEngine instance = AmbientMotionEngine._private();

  /// Primary luxury curve
  final Curve luxuryCurve = const Cubic(0.22, 0.61, 0.36, 1);

  /// Soft curve (used for calm states)
  final Curve softCurve = const Cubic(0.25, 0.50, 0.30, 1);

  /// Overshoot curve (used for high‑energy states)
  final Curve overshootCurve = Curves.easeOutBack;

  /// Global durations
  final Duration fast = const Duration(milliseconds: 120);
  final Duration medium = const Duration(milliseconds: 240);
  final Duration luxury = const Duration(milliseconds: 420);
  final Duration reflective = const Duration(milliseconds: 600);

  /// Returns the correct curve based on cognitive + emotional state.
  Curve get adaptiveCurve {
    final mode = ModeEngine.instance.activeMode;
    final emotion = EmotionEngine.instance.primaryEmotion;
    final load = CognitiveLoadEngine.instance.loadScore;

    // High cognitive load → softer, slower motion
    if (load > 0.75) return softCurve;

    // Reflective mode → elongated, smooth motion
    if (mode == "Reflective") return softCurve;

    // High‑energy emotion → overshoot
    if (emotion == "Motivated" || emotion == "Energized") {
      return overshootCurve;
    }

    // Default luxury curve
    return luxuryCurve;
  }

  /// Returns the correct duration based on cognitive + emotional state.
  Duration get adaptiveDuration {
    final mode = ModeEngine.instance.activeMode;
    final load = CognitiveLoadEngine.instance.loadScore;

    if (mode == "Reflective") return reflective;
    if (load > 0.75) return medium;

    return luxury;
  }

  /// Unified animation builder
  AnimationController createController({
    required TickerProvider vsync,
  }) {
    return AnimationController(
      vsync: vsync,
      duration: adaptiveDuration,
    );
  }
}
