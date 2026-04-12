import 'package:flutter/material.dart';

import '../models/task.dart';
import '../task_facade.dart';
import 'task_editor_screen.dart';

/// TaskDetailScreen shows the full details of a task.
/// It provides:
/// - Priority
/// - Energy
/// - Flexibility
/// - Due date
/// - Scheduled window
/// - Notes
/// - Quick actions
class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final facade = TaskFacade.instance;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Task Details"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskEditorScreen(task: task),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              facade.delete(task.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // TITLE
          Text(
            task.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          // COMPLETION + STAR
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  final updated =
                      task.copyWith(isCompleted: !task.isCompleted);
                  facade.update(updated);
                },
                child: Icon(
                  task.isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: task.isCompleted
                      ? Colors.tealAccent
                      : Colors.white54,
                  size: 26,
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  final updated =
                      task.copyWith(isStarred: !task.isStarred);
                  facade.update(updated);
                },
                child: Icon(
                  task.isStarred ? Icons.star : Icons.star_border,
                  color: task.isStarred
                      ? Colors.amberAccent
                      : Colors.white38,
                  size: 26,
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // METADATA
          _meta("Priority", task.priority.name),
          _meta("Energy", task.energy.name),
          _meta("Flexibility", task.flexibility.name),

          if (task.dueDate != null)
            _meta("Due Date", task.dueDate!.toIso8601String()),

          if (task.scheduledStart != null)
            _meta("Scheduled Start",
                task.scheduledStart!.toIso8601String()),

          if (task.scheduledEnd != null)
            _meta("Scheduled End",
                task.scheduledEnd!.toIso8601String()),

          const SizedBox(height: 30),

          // NOTES
          const Text(
            "Notes",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            task.notes?.isNotEmpty == true
                ? task.notes!
                : "No notes",
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _meta(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Text(
            "$label:",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
