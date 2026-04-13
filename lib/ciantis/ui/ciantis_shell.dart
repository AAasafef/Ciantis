import 'package:flutter/material.dart';
import '../universal/developer_logger.dart';
import 'developer_menu_screen.dart';
import 'developer_log_overlay.dart';
import 'developer_orchestrator_panel.dart';
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
import 'developer_mode_panel.dart';
import 'developer_opportunity_delta_panel.dart';
import 'developer_prediction_panel.dart';
import 'developer_cognitive_load_panel.dart';
import 'developer_cognitive_health_panel.dart';
import 'developer_cognitive_strain_delta_panel.dart';
import 'home/home_screen.dart';

/// CiantisShell
/// -------------
/// Main navigation container for the entire app.
/// Home tab now loads the real HomeScreen.
class CiantisShell extends StatefulWidget {
  const CiantisShell({super.key});

  @override
  State<CiantisShell> createState() => _CiantisShellState();
}

class _CiantisShellState extends State<CiantisShell> {
  int _index = 0;

  final List<Widget> _screens = const [
    HomeScreen(),                     // ← NEW: Real Home Screen
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
              const DeveloperOrchestratorPanel(),
              const DeveloperStatusBar(),
              const DeveloperReasoningStrip(),
              const DeveloperContextDelta(),
              const DeveloperOpportunityPanel(),
              const DeveloperNbaPanel(),
              const DeveloperDailyBriefingPanel(),
              const DeveloperSummaryPanel(),
              const DeveloperSystemLoadPanel(),
              const DeveloperMemoryPanel(),
              const DeveloperEmotionPanel(),
              const DeveloperModePanel(),
              const DeveloperOpportunityDeltaPanel(),
              const DeveloperPredictionPanel(),
              const DeveloperCognitiveLoadPanel(),
              const DeveloperCognitiveHealthPanel(),
              const DeveloperCognitiveStrainDeltaPanel(),

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
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: "Tasks"),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Calendar"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            ],
          ),
        ),

        const DeveloperLogOverlay(),
      ],
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    DeveloperLogger.log("Opened Placeholder Screen → $title");

    return Center(
      child: Text(
        title,
        style: const TextStyle(color: Colors.white70, fontSize: 22),
      ),
    );
  }
}
