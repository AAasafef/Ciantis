import 'package:flutter/material.dart';
import '../../engine/mode_engine.dart';
import '../widgets/mode_suggestion_card.dart';

/// ModeDashboardScreen displays:
/// - Active mode
/// - Daily suggestion card
/// - Reason + insight
/// - Behavioral adjustments
/// - Secondary modes
///
/// This is the main UI for the Mode Engine.
class ModeDashboardScreen extends StatefulWidget {
  const ModeDashboardScreen({super.key});

  @override
  State<ModeDashboardScreen> createState() => _ModeDashboardScreenState();
}

class _ModeDashboardScreenState extends State<ModeDashboardScreen> {
  final _modeEngine = ModeEngine.instance;

  @override
  void initState() {
    super.initState();
    _modeEngine.initializeForToday(DateTime.now());
    _modeEngine.addListener(_onModeUpdate);
  }

  @override
  void dispose() {
    _modeEngine.removeListener(_onModeUpdate);
    super.dispose();
  }

  void _onModeUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final suggestion = _modeEngine.currentSuggestion;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Mode Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: suggestion == null
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _activeModeHeader(),
                  const SizedBox(height: 20),
                  ModeSuggestionCard(model: suggestion),
                  const SizedBox(height: 30),
                  _modeActions(),
                ],
              ),
            ),
    );
  }

  // -----------------------------
  // ACTIVE MODE HEADER
  // -----------------------------
  Widget _activeModeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Current Mode",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _modeEngine.activeMode.replaceAll("_", " ").toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // -----------------------------
  // MODE ACTION BUTTONS
  // -----------------------------
  Widget _modeActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: [
            _actionButton("FOCUS", "focus"),
            _actionButton("RECOVERY", "recovery"),
            _actionButton("CALM", "calm"),
            _actionButton("NIGHT GODDESS", "night_goddess"),
            _actionButton("OVERLOAD", "overload_protection"),
          ],
        ),
      ],
    );
  }

  Widget _actionButton(String label, String modeId) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white12,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      onPressed: () {
        _modeEngine.overrideMode(modeId);
      },
      child: Text(label),
    );
  }
}
