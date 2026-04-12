import 'package:flutter/material.dart';

import '../universal/universal_summary_engine.dart';
import '../universal/next_best_action_engine.dart';
import '../universal/daily_briefing_engine.dart';
import '../universal/ciantis_context.dart';

/// UniversalDashboardScreen
/// -------------------------
/// Displays:
/// - Current Mode
/// - Next Best Action
/// - Daily Briefing
/// - Recommendations
///
/// This is the main "Life OS" dashboard.
class UniversalDashboardScreen extends StatefulWidget {
  const UniversalDashboardScreen({super.key});

  @override
  State<UniversalDashboardScreen> createState() =>
      _UniversalDashboardScreenState();
}

class _UniversalDashboardScreenState extends State<UniversalDashboardScreen> {
  final _context = CiantisContext.instance;
  final _summary = UniversalSummaryEngine.instance;
  final _nba = NextBestActionEngine.instance;
  final _briefing = DailyBriefingEngine.instance;

  String _summaryText = "";
  String _nbaText = "";
  String _briefingText = "";

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _summaryText = _summary.build();
      _nbaText = _nba.compute();
      _briefingText = _briefing.build();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Ciantis Dashboard"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _section("Mode", _context.mode),
          const SizedBox(height: 20),

          _section("Next Best Action", _nbaText),
          const SizedBox(height: 20),

          _section("Daily Briefing", _briefingText),
          const SizedBox(height: 20),

          _section("Full Summary", _summaryText),
        ],
      ),
    );
  }

  Widget _section(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.tealAccent,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white70,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
