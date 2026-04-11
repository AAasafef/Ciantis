import 'package:flutter/material.dart';

import '../models/calendar_event.dart';
import '../editor/event_editor_sheet.dart';

/// EventTile renders a single calendar event inside:
/// - Day View
/// - Week View
///
/// It is a reusable, luxury UI component.
class EventTile extends StatelessWidget {
  final CalendarEvent event;
  final double height;
  final double width;

  const EventTile({
    super.key,
    required this.event,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final color = _resolveColor(event);

    return GestureDetector(
      onTap: () {
        EventEditorSheet.openEdit(context: context, event: event);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: height,
        width: width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withOpacity(0.4),
            width: 1.2,
          ),
        ),
        child: _buildContent(context, color),
      ),
    );
  }

  // -----------------------------
  // CONTENT
  // -----------------------------
  Widget _buildContent(BuildContext context, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _formatTime(event),
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        if (event.isImportant || event.isEnergyHeavy) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              if (event.isImportant)
                Icon(Icons.star, size: 14, color: color),
              if (event.isEnergyHeavy)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(Icons.local_fire_department,
                      size: 14, color: color),
                ),
            ],
          ),
        ],
      ],
    );
  }

  // -----------------------------
  // COLOR TOKENS
  // -----------------------------
  Color _resolveColor(CalendarEvent event) {
    switch (event.type) {
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

  // -----------------------------
  // TIME FORMATTER
  // -----------------------------
  String _formatTime(CalendarEvent e) {
    final s = "${e.start.hour.toString().padLeft(2, '0')}:"
        "${e.start.minute.toString().padLeft(2, '0')}";
    final t = "${e.end.hour.toString().padLeft(2, '0')}:"
        "${e.end.minute.toString().padLeft(2, '0')}";
    return "$s – $t";
  }
}
