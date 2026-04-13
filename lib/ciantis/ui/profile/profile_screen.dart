import 'package:flutter/material.dart';
import '../../universal/developer_logger.dart';
import '../../universal/cognitive_load_engine.dart';
import '../../universal/cognitive_health_engine.dart';
import '../../universal/mode_engine.dart';
import '../../universal/emotion_engine.dart';
import '../../universal/nba_engine.dart';
import '../../universal/opportunity_engine.dart';
import '../../universal/prediction_engine.dart';

/// ProfileScreen
/// --------------
/// Luxury identity + system state overview.
/// Calm, elegant, cognitive-aware.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double _load = 0.0;
  double _health = 0.0;
  String _mode = "";
  String _emotion = "";
  String _nba = "";
  String _opp = "";
  String _pred = "";

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("ProfileScreen initialized");

    _update();

    CognitiveLoadEngine.instance.addListener(_update);
    CognitiveHealthEngine.instance.addListener(_update);
    ModeEngine.instance.addListener(_update);
    EmotionEngine.instance.addListener(_update);
    NbaEngine.instance.addListener(_update);
    OpportunityEngine.instance.addListener(_update);
    PredictionEngine.instance.addListener(_update);
  }

  @override
  void dispose() {
    CognitiveLoadEngine.instance.removeListener(_update);
    CognitiveHealthEngine.instance.removeListener(_update);
    ModeEngine.instance.removeListener(_update);
    EmotionEngine.instance.removeListener(_update);
    NbaEngine.instance.removeListener(_update);
    OpportunityEngine.instance.removeListener(_update);
    PredictionEngine.instance.removeListener(_update);
    super.dispose();
  }

  void _update() {
    setState(() {
      _load = CognitiveLoadEngine.instance.loadScore;
      _health = CognitiveHealthEngine.instance.healthScore;
      _mode = ModeEngine.instance.activeMode;
      _emotion = EmotionEngine.instance.primaryEmotion;
      _nba = NbaEngine.instance.currentActionLabel;
      _opp = OpportunityEngine.instance.opportunityLabel;
      _pred = PredictionEngine.instance.predictionLabel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: Stack(
        children: [
          /// Subtle marble background
          Positioned.fill(
            child: Opacity(
              opacity: 0.12,
              child: Image.asset(
                "assets/backgrounds/marble_dark.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Luxury header
                  Text(
                    "Profile",
                    style: const TextStyle(
                      fontFamily: "AngleEstarossa",
                      fontSize: 34,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Your system, refined.",
                    style: TextStyle(
                      fontFamily: "Bourton",
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.65),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// Identity capsule
                  _buildIdentityCapsule(),

                  const SizedBox(height: 22),

                  /// Cognitive engine summary
                  _buildCognitiveSummary(),

                  const SizedBox(height: 22),

                  /// System state overview
                  _buildSystemState(),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityCapsule() {
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
      child: Row(
        children: [
          /// Avatar circle
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.12),
            ),
            child: const Icon(Icons.person, color: Colors.white70, size: 28),
          ),

          const SizedBox(width: 16),

          /// Name + role
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Shaverian",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Ciantis Owner",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCognitiveSummary() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _summaryRow("Cognitive Load", _load.toStringAsFixed(2)),
          const SizedBox(height: 8),
          _summaryRow("Cognitive Health", _health.toStringAsFixed(2)),
          const SizedBox(height: 8),
          _summaryRow("Mode", _mode),
          const SizedBox(height: 8),
          _summaryRow("Emotion", _emotion),
        ],
      ),
    );
  }

  Widget _buildSystemState() {
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
          _summaryRow("Next Best Action", _nba),
          const SizedBox(height: 8),
          _summaryRow("Opportunity", _opp),
          const SizedBox(height: 8),
          _summaryRow("Prediction", _pred),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.55),
          ),
        ),
        Text(
          value.isEmpty ? "—" : value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
