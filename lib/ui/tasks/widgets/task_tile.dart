import 'package:flutter/material.dart';
import '../../../data/models/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggle;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
  });

  Color _emotionalColor(int value) {
    if (value >= 8) return const Color(0xFFE573B5); // high emotional
    if (value >= 5) return const Color(0xFF8A4FFF); // medium
    return const Color(0xFFB6AFC8); // low
  }

  Color _fatigueColor(int value) {
    if (value >= 8) return const Color(0xFFFFC94A); // high fatigue
    if (value >= 5) return const Color(0xFF7A6F8F); // medium
    return const Color(0xFFD8D2E3); // low
  }

  @override
  Widget build(BuildContext context) {
    final due = task.dueDate != null
        ? "${task.dueDate!.month}/${task.dueDate!.day}"
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8E2F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: task.isCompleted
                    ? const Color(0xFF8A4FFF)
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF8A4FFF),
                  width: 2,
                ),
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check,
                      size: 18, color: Colors.white)
                  : null,
            ),
          ),

          const SizedBox(width: 14),

          // Title + description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    color: task.isCompleted
                        ? const Color(0xFFB6AFC8)
                        : const Color(0xFF5A4A6A),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                if (task.description != null &&
                    task.description!.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      task.description!,
                      style: const TextStyle(
                        color: Color(0xFF7A6F8F),
                        fontSize: 13,
                      ),
                    ),
                  ),
                if (due != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      "Due $due",
                      style: const TextStyle(
                        color: Color(0xFF8A4FFF),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Emotional + fatigue dots
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: _emotionalColor(task.emotionalLoad),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _fatigueColor(task.fatigueImpact),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
