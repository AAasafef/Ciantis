import 'package:flutter/material.dart';
import '../../universal/developer_logger.dart';
import '../../universal/nba_engine.dart';
import '../../universal/mode_engine.dart';
import '../../universal/emotion_engine.dart';

/// HomeScreen
/// -----------
/// First user-facing screen of Ciantis.
/// Luxury, calm, neoclassic, intelligent.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _greeting = "";
  String _nba = "";
  String _mode = "";
  String _emotion = "";

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("HomeScreen initialized");

    _update();
    NbaEngine.instance.addListener(_update);
    ModeEngine.instance.addListener(_update);
    EmotionEngine.instance.addListener(_update);
  }

  @override
  void dispose() {
    NbaEngine.instance.removeListener(_update);
    ModeEngine.instance.removeListener(_update);
    EmotionEngine.instance.removeListener(_update);
    super.dispose();
  }

  void _update() {
    setState(() {
      _greeting = _generateGreeting();
      _nba = NbaEngine.instance.currentActionLabel;
      _mode = ModeEngine.instance.activeMode;
      _emotion = EmotionEngine.instance.primaryEmotion;
    });
  }

  String _generateGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: Stack(
        children: [
          /// Subtle parallax background
          Positioned.fill(
            child: Opacity(
              opacity: 0.12,
              child: Image.asset(
                "assets/backgrounds/marble_dark.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Luxury greeting
                  Text(
                    _greeting,
                    style: const TextStyle(
                      fontFamily: "AngleEstarossa",
                      fontSize: 34,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Here’s your day, refined.",
                    style: TextStyle(
                      fontFamily: "Bourton",
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.65),
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// Today Capsule
                  _buildTodayCapsule(),

                  const SizedBox(height: 22),

                  /// Next Best Action Tile
                  _buildNbaTile(),

                  const SizedBox(height: 22),

                  /// Mood + Mode micro indicator
                  _buildMoodModeRow(),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayCapsule() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today",
            style: TextStyle(
              fontFamily: "Bourton",
              fontSize: 18,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Your cognitive engine is active and aligned.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.55),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNbaTile() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.tealAccent.withOpacity(0.35),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, color: Colors.tealAccent.withOpacity(0.85)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _nba.isEmpty ? "Calculating your next best action…" : _nba,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodModeRow() {
    return Row(
      children: [
        _buildMicroCard("Mood", _emotion),
        const SizedBox(width: 12),
        _buildMicroCard("Mode", _mode),
      ],
    );
  }

  Widget _buildMicroCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.55),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value.isEmpty ? "—" : value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
