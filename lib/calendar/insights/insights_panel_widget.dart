import 'package:flutter/material.dart';

import 'insights_panel_model.dart';

/// InsightsPanelWidget renders the Insights Panel UI.
///
/// It consumes:
/// - InsightsPanelUIModel
/// - InsightsPanelCardUI
///
/// This widget is pure presentation:
/// - No logic
/// - No analytics
/// - No formatting
/// - No state
///
/// All intelligence is handled upstream.
class InsightsPanelWidget extends StatelessWidget {
  final InsightsPanelUIModel model;

  const InsightsPanelWidget({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    if (model.cards.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: model.cards.map((card) {
            return _InsightCardWidget(card: card);
          }).toList(),
        ),
      ],
    );
  }
}

// -----------------------------
// SINGLE CARD WIDGET
// -----------------------------
class _InsightCardWidget extends StatelessWidget {
  final InsightsPanelCardUI card;

  const _InsightCardWidget({
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    final color = _resolveColor(card.color);
    final icon = _resolveIcon(card.icon);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(card.emphasize ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(card.emphasize ? 0.4 : 0.2),
          width: card.emphasize ? 2 : 1,
        ),
      ),
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            card.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            card.subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          if (card.value.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              card.value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // -----------------------------
  // COLOR TOKENS
  // -----------------------------
  Color _resolveColor(String token) {
    switch (token) {
      case "calm":
        return Colors.tealAccent.shade400;
      case "warning":
        return Colors.orangeAccent.shade200;
      case "neutral":
      default:
        return Colors.blueGrey.shade200;
    }
  }

  // -----------------------------
  // ICON TOKENS
  // -----------------------------
  IconData _resolveIcon(String token) {
    switch (token) {
      case "flame":
        return Icons.local_fire_department;
      case "leaf":
        return Icons.eco;
      case "balance":
        return Icons.balance;
      case "forecast":
        return Icons.trending_up;
      case "pattern":
        return Icons.grid_view;
      default:
        return Icons.circle;
    }
  }
}
