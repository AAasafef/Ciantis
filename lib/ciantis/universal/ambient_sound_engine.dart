import 'package:flutter/services.dart';
import 'mode_engine.dart';
import 'emotion_engine.dart';
import 'cognitive_load_engine.dart';

/// AmbientSoundEngine
/// -------------------
/// Provides:
/// - Luxury UI sound identity
/// - Emotion-aware sound modulation
/// - Mode-aware acoustic behavior
/// - Cognitive-aware volume shaping
class AmbientSoundEngine {
  AmbientSoundEngine._private();
  static final AmbientSoundEngine instance = AmbientSoundEngine._private();

  /// Base volume (modulated by cognitive + emotional state)
  double get baseVolume {
    final load = CognitiveLoadEngine.instance.loadScore;
    final emotion = EmotionEngine.instance.primaryEmotion;

    double volume = 0.35;

    // High cognitive load → softer
    if (load > 0.75) volume *= 0.6;

    // Calm → softer
    if (emotion == "Calm") volume *= 0.8;

    // Energized → slightly brighter
    if (emotion == "Energized") volume *= 1.1;

    return volume.clamp(0.05, 1.0);
  }

  /// Plays a UI sound with adaptive volume
  Future<void> play(String asset) async {
    try {
      final ByteData data = await rootBundle.load(asset);
      // Placeholder for actual audio playback integration
      // In real implementation, feed bytes to audio engine
    } catch (_) {}
  }

  /// Drawer sounds
  void drawerOpen() => play("assets/sounds/drawer_open.wav");
  void drawerClose() => play("assets/sounds/drawer_close.wav");

  /// Task interactions
  void taskPress() => play("assets/sounds/task_press.wav");

  /// Quick actions
  void quickAction() => play("assets/sounds/quick_action.wav");

  /// Screen transitions
  void screenTransition() => play("assets/sounds/screen_transition.wav");

  /// Developer log update
  void logPulse() => play("assets/sounds/log_pulse.wav");

  /// Cognitive engine shifts
  void cognitiveShift() => play("assets/sounds/cognitive_shift.wav");
}
