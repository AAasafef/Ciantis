import 'package:flutter/foundation.dart';

import '../analytics/calendar_insights_orchestrator.dart';
import '../analytics/calendar_insights_model.dart';

/// InsightsPanelEngine converts raw CalendarInsights into
/// UI-ready display models for the Insights Panel.
///
/// It:
/// - Formats daily load
/// - Formats weekly balance
/// - Formats predictive insights
/// - Generates highlight colors
/// - Produces short + long summaries
class InsightsPanelEngine {
  // Singleton
  static final InsightsPanelEngine instance =
      InsightsPanelEngine._internal();
  InsightsPanelEngine._internal();

  final _orchestrator = CalendarInsightsOrchestrator.instance;

  // -----------------------------
  // BUILD PANEL MODEL
  // -----------------------------
  InsightsPanelModel buildPanel() {
    final insights = _orchestrator.latest;

    if (insights == null) {
      return const InsightsPanelModel.empty();
    }

    return InsightsPanelModel(
      dailyCard: _buildDailyCard(insights.daily),
      weeklyCard: _buildWeeklyCard(insights.weekly),
      predictiveCard: _buildPredictiveCard(insights.predictive),
      patternsCard: _buildPatternsCard(insights.patterns),
    );
  }

  // -----------------------------
  // DAILY CARD
  // -----------------------------
  InsightCard _buildDailyCard(DailyInsight daily) {
    String title = "Today’s Load";
    String subtitle;
    String color;

    if (daily.isHeavy) {
      subtitle = "High load — pace yourself";
      color = "warning";
    } else if (daily.isLight) {
      subtitle = "Light day — breathe easy";
      color = "calm";
    } else {
      subtitle = "Moderate load";
      color = "neutral";
    }

    return InsightCard(
      title: title,
      subtitle: subtitle,
      value: "${daily.loadScore}",
      color: color,
    );
  }

  // -----------------------------
  // WEEKLY CARD
  // -----------------------------
  InsightCard _buildWeeklyCard(WeeklyInsight weekly) {
    String subtitle;
    String color;

    if (weekly.isChaotic) {
      subtitle = "Chaotic week — rebalance needed";
      color = "warning";
    } else if (weekly.isBalanced) {
      subtitle = "Balanced week";
      color = "calm";
    } else {
      subtitle = "Mixed week";
      color = "neutral";
    }

    return InsightCard(
      title: "Weekly Balance",
      subtitle: subtitle,
      value: "${weekly.balanceScore}",
      color: color,
    );
  }

  // -----------------------------
  // PREDICTIVE CARD
  // -----------------------------
  InsightCard _buildPredictiveCard(PredictiveInsight predictive) {
    return InsightCard(
      title: "Tomorrow & Next Week",
      subtitle: "Forecasted load",
      value: "${predictive.tomorrowLoad} / ${predictive.nextWeekBalance}",
      color: "neutral",
    );
  }

  // -----------------------------
  // PATTERNS CARD
  // -----------------------------
  InsightCard _buildPatternsCard(PatternSummary patterns) {
    return InsightCard(
      title: "Patterns",
      subtitle: "${patterns.deepWorkCount} deep‑work • "
          "${patterns.recoveryCount} recovery • "
          "${patterns.heavyCount} heavy",
      value: "",
      color: "neutral",
    );
  }
}

// -----------------------------
// PANEL MODEL
// -----------------------------
@immutable
class InsightsPanelModel {
  final InsightCard dailyCard;
  final InsightCard weeklyCard;
  final InsightCard predictiveCard;
  final InsightCard patternsCard;

  const InsightsPanelModel({
    required this.dailyCard,
    required this.weeklyCard,
    required this.predictiveCard,
    required this.patternsCard,
  });

  const InsightsPanelModel.empty()
      : dailyCard = const InsightCard.empty(),
        weeklyCard = const InsightCard.empty(),
        predictiveCard = const InsightCard.empty(),
        patternsCard = const InsightCard.empty();
}

// -----------------------------
// INSIGHT CARD
// -----------------------------
@immutable
class InsightCard {
  final String title;
  final String subtitle;
  final String value;
  final String color; // calm, warning, neutral

  const InsightCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.color,
  });

  const InsightCard.empty()
      : title = "",
        subtitle = "",
        value = "",
        color = "neutral";
}
