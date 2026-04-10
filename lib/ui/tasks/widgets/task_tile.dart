import 'package:flutter/material.dart';
import '../../../data/models/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTap;

  const TaskTile({
    super.key,
    required this.task,
    required this.onTap,
  });

  Color _priorityColor(int priority) {
    switch (priority) {
      case 5:
        return const Color(0xFFE57373); // red
      case 4:
        return const Color(0xFFFF8A3D); // orange
      case 3:
        return const Color(0xFFFFC94A); // yellow
      case 2:
        return const Color(0xFF8A4FFF); // purple
      default:
        return const Color(0xFFB6AFC8); // soft gray
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDone = task.isCompleted;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDone
                ? const Color(0xFFD8D2E3)
                : const Color(0xFFE8E2F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Priority indicator
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _priorityColor(task.priority),
                shape: BoxShape.circle,
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
                      color: isDone
                          ? const Color(0xFFB6AFC8)
                          : const Color(0xFF5A4A6A),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      decoration: isDone
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDone
                              ? const Color(0xFFC8C2D4)
                              : const Color(0xFF7A6F8F),
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            // Emotional + fatigue dots
            Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE573B5),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC94A),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
