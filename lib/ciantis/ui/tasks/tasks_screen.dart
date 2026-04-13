import 'package:flutter/material.dart';
import '../../universal/developer_logger.dart';
import '../../universal/nba_engine.dart';
import '../../universal/mode_engine.dart';
import '../../universal/emotion_engine.dart';

/// TasksScreen
/// ------------
/// Luxury task management surface.
/// Calm, elegant, cognitive-aware.
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _suggestion = "";
  String _mode = "";
  String _emotion = "";

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("TasksScreen initialized");

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
      _suggestion = NbaEngine.instance.currentActionLabel;
      _mode = ModeEngine.instance.activeMode;
      _emotion = EmotionEngine.instance.primaryEmotion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Luxury header
              Text(
                "Tasks",
                style: const TextStyle(
                  fontFamily: "AngleEstarossa",
                  fontSize: 34,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "Your priorities, refined.",
                style: TextStyle(
                  fontFamily: "Bourton",
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.65),
                ),
              ),

              const SizedBox(height: 28),

              /// Cognitive-aware suggestion
              _buildSuggestionTile(),

              const SizedBox(height: 28),

              /// Task list (static v1)
              Expanded(
                child: ListView(
                  children: [
                    _buildTaskCapsule(
                      title: "Review LPN study notes",
                      priority: "High",
                    ),
                    const SizedBox(height: 14),
                    _buildTaskCapsule(
                      title: "Prep salon kit for next client",
                      priority: "Medium",
                    ),
                    const SizedBox(height: 14),
                    _buildTaskCapsule(
                      title: "Update Ciantis motion specs",
                      priority: "Critical",
                    ),
                    const SizedBox(height: 14),
                    _buildTaskCapsule(
                      title: "Plan kids’ weekly schedule",
                      priority: "Low",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionTile() {
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
              _suggestion.isEmpty
                  ? "Ciantis is analyzing your cognitive state…"
                  : _suggestion,
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

  Widget _buildTaskCapsule({
    required String title,
    required String priority,
  }) {
    final color = _priorityColor(priority);

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
          /// Priority ribbon
          Container(
            width: 6,
            height: 42,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          const SizedBox(width: 14),

          /// Task title
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),

          /// Priority label
          Text(
            priority,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Color _priorityColor(String p) {
    switch (p) {
      case "Critical":
        return Colors.redAccent;
      case "High":
        return Colors.orangeAccent;
      case "Medium":
        return Colors.yellowAccent;
      default:
        return Colors.greenAccent;
    }
  }
}
