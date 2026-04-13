import 'package:flutter/material.dart';
import '../universal/developer_logger.dart';
import 'developer_menu_screen.dart';
import 'developer_log_overlay.dart';
import 'developer_status_bar.dart';
import 'developer_reasoning_strip.dart';
import 'developer_context_delta.dart';
import 'developer_opportunity_panel.dart';
import 'developer_nba_panel.dart';
import 'developer_daily_briefing_panel.dart';
import 'developer_summary_panel.dart';
import 'developer_system_load_panel.dart';
import 'developer_memory_panel.dart';
import 'developer_emotion_panel.dart';

/// CiantisShell
/// -------------
/// The main navigation container for the entire app.
/// Handles:
/// - Bottom navigation
/// - Screen switching
/// - Developer menu access
/// - Developer log overlay
/// - Developer status bar (HUD)
/// - Developer reasoning strip (AI thought ribbon)
/// - Developer context delta panel (ΔE, ΔS, ΔT, ΔC)
/// - Developer opportunity panel (Opportunity Label, Score, Confidence)
/// - Developer NBA panel (Next Best Action)
/// - Developer Daily Briefing panel (Narrative Summary)
/// - Developer Summary panel (High-level synthesis)
/// - Developer System Load panel (Performance metrics)
/// - Developer Memory panel (Memory stability)
/// - Developer Emotion panel (Emotional inference)
class CiantisShell extends StatefulWidget {
  const CiantisShell({super.key});

  @override
  State<CiantisShell> createState() => _CiantisShellState();
}

class _CiantisShellState extends State<CiantisShell> {
  int _index = 0;

  final List<Widget> _screens = const [
    PlaceholderScreen(title: "Home"),
    PlaceholderScreen(title: "Tasks"),
    PlaceholderScreen(title: "Calendar"),
    PlaceholderScreen(title: "Profile"),
  ];

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("CiantisShell initialized");
  }

  void _onTabTapped(int newIndex) {
    DeveloperLogger.log("CiantisShell: tab changed → index $newIndex");
    setState(() => _index = newIndex);
  }

  @override
  Widget build(BuildContext context) {
    DeveloperLogger.log("CiantisShell build triggered (index=$_index)");

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const Text("Ciantis"),
            backgroundColor: Colors.black,
            actions: [
              IconButton(
                icon: const Icon(Icons.developer_mode),
                onPressed: () {
                  DeveloperLogger.log("CiantisShell → Developer Menu opened");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DeveloperMenuScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              /// Developer HUD (real‑time system status)
              const DeveloperStatusBar(),

              /// Developer Explainability Strip (AI reasoning ribbon)
              const DeveloperReasoningStrip(),

              /// Developer Context Delta Panel (ΔE, ΔS, ΔT, ΔC)
              const DeveloperContextDelta(),

              /// Developer Opportunity Panel (Opportunity Label, Score, Confidence)
              const DeveloperOpportunityPanel(),

              /// Developer NBA Panel (Next Best Action)
              const DeveloperNbaPanel(),

              /// Developer Daily Briefing Panel (Narrative Summary)
              const DeveloperDailyBriefingPanel(),

              /// Developer Summary Panel (High-level synthesis)
              const DeveloperSummaryPanel(),

              /// Developer System Load Panel (Performance metrics)
              const DeveloperSystemLoadPanel(),

              /// Developer Memory Panel (Memory stability)
              const DeveloperMemoryPanel(),

              /// Developer Emotion Panel (Emotional inference)
              const DeveloperEmotionPanel(),

              /// Main screen content
              Expanded(child: _screens[_index]),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.tealAccent,
            unselectedItemColor: Colors.white38,
            currentIndex: _index,
            onTap: _onTabTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle),
                label: "Tasks",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: "Calendar",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
        ),

        /// Developer Log Overlay (floating live console)
        const DeveloperLogOverlay(),
      ],
    );
  }
}

/// PlaceholderScreen
/// ------------------
/// Temporary screen used until full modules are built.
/// Logs when opened.
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    DeveloperLogger.log("Opened Placeholder Screen → $title");

    return Center(
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 22,
        ),
      ),
    );
  }
}
