import 'package:flutter/material.dart';

import '../models/task.dart';
import '../task_facade.dart';

/// QuickAddTaskBar is a fast input field for capturing tasks instantly.
/// It uses smart defaults:
/// - priority: medium
/// - energy: medium
/// - flexibility: flexible
/// - no due date
class QuickAddTaskBar extends StatefulWidget {
  const QuickAddTaskBar({super.key});

  @override
  State<QuickAddTaskBar> createState() => _QuickAddTaskBarState();
}

class _QuickAddTaskBarState extends State<QuickAddTaskBar> {
  final _controller = TextEditingController();

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final task = Task.create(title: text).copyWith(
      priority: TaskPriority.medium,
      energy: TaskEnergy.medium,
      flexibility: TaskFlexibility.flexible,
    );

    TaskFacade.instance.add(task);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // INPUT FIELD
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Add a task...",
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _addTask(),
            ),
          ),

          // ADD BUTTON
          GestureDetector(
            onTap: _addTask,
            child: const Icon(
              Icons.add_circle,
              color: Colors.tealAccent,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
