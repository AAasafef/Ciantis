import 'package:flutter/material.dart';
import '../../universal/mode_engine.dart';
import '../../universal/emotion_engine.dart';
import '../../universal/cognitive_load_engine.dart';
import '../../universal/developer_logger.dart';

/// CiantisDrawer
/// --------------
/// Luxury global navigation drawer.
/// Marble, gold, calm, elegant, cognitive-aware.
class CiantisDrawer extends StatefulWidget {
  const CiantisDrawer({super.key});

  @override
  State<CiantisDrawer> createState() => _CiantisDrawerState();
}

class _CiantisDrawerState extends State<CiantisDrawer> {
  String _mode = "";
  String _emotion = "";
  double _load = 0.0;

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("CiantisDrawer initialized");

    _update();
    ModeEngine.instance.addListener(_update);
    EmotionEngine.instance.addListener(_update);
    CognitiveLoadEngine.instance.addListener(_update);
  }

  @override
  void dispose() {
    ModeEngine.instance.removeListener(_update);
    EmotionEngine.instance.removeListener(_update);
    CognitiveLoadEngine.instance.removeListener(_update);
    super.dispose();
  }

  void _update() {
    setState(() {
      _mode = ModeEngine.instance.activeMode;
      _emotion = EmotionEngine.instance.primaryEmotion;
      _load = CognitiveLoadEngine.instance.loadScore;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          /// Marble background
          Positioned.fill(
            child: Opacity(
              opacity: 0.18,
              child: Image.asset(
                "assets/backgrounds/marble_dark.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// Drawer content
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.65),
              border: const Border(
                right: BorderSide(
                  color: Color(0xFFBFA76F), // brushed gold
                  width: 1.4,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Profile capsule
                _buildProfileCapsule(),

                const SizedBox(height: 32),

                /// Navigation links
                _buildNavItem(
                  icon: Icons.home,
                  label: "Home",
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 18),

                _buildNavItem(
                  icon: Icons.check_circle,
                  label: "Tasks",
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 18),

                _buildNavItem(
                  icon: Icons.calendar_month,
                  label: "Calendar",
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 18),

                _buildNavItem(
                  icon: Icons.person,
                  label: "Profile",
                  onTap: () => Navigator.pop(context),
                ),

                const SizedBox(height: 40),

                /// System snapshot
                _buildSystemSnapshot(),

                const Spacer(),

                /// Footer
                Text(
                  "Ciantis OS",
                  style: TextStyle(
                    fontFamily: "Bourton",
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCapsule() {
    return Row(
      children: [
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
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.85), size: 22),
          const SizedBox(width: 14),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemSnapshot() {
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
          _snapshotRow("Mode", _mode),
          const SizedBox(height: 8),
          _snapshotRow("Emotion", _emotion),
          const SizedBox(height: 8),
          _snapshotRow("Cognitive Load", _load.toStringAsFixed(2)),
        ],
      ),
    );
  }

  Widget _snapshotRow(String label, String value) {
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
