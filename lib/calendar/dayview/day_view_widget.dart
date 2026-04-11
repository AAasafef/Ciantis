import 'package:flutter/material.dart';

import '../models/calendar_event.dart';
import '../widgets/event_tile.dart';
import 'day_view_engine.dart';
import '../editor/event_editor_sheet.dart';

/// DayViewWidget renders the full day timeline:
/// - Hour markers
/// - Event blocks
/// - Gap blocks
/// - Tap to create new events
///
/// It consumes DayViewEngine for layout.
class DayViewWidget extends StatelessWidget {
  final DateTime day;
  final List<CalendarEvent> events;

  const DayViewWidget({
    super.key,
    required this.day,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final model = DayViewEngine.instance.buildDayView(
      day: day,
      events: events,
    );

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: model.blocks.length,
      itemBuilder: (context, i) {
        final block = model.blocks[i];

        if (block.type == DayBlockType.event) {
          return _EventBlock(block: block);
        } else {
          return _GapBlock(block: block);
        }
      },
    );
  }
}

// -----------------------------
// EVENT BLOCK
// -----------------------------
class _EventBlock extends StatelessWidget {
  final DayBlock block;

  const _EventBlock({required this.block});

  @override
  Widget build(BuildContext context) {
    final durationMinutes = block.duration.inMinutes;
    final height = (durationMinutes / 60) * 80; // 80px per hour

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: EventTile(
        event: block.event!,
        height: height.clamp(50, 300),
        width: double.infinity,
      ),
    );
  }
}

// -----------------------------
// GAP BLOCK
// -----------------------------
class _GapBlock extends StatelessWidget {
  final DayBlock block;

  const _GapBlock({required this.block});

  @override
  Widget build(BuildContext context) {
    final durationMinutes = block.duration.inMinutes;
    final height = (durationMinutes / 60) * 80;

    return GestureDetector(
      onTap: () {
        EventEditorSheet.openNew(
          context: context,
          start: block.start,
          end: block.start.add(const Duration(hours: 1)),
        );
      },
      child: Container(
        height: height.clamp(30, 200),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft,
        child: Text(
          _formatGap(block),
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.4),
          ),
        ),
      ),
    );
  }

  String _formatGap(DayBlock block) {
    final s = "${block.start.hour.toString().padLeft(2, '0')}:"
        "${block.start.minute.toString().padLeft(2, '0')}";
    final e = "${block.end.hour.toString().padLeft(2, '0')}:"
        "${block.end.minute.toString().padLeft(2, '0')}";
    return "$s – $e";
  }
}
