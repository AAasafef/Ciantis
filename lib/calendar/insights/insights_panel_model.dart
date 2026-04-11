import 'package:flutter/foundation.dart';

/// InsightsPanelUIModel defines the UI-level structure for the
/// Insights Panel widget.
///
/// This is separate from the analytics model and the panel engine.
/// It contains:
/// - Layout metadata
/// - Color tokens
/// - Icon tokens
/// - Typography hints
/// - Card grouping
///
/// This ensures the UI receives clean, predictable data.
@immutable
class InsightsPanelUIModel {
  final List<InsightsPanelCardUI> cards;

  const InsightsPanelUIModel({
    required this.cards,
  });

  const InsightsPanelUIModel.empty() : cards = const [];
}

// -----------------------------
// CARD UI MODEL
// -----------------------------
@immutable
class InsightsPanelCardUI {
  final String title;
  final String subtitle;
  final String value;

  /// Color token: calm, warning, neutral
  final String color;

  /// Icon token: flame, leaf, balance, forecast, pattern
  final String icon;

  /// Optional: whether this card should be emphasized
  final bool emphasize;

  const InsightsPanelCardUI({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.color,
    required this.icon,
    this.emphasize = false,
  });
}
