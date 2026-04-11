import 'package:flutter/material.dart';

import '../models/calendar_event.dart';
import '../widgets/event_tile.dart';
import '../editor/event_editor_sheet.dart';
import 'week_view_engine.dart';

/// WeekViewWidget renders the full weekly layout:
/// - 7 columns (Mon–Sun)
/// - Events inside each column
/// - Tap gaps to create new events
///
/// It consumes WeekViewEngine for layout.
class WeekViewWidget extends StatelessWidget {
  final DateTime weekStart;
  final List<CalendarEvent> events;

  const WeekViewWidget({
    super.key,
    required this.weekStart,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final model = WeekViewEngine.instance.buildWeekView(
      weekStart: weekStart,
      events: events,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: model.days.map((day) {
          return _WeekDayColumn(day: day);
        }).toList(),
      ),
    );
  }
}

// -----------------------------
// SINGLE DAY COLUMN
// -----------------------------
class _WeekDayColumn extends StatelessWidget {
  final WeekDayModel day;

  const _WeekDayColumn({required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DayHeader(date: day.date),
          const SizedBox(height: 12),
          ..._buildEventTiles(context),
          _buildGapCreator(context),
        ],
      ),
    );
  }

  // -----------------------------
  // EVENT TILES
  // -----------------------------
  List<Widget> _buildEventTiles(BuildContext context) {
    return day.events.map((event) {
      final durationMinutes = event.duration.inMinutes;
      final height = (durationMinutes / 60) * 70; // 70px per hour

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: EventTile(
          event: event,
          height: height.clamp(50, 250),
          width: double.infinity,
        ),
      );
    }).toList();
  }

  // -----------------------------
  // GAP CREATOR
  // -----------------------------
  Widget _buildGapCreator(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final start = DateTime(day.date.year, day.date.month, day.date.day, 9);
        final end = start.add(const Duration(hours: 1));

        EventEditorSheet.openNew(
          context: context,
          start: start,
          end: end,
        );
      },
      child: Container(
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "Add",
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// -----------------------------
// DAY HEADER
// -----------------------------
class _DayHeader extends StatelessWidget {
  final DateTime date;

  const _DayHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    final weekday = _weekdayName(date.weekday);
    final dayNum = date.day.toString();

    return Column(
      children: [
        Text(
          weekday,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          dayNum,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  String _weekdayName(int w) {
    switch (w) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thu";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
      default:
        return "Sun";
    }
  }
}
