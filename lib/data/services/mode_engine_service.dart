import 'package:flutter/material.dart';
import '../models/mode_model.dart';
import '../repositories/mode_repository.dart';

class ModeEngineService extends ChangeNotifier {
  final ModeRepository _repository = ModeRepository();

  ModeModel? _currentMode;
  ModeModel? get currentMode => _currentMode;

  ModeModel? _currentSuggestion;
  ModeModel? get currentSuggestion => _currentSuggestion;

  // -----------------------------
  // AVAILABLE MODES
  // -----------------------------
  final List<ModeModel> _modes = [
    ModeModel(
      id: 'calm',
      name: 'Calm Mode',
      description: 'Soft UI, reduced stimulation, grounding energy.',
      theme: 'calm',
      reduceNotifications: true,
      softenUI: true,
      highlightFocusAreas: false,
      emotionalThreshold: 10,
      fatigueThreshold: 10,
    ),
    ModeModel(
      id: 'focus',
      name: 'Focus Mode',
      description: 'Minimal UI, deep work, distraction-free.',
      theme: 'focus',
      reduceNotifications: true,
      softenUI: false,
      highlightFocusAreas: true,
      emotionalThreshold: 5,
      fatigueThreshold: 5,
    ),
    ModeModel(
      id: 'recovery',
      name: 'Recovery Mode',
      description: 'Rest, softness, emotional decompression.',
      theme: 'recovery',
      reduceNotifications: true,
      softenUI: true,
      highlightFocusAreas: false,
      emotionalThreshold: 20,
      fatigueThreshold: 20,
    ),
    ModeModel(
      id: 'night',
      name: 'Night Goddess Mode',
      description: 'Warm, feminine, low-light UI for evenings.',
      theme: 'night',
      reduceNotifications: true,
      softenUI: true,
      highlightFocusAreas: false,
      emotionalThreshold: 15,
      fatigueThreshold: 15,
    ),
    ModeModel(
      id: 'overload',
      name: 'Overload Protection Mode',
      description: 'Blocks heavy scheduling, protects your energy.',
      theme: 'overload',
      reduceNotifications: true,
      softenUI: true,
      highlightFocusAreas: false,
      emotionalThreshold: 25,
      fatigueThreshold: 25,
    ),
  ];

  // -----------------------------
  // LOAD CURRENT MODE
  // -----------------------------
  Future<void> loadMode() async {
    final saved = await _repository.getCurrentMode();
    if (saved != null) {
      _currentMode = _modes.firstWhere((m) => m.id == saved);
    }
    notifyListeners();
  }

  // -----------------------------
  // SET MODE (USER APPROVED)
  // -----------------------------
  Future<void> setMode(String modeId) async {
    _currentMode = _modes.firstWhere((m) => m.id == modeId);
    _currentSuggestion = null;
    await _repository.saveCurrentMode(modeId);
    notifyListeners();
  }

  // -----------------------------
  // SET SUGGESTION (TRIGGER UI)
  // -----------------------------
  void setSuggestion(ModeModel? suggestion) {
    _currentSuggestion = suggestion;
    notifyListeners();
  }

  // -----------------------------
  // SEMI-AUTOMATIC SUGGESTION ENGINE
  // -----------------------------
  ModeModel? evaluateModeSuggestion({
    required int emotionalLoad,
    required int fatigue,
    required bool isNight,
  }) {
    if (isNight && fatigue > 15) {
      return _modes.firstWhere((m) => m.id == 'night');
    }

    if (emotionalLoad > 25 || fatigue > 25) {
      return _modes.firstWhere((m) => m.id == 'overload');
    }

    if (emotionalLoad > 20 || fatigue > 20) {
      return _modes.firstWhere((m) => m.id == 'recovery');
    }

    if (emotionalLoad < 8 && fatigue < 8) {
      return _modes.firstWhere((m) => m.id == 'focus');
    }

    if (emotionalLoad > 10 || fatigue > 10) {
      return _modes.firstWhere((m) => m.id == 'calm');
    }

    return null;
  }
}
