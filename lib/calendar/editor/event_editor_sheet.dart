import 'package:flutter/material.dart';

import 'event_editor_engine.dart';
import 'event_editor_widget.dart';
import '../models/calendar_event.dart';

/// EventEditorSheet is the modal wrapper for the Event Editor UI.
///
/// It provides:
/// - Smooth bottom-sheet animation
/// - Safe area handling
/// - Clean entry points for new/edit flows
class EventEditorSheet {
  // -----------------------------
  // OPEN FOR NEW EVENT
  // -----------------------------
  static Future<void> openNew({
    required BuildContext context,
    required DateTime start,
    required DateTime end,
  }) async {
    EventEditorEngine.instance.startNew(start: start, end: end);

    await _open(context);
  }

  // -----------------------------
  // OPEN FOR EDITING EXISTING EVENT
  // -----------------------------
  static Future<void> openEdit({
    required BuildContext context,
    required CalendarEvent event,
  }) async {
    EventEditorEngine.instance.startEdit(event);

    await _open(context);
  }

  // -----------------------------
  // INTERNAL OPEN METHOD
  // -----------------------------
  static Future<void> _open(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: const EventEditorWidget(),
          ),
        );
      },
    );

    // Clear editor state after closing
    EventEditorEngine.instance.clear();
  }
}
