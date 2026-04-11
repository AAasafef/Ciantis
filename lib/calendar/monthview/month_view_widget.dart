import 'package:flutter/material.dart';

import '../models/calendar_event.dart';
import '../editor/event_editor_sheet.dart';
import '../dayview/day_view_widget.dart';
import 'month_view_engine.dart';
import 'month_heatmap_engine.dart';

/// MonthViewWidget renders the full month grid:
/// - 6x7 layout
/// - Heatmap background
/// - Event dots
/// - Heavy / deep-work / recovery indicators
///
/// It consumes:
/// - MonthViewEngine
/// - MonthHeatmapEngine
class MonthViewWidget extends StatelessWidget {
  final int year;
  final int month;
  final List<CalendarEvent> events;

  const MonthViewWidget({
    super.key,
    required this.year,
    required this.month,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final model = MonthViewEngine.instance.buildMonthView(
      year: year,
      month: month,
      events: events,
    );

    final heatmap = MonthHeatmapEngine.instance.buildHeatmap(
      year: year,
      month: month,
      events: events,
    );

    return Column(
      children: [
        _WeekdayHeader(),
        const SizedBox(height: 8),
        _MonthGrid(model: model, heatmap: heatmap),
      ],
    );
  }
}

// -----------------------------
// WEEKDAY HEADER
// -----------------------------
class _WeekdayHeader extends StatelessWidget {
  final List<String> names = const [
    "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: names.map((n) {
        return Expanded(
          child: Center(
            child: Text(
              n,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// -----------------------------
// MONTH GRID
// -----------------------------
class _MonthGrid extends StatelessWidget {
  final MonthViewModel model;
  final MonthHeatmapModel heatmap;

  const _MonthGrid({
    required this.model,
    required this.heatmap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 7 / 6,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: model.days.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
        ),
        itemBuilder: (context, i) {
          final day = model.days[i];
          final score = heatmap.scores[DateTime(
            day.date.year,
            day.date.month,
            day.date.day,
          )];

          return _DayCell(day: day, heatScore: score);
        },
      ),
    );
  }
}

// -----------------------------
// DAY CELL
// -----------------------------
class _DayCell extends StatelessWidget {
  final MonthDayModel day;
  final int? heatScore;

  const _DayCell({
    required this.day,
    required this.heatScore,
  });

  @override
  Widget build(BuildContext context) {
    final bg = _resolveHeatColor(heatScore);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DayViewWidget(
              day: day.date,
              events: day.events,
            ),
          ),
        );
      },
      onLongPress: () {
        final start = DateTime(day.date.year, day.date.month, day.date.day, 9);
        final end = start.add(const Duration(hours: 1));

        EventEditorSheet.openNew(
          context: context,
          start: start,
          end: end,
        );
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: day.isInMonth
                ? Colors.white.withOpacity(0.15)
                : Colors.white.withOpacity(0.05),
          ),
        ),
        padding: const EdgeInsets.all(6),
        child: _buildContent(context),
      ),
    );
  }

  // -----------------------------
  // CONTENT
  // -----------------------------
  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // DATE NUMBER
        Text(
          "${day.date.day}",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: day.isInMonth
                ? Colors.white
                : Colors.white.withOpacity(0.3),
          ),
        ),

        const Spacer(),

        // EVENT DOTS
        Row(
          children: day.events.take(3).map((e) {
            return Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 3),
              decoration: BoxDecoration(
                color: _eventColor(e),
                shape: BoxShape.circle,
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 4),

        // HEAVY / DEEP-WORK / RECOVERY ICONS
        Row(
          children: [
            if (day.isHeavyDay)
              Icon(Icons.local_fire_department,
                  size: 12, color: Colors.orangeAccent.shade200),
            if (day.isDeepWorkDay)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(Icons.bolt,
                    size: 12, color: Colors.tealAccent.shade400),
              ),
            if (day.isRecoveryDay)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(Icons.spa,
                    size: 12, color: Colors.greenAccent.shade400),
              ),
          ],
        ),
      ],
    );
  }

  // -----------------------------
  // HEATMAP COLOR
  // -----------------------------
  Color _resolveHeatColor(int? score) {
    if (score == null) return Colors.transparent;

    // 0 = calm, 100 = intense
    final opacity = (score / 100) * 0.25;
    return Colors.redAccent.withOpacity(opacity);
  }

  // -----------------------------
  // EVENT DOT COLOR
  // -----------------------------
  Color _eventColor(CalendarEvent e) {
    switch (e.type) {
      case CalendarEventType.deepWork:
        return Colors.tealAccent.shade400;
      case CalendarEventType.recovery:
        return Colors.greenAccent.shade400;
      case CalendarEventType.meeting:
        return Colors.orangeAccent.shade200;
      case CalendarEventType.other:
      default:
        return Colors.blueGrey.shade200;
    }
  }
}
