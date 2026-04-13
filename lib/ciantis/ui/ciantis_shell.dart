import 'package:flutter/material.dart';
import '../universal/developer_logger.dart';
import '../universal/mode_engine.dart';
import '../universal/emotion_engine.dart';
import '../universal/cognitive_load_engine.dart';
import '../universal/opportunity_engine.dart';
import '../universal/nba_engine.dart';
import '../universal/ambient_motion_engine.dart';
import '../universal/ambient_sound_engine.dart';

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
import 'tasks/tasks_screen.dart';
import 'calendar/calendar_screen.dart';
import 'profile/profile_screen.dart';

import 'global/ciantis_drawer_container.dart';

/// CiantisShell
/// -------------
/// Now includes adaptive luxury screen transitions + sound.
class CiantisShell extends StatefulWidget {
  const CiantisShell({super.key});

  @override
  State<CiantisShell> createState() => _CiantisShellState();
}

class _CiantisShellState extends State<CiantisShell> {
  int _index = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    TasksScreen(),
    CalendarScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("CiantisShell initialized");
  }

  void _onTabTapped(int newIndex) {
    DeveloperLogger.log("CiantisShell: tab changed → index $newIndex");

    // 🔊 Play screen transition sound
    AmbientSoundEngine.instance.screenTransition();

    setState(() => _index = newIndex);
  }

  @override
  Widget build(BuildContext context) {
    final motion = AmbientMotionEngine.instance;

    return CiantisDrawerContainer(
      onOpen: () {
        DeveloperLogger.log("Drawer → Cognitive shift: Reflective Mode");

        ModeEngine.instance.setMode("Reflective");
        EmotionEngine.instance.setEmotion("Calm");
        CognitiveLoadEngine.instance.adjustLoad(-0.05);
        OpportunityEngine.instance.setOpportunity("Navigation");
        NbaEngine.instance.pause();

        // 🔊 Cognitive shift sound
        AmbientSoundEngine.instance.cognitiveShift();
      },

      onClose: () {
        DeveloperLogger.log("Drawer → Cognitive shift: Resume Normal Mode");

        ModeEngine.instance.restorePreviousMode();
        EmotionEngine.instance.stabilize();
        CognitiveLoadEngine.instance.recalculate();
        OpportunityEngine.instance.clear();
        NbaEngine.instance.resume();

        // 🔊 Cognitive shift sound
        AmbientSoundEngine.instance.cognitiveShift();
      },

      onProgress: (value) {
        CognitiveLoadEngine.instance.adjustLoad(value * -0.01);
        EmotionEngine.instance.smooth(value);
      },

      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.black,

            appBar: AppBar(
              title: const Text("Ciantis"),
              backgroundColor: Colors.black,

              leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      DeveloperLogger.log("CiantisShell → Drawer opened");
                      CiantisDrawerContainer.of(context).open();
                    },
                  );
                },
              ),

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

                /// Adaptive luxury screen transitions
                Expanded(
                  child: AnimatedSwitcher(
                    duration: motion.adaptiveDuration,
                    switchInCurve: motion.adaptiveCurve,
                    switchOutCurve: motion.adaptiveCurve,
                    transitionBuilder: (child, animation) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(0.04, 0),
                        end: Offset.zero,
                      ).animate(animation);

                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: KeyedSubtree(
                      key: ValueKey(_index),
                      child: _screens[_index],
                    ),
                  ),
                ),
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
      ),
    );
  }
}
