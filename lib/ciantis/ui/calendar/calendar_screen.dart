import 'package:flutter/material.dart';
import '../../universal/developer_logger.dart';
import '../../universal/cognitive_load_engine.dart';
import '../../universal/prediction_engine.dart';

/// CalendarScreen
/// ---------------
/// Luxury vertical timeline calendar.
/// Calm, elegant, cognitive-aware.
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  String _insight = "";

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("CalendarScreen initialized");

    _update();
    CognitiveLoadEngine.instance.addListener(_update);
    PredictionEngine.instance.addListener(_update);
  }

  @override
  void dispose() {
    CognitiveLoadEngine.instance.removeListener(_update);
    PredictionEngine.instance.removeListener(_update);
    super.dispose();
  }

  void _update() {
    final load = CognitiveLoadEngine.instance.loadScore;
    final pred = PredictionEngine.instance.predictionLabel;

    setState(() {
      if (load > 0.7) {
        _insight = "Your afternoon may feel heavy — consider pacing yourself.";
      } else if (pred.contains("busy")) {
        _insight = "A high-activity window is predicted later today.";
      } else {
        _insight = "Your day looks balanced and manageable.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: Stack(
        children: [
          /// Subtle parallax marble background
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
                    "Calendar",
                    style: const TextStyle(
                      fontFamily: "AngleEstarossa",
                      fontSize: 34,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Your time, refined.",
                    style: TextStyle(
                      fontFamily: "Bourton",
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.65),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// Cognitive-aware insight
                  _buildInsightTile(),

                  const SizedBox(height: 28),

                  /// Vertical timeline
                  Expanded(
                    child: ListView(
                      children: [
                        _buildTimelineEvent(
                          time: "8:00 AM",
                          title: "Morning prep",
                          color: Colors.greenAccent,
                        ),
                        _buildDivider(),
                        _buildTimelineEvent(
                          time: "10:00 AM",
                          title: "Study session — LPN coursework",
                          color: Colors.tealAccent,
                        ),
                        _buildDivider(),
                        _buildTimelineEvent(
                          time: "1:00 PM",
                          title: "Salon client — color + style",
                          color: Colors.orangeAccent,
                        ),
                        _buildDivider(),
                        _buildTimelineEvent(
                          time: "3:30 PM",
                          title: "Ciantis development — motion specs",
                          color: Colors.purpleAccent,
                        ),
                        _buildDivider(),
                        _buildTimelineEvent(
                          time: "6:00 PM",
                          title: "Kids’ evening routine",
                          color: Colors.yellowAccent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightTile() {
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
              _insight,
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

  Widget _buildTimelineEvent({
    required String time,
    required String title,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Time label
        SizedBox(
          width: 70,
          child: Text(
            time,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.55),
            ),
          ),
        ),

        /// Timeline dot
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 16),

        /// Event capsule
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 22),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 1.2,
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 28,
      width: 2,
      margin: const EdgeInsets.only(left: 70 + 5),
      color: Colors.white.withOpacity(0.08),
    );
  }
}
