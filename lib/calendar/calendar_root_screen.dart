import 'package:flutter/material.dart';

import 'calendar_shell.dart';
import 'analytics/calendar_insights_orchestrator.dart';
import 'insights/insights_panel_engine.dart';
import 'insights/insights_panel_model.dart';
import 'insights/insights_panel_widget.dart';

/// CalendarRootScreen is the final, top-level calendar screen.
///
/// It integrates:
/// - CalendarShell (Day/Week/Month)
/// - Insights Panel
/// - CalendarInsightsOrchestrator
///
/// This is the screen the user actually sees in Ciantis.
class CalendarRootScreen extends StatefulWidget {
  const CalendarRootScreen({super.key});

  @override
  State<CalendarRootScreen> createState() => _CalendarRootScreenState();
}

class _CalendarRootScreenState extends State<CalendarRootScreen> {
  @override
  void initState() {
    super.initState();
    CalendarInsightsOrchestrator.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CalendarInsightsOrchestrator.instance,
      builder: (context, _) {
        final panelModel = _buildPanelModel();

        return Column(
          children: [
            // -----------------------------
            // INSIGHTS PANEL
            // -----------------------------
            if (panelModel.cards.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: InsightsPanelWidget(model: panelModel),
              ),

            const SizedBox(height: 10),

            // -----------------------------
            // CALENDAR SHELL
            // -----------------------------
            const Expanded(
              child: CalendarShell(),
            ),
          ],
        );
      },
    );
  }

  // -----------------------------
  // BUILD PANEL MODEL
  // -----------------------------
  InsightsPanelUIModel _buildPanelModel() {
    final engine = InsightsPanelEngine.instance;
    final panel = engine.buildPanel();

    return InsightsPanelUIModel(
      cards: [
        InsightsPanelCardUI(
          title: panel.dailyCard.title,
          subtitle: panel.dailyCard.subtitle,
          value: panel.dailyCard.value,
          color: panel.dailyCard.color,
          icon: "flame",
          emphasize: panel.dailyCard.color == "warning",
        ),
        InsightsPanelCardUI(
          title: panel.weeklyCard.title,
          subtitle: panel.weeklyCard.subtitle,
          value: panel.weeklyCard.value,
          color: panel.weeklyCard.color,
          icon: "balance",
        ),
        InsightsPanelCardUI(
          title: panel.predictiveCard.title,
          subtitle: panel.predictiveCard.subtitle,
          value: panel.predictiveCard.value,
          color: panel.predictiveCard.color,
          icon: "forecast",
        ),
        InsightsPanelCardUI(
          title: panel.patternsCard.title,
          subtitle: panel.patternsCard.subtitle,
          value: panel.patternsCard.value,
          color: panel.patternsCard.color,
          icon: "pattern",
        ),
      ],
    );
  }
}
