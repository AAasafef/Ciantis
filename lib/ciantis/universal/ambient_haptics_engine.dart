import 'package:flutter/services.dart';
import 'emotion_engine.dart';
import 'mode_engine.dart';
import 'cognitive_load_engine.dart';

/// AmbientHapticsEngine
/// ---------------------
/// Provides:
/// - Luxury subtle haptic feedback
/// - Emotion-aware intensity
/// - Mode-aware softness
/// - Cognitive-aware suppression
///
/// NOTE: This engine does not vibrate aggressively.
/// It uses extremely soft, premium-style taps.
class AmbientHapticsEngine {
  AmbientHapticsEngine._private();
  static final AmbientHapticsEngine instance = AmbientHapticsEngine._private();

  /// Computes the intensity of the haptic feedback
  /// based on emotional + cognitive state.
  double get _intensity {
    final emotion = EmotionEngine.instance.primaryEmotion;
    final load = CognitiveLoadEngine.instance.loadScore;
    final mode = ModeEngine.instance.currentMode;

    double value = 1.0;

    // Calm → softer
    if (emotion == "Calm") value *= 0.7;

    // Energized → slightly stronger
    if (emotion == "Energized") value *= 1.15;

    // Reflective mode → very soft
    if (mode == "Reflective") value *= 0.6;

    // High cognitive load → reduce intensity
    if (load > 0.75) value *= 0.5;

    return value.clamp(0.2, 1.0);
  }

  /// Soft tap (default)
  Future<void> softTap() async {
    final strength = _intensity;

    if (strength < 0.4) {
      HapticFeedback.selectionClick();
    } else {
      HapticFeedback.lightImpact();
    }
  }

  /// Medium tap (for confirmations)
  Future<void> mediumTap() async {
    final strength = _intensity;

    if (strength < 0.5) {
      HapticFeedback.selectionClick();
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  /// Gentle pulse (for cognitive shifts)
  Future<void> pulse() async {
    final strength = _intensity;

    if (strength < 0.5) {
      HapticFeedback.selectionClick();
    } else {
      HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 30));
      HapticFeedback.selectionClick();
    }
  }
}
