import 'package:flutter/material.dart';

/// CalendarNavBar provides the top navigation between:
/// - Day View
/// - Week View
/// - Month View
///
/// It is a pure UI component with callbacks.
class CalendarNavBar extends StatelessWidget {
  final CalendarNavSelection selection;
  final ValueChanged<CalendarNavSelection> onChanged;

  const CalendarNavBar({
    super.key,
    required this.selection,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavItem(
            label: "Day",
            selected: selection == CalendarNavSelection.day,
            onTap: () => onChanged(CalendarNavSelection.day),
          ),
          _NavItem(
            label: "Week",
            selected: selection == CalendarNavSelection.week,
            onTap: () => onChanged(CalendarNavSelection.week),
          ),
          _NavItem(
            label: "Month",
            selected: selection == CalendarNavSelection.month,
            onTap: () => onChanged(CalendarNavSelection.month),
          ),
        ],
      ),
    );
  }
}

// -----------------------------
// NAV ITEM
// -----------------------------
class _NavItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Colors.tealAccent.shade400
        : Colors.white.withOpacity(0.5);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? Colors.tealAccent.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            color: color,
          ),
        ),
      ),
    );
  }
}

// -----------------------------
// ENUM
// -----------------------------
enum CalendarNavSelection {
  day,
  week,
  month,
}
