import 'package:flutter/material.dart';

import '../models/task.dart';
import '../task_facade.dart';

/// TaskTile is the premium minimal UI component for each task.
/// It supports:
/// - Complete toggle
/// - Star toggle
/// - Tap to open details (later)
class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final facade = TaskFacade.instance;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: task.isStarred
              ? Colors.amberAccent
              : Colors.white.withOpacity(0.1),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          // COMPLETE TOGGLE
          GestureDetector(
            onTap: () {
              final updated = task.copyWith(isCompleted: !task.isCompleted);
              facade.update(updated);
            },
            child: Icon(
              task.isCompleted
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: task.isCompleted
                  ? Colors.tealAccent
                  : Colors.white54,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          // TITLE
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                color: task.isCompleted
                    ? Colors.white38
                    : Colors.white,
                fontSize: 15,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // STAR TOGGLE
          GestureDetector(
            onTap: () {
              final updated = task.copyWith(isStarred: !task.isStarred);
              facade.update(updated);
            },
            child: Icon(
              task.isStarred ? Icons.star : Icons.star_border,
              color: task.isStarred
                  ? Colors.amberAccent
                  : Colors.white38,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
