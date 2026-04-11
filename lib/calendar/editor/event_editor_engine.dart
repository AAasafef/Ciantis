import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../calendar_facade.dart';
import '../models/calendar_event.dart';
import 'event_editor_model.dart';

/// EventEditorEngine handles:
/// - Creating new events
/// - Editing existing events
/// - Validation
/// - Saving to CalendarFacade
/// - Deleting events
///
/// This is the logic layer behind the Event Editor UI.
class EventEditorEngine extends ChangeNotifier {
  // Singleton
  static final EventEditorEngine instance =
      EventEditorEngine._internal();
  EventEditorEngine._internal();

  final _facade = CalendarFacade.instance;
  final _uuid = const Uuid();

  EventEditorModel? _current;
  EventEditorModel? get current => _current;

  // -----------------------------
  // START NEW EVENT
  // -----------------------------
  void startNew({
    required DateTime start,
    required DateTime end,
  }) {
    _current = EventEditorModel(
      id: _uuid.v4(),
      title: "",
      start: start,
      end: end,
      type: CalendarEventType.other,
      isFlexible: false,
      isImportant: false,
      isEnergyHeavy: false,
      notes: "",
    );

    notifyListeners();
  }

  // -----------------------------
  // START EDIT EXISTING EVENT
  // -----------------------------
  void startEdit(CalendarEvent event) {
    _current = EventEditorModel(
      id: event.id,
      title: event.title,
      start: event.start,
      end: event.end,
      type: event.type,
      isFlexible: event.isFlexible,
      isImportant: event.isImportant,
      isEnergyHeavy: event.isEnergyHeavy,
      notes: event.notes,
    );

    notifyListeners();
  }

  // -----------------------------
  // UPDATE FIELD
  // -----------------------------
  void update(EventEditorModel model) {
    _current = model;
    notifyListeners();
  }

  // -----------------------------
  // SAVE EVENT
  // -----------------------------
  bool save() {
    if (_current == null) return false;
    if (!_current!.isValid) return false;

    final event = _current!.toEvent();
    _facade.upsertEvent(event);

    return true;
  }

  // -----------------------------
  // DELETE EVENT
  // -----------------------------
  void delete(String id) {
    _facade.deleteEvent(id);
  }

  // -----------------------------
  // CLEAR
  // -----------------------------
  void clear() {
    _current = null;
    notifyListeners();
  }
}
