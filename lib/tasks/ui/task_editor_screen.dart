import 'package:flutter/material.dart';

import '../models/task.dart';
import '../task_facade.dart';

/// TaskEditorScreen allows creating or editing a task.
/// It supports:
/// - Title
/// - Notes
/// - Priority
/// - Energy
/// - Flexibility
/// - Due date
/// - Scheduling (optional)
class TaskEditorScreen extends StatefulWidget {
  final Task? task;

  const TaskEditorScreen({super.key, this.task});

  @override
  State<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends State<TaskEditorScreen> {
  late TextEditingController _title;
  late TextEditingController _notes;

  late TaskPriority _priority;
  late TaskEnergy _energy;
  late TaskFlexibility _flexibility;

  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();

    final t = widget.task;

    _title = TextEditingController(text: t?.title ?? "");
    _notes = TextEditingController(text: t?.notes ?? "");

    _priority = t?.priority ?? TaskPriority.medium;
    _energy = t?.energy ?? TaskEnergy.medium;
    _flexibility = t?.flexibility ?? TaskFlexibility.flexible;

    _dueDate = t?.dueDate;
  }

  @override
  Widget build(BuildContext context) {
    final facade = TaskFacade.instance;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.task == null ? "New Task" : "Edit Task"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              final isNew = widget.task == null;

              final task = (widget.task ?? Task.create(title: _title.text))
                  .copyWith(
                title: _title.text,
                notes: _notes.text,
                priority: _priority,
                energy: _energy,
                flexibility: _flexibility,
                dueDate: _dueDate,
              );

              if (isNew) {
                facade.add(task);
              } else {
                facade.update(task);
              }

              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // TITLE
          TextField(
            controller: _title,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Title",
              labelStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.tealAccent),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // NOTES
          TextField(
            controller: _notes,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Notes",
              labelStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.tealAccent),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // PRIORITY
          _sectionLabel("Priority"),
          _chipRow<TaskPriority>(
            values: TaskPriority.values,
            selected: _priority,
            label: (v) => v.name,
            onSelect: (v) => setState(() => _priority = v),
          ),

          const SizedBox(height: 20),

          // ENERGY
          _sectionLabel("Energy"),
          _chipRow<TaskEnergy>(
            values: TaskEnergy.values,
            selected: _energy,
            label: (v) => v.name,
            onSelect: (v) => setState(() => _energy = v),
          ),

          const SizedBox(height: 20),

          // FLEXIBILITY
          _sectionLabel("Flexibility"),
          _chipRow<TaskFlexibility>(
            values: TaskFlexibility.values,
            selected: _flexibility,
            label: (v) => v.name,
            onSelect: (v) => setState(() => _flexibility = v),
          ),

          const SizedBox(height: 30),

          // DUE DATE
          _sectionLabel("Due Date"),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _dueDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.dark(),
                    child: child!,
                  );
                },
              );

              if (picked != null) {
                setState(() => _dueDate = picked);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                _dueDate != null
                    ? _dueDate!.toIso8601String().split("T").first
                    : "None",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _chipRow<T>({
    required List<T> values,
    required T selected,
    required String Function(T) label,
    required void Function(T) onSelect,
  }) {
    return Wrap(
      spacing: 10,
      children: values.map((v) {
        final isSelected = v == selected;
        return ChoiceChip(
          label: Text(label(v)),
          selected: isSelected,
          onSelected: (_) => onSelect(v),
          selectedColor: Colors.tealAccent.withOpacity(0.2),
          backgroundColor: Colors.white12,
          labelStyle: TextStyle(
            color: isSelected ? Colors.tealAccent : Colors.white70,
          ),
        );
      }).toList(),
    );
  }
}
