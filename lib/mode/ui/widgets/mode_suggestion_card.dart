import 'package:flutter/material.dart';
import '../mode_suggestion_ui_mapper.dart';

/// A beautiful, jewel-tone Mode Suggestion Card.
///
/// This widget displays:
/// - Primary recommended mode
/// - Secondary modes
/// - Reason
/// - Insight
/// - Behavioral cues (soften notifications, reduce interruptions, etc.)
///
/// It is UI-only and receives a ModeSuggestionUiModel.
class ModeSuggestionCard extends StatelessWidget {
  final ModeSuggestionUiModel model;

  const ModeSuggestionCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: _gradientForMode(model.primaryMode),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 12),
          _reason(),
          const SizedBox(height: 12),
          _insight(),
          const SizedBox(height: 16),
          _behavioralCues(),
          const SizedBox(height: 16),
          _secondaryModes(),
        ],
      ),
    );
  }

  // -----------------------------
  // HEADER (Primary Mode)
  // -----------------------------
  Widget _header() {
    return Text(
      "Recommended Mode: ${_formatMode(model.primaryMode)}",
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }

  // -----------------------------
  // REASON
  // -----------------------------
  Widget _reason() {
    return Text(
      model.reason,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white70,
      ),
    );
  }

  // -----------------------------
  // INSIGHT
  // -----------------------------
  Widget _insight() {
    return Text(
      model.insight,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.white70,
      ),
    );
  }

  // -----------------------------
  // BEHAVIORAL CUES
  // -----------------------------
  Widget _behavioralCues() {
    final cues = <String>[];

    if (model.softenNotifications) cues.add("Soften notifications");
    if (model.reduceInterruptions) cues.add("Reduce interruptions");
    if (model.boostFocusMode) cues.add("Boost Focus Mode");
    if (model.boostRecoveryMode) cues.add("Boost Recovery Mode");
    if (model.activateOverloadProtection) cues.add("Activate Overload Protection");

    if (cues.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Behavioral Adjustments:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        ...cues.map(
          (c) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              "• $c",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white70,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // -----------------------------
  // SECONDARY MODES
  // -----------------------------
  Widget _secondaryModes() {
    if (model.secondaryModes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Secondary Modes:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          children: model.secondaryModes
              .map(
                (m) => Chip(
                  label: Text(
                    _formatMode(m),
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.white.withOpacity(0.15),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  // -----------------------------
  // HELPERS
  // -----------------------------
  List<Color> _gradientForMode(String mode) {
    switch (mode) {
      case "focus":
        return [Colors.deepPurple, Colors.indigo];
      case "recovery":
        return [Colors.teal, Colors.green];
      case "night_goddess":
        return [Colors.pinkAccent, Colors.deepPurpleAccent];
      case "overload_protection":
        return [Colors.redAccent, Colors.orange];
      case "calm":
        return [Colors.blueGrey, Colors.lightBlueAccent];
      default:
        return [Colors.blue, Colors.purpleAccent];
    }
  }

  String _formatMode(String mode) {
    return mode.replaceAll("_", " ").toUpperCase();
  }
}
