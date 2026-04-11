import 'package:flutter/material.dart';

import 'event_editor_engine.dart';
import 'event_editor_model.dart';
import '../models/calendar_event.dart';

/// EventEditorWidget is the full UI for creating or editing a calendar event.
///
/// It consumes:
/// - EventEditorEngine
/// - EventEditorModel
///
/// All logic is handled upstream.
/// This widget is pure presentation + user input.
class EventEditorWidget extends StatelessWidget {
  const EventEditorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: EventEditorEngine.instance,
      builder: (context, _) {
        final model = EventEditorEngine.instance.current;

        if (model == null) {
          return const SizedBox.shrink();
        }

        return _EditorForm(model: model);
      },
    );
  }
}

// -----------------------------
// FORM WIDGET
// -----------------------------
class _EditorForm extends StatefulWidget {
  final EventEditorModel model;

  const _EditorForm({required this.model});

  @override
  State<_EditorForm> createState() => _EditorFormState();
}

class _EditorFormState extends State<_EditorForm> {
  late TextEditingController _title;
  late TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.model.title);
    _notes = TextEditingController(text: widget.model.notes ?? "");
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _updateModel(EventEditorModel updated) {
    EventEditorEngine.instance.update(updated);
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // -----------------------------
          // TITLE
          // -----------------------------
          TextField(
            controller: _title,
            decoration: const InputDecoration(
              labelText: "Title",
            ),
            onChanged: (v) {
              _updateModel(model.copyWith(title: v));
            },
          ),

          const SizedBox(height: 20),

          // -----------------------------
          // DATE PICKERS
          // -----------------------------
          _DateTimePicker(
            label: "Start",
            value: model.start,
            onChanged: (v) => _updateModel(model.copyWith(start: v)),
          ),
          const SizedBox(height: 12),
          _DateTimePicker(
            label: "End",
            value: model.end,
            onChanged: (v) => _updateModel(model.copyWith(end: v)),
          ),

          const SizedBox(height: 20),

          // -----------------------------
          // EVENT TYPE
          // -----------------------------
          DropdownButtonFormField<CalendarEventType>(
            value: model.type,
            decoration: const InputDecoration(labelText: "Type"),
            items: CalendarEventType.values.map((t) {
              return DropdownMenuItem(
                value: t,
                child: Text(t.name),
              );
            }).toList(),
            onChanged: (v) {
              if (v != null) _updateModel(model.copyWith(type: v));
            },
          ),

          const SizedBox(height: 20),

          // -----------------------------
          // FLAGS
          // -----------------------------
          SwitchListTile(
            title: const Text("Important"),
            value: model.isImportant,
            onChanged: (v) =>
                _updateModel(model.copyWith(isImportant: v)),
          ),
          SwitchListTile(
            title: const Text("Flexible"),
            value: model.isFlexible,
            onChanged: (v) =>
                _updateModel(model.copyWith(isFlexible: v)),
          ),
          SwitchListTile(
            title: const Text("Energy Heavy"),
            value: model.isEnergyHeavy,
            onChanged: (v) =>
                _updateModel(model.copyWith(isEnergyHeavy: v)),
          ),

          const SizedBox(height: 20),

          // -----------------------------
          // NOTES
          // -----------------------------
          TextField(
            controller: _notes,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: "Notes",
            ),
            onChanged: (v) {
              _updateModel(model.copyWith(notes: v));
            },
          ),

          const SizedBox(height: 30),

          // -----------------------------
          // ACTION BUTTONS
          // -----------------------------
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final ok = EventEditorEngine.instance.save();
                    if (ok) Navigator.of(context).pop();
                  },
                  child: const Text("Save"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    EventEditorEngine.instance.delete(model.id);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Delete"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------
// DATE/TIME PICKER
// -----------------------------
class _DateTimePicker extends StatelessWidget {
  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;

  const _DateTimePicker({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (date == null) return;

        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(value),
        );

        if (time == null) return;

        final updated = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        onChanged(updated);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(
          "${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')} "
          "${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}",
        ),
      ),
    );
  }
}
