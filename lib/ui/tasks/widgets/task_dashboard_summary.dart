import 'package:flutter/material.dart';
import '../../../data/models/task_model.dart';

class TaskDashboardSummary extends StatelessWidget {
  final List<TaskModel> tasks;

  const TaskDashboardSummary({
    super.key,
    required this.tasks,
  });

  int get _completed =>
      tasks.where((t) => t.isCompleted).length;

  int get _dueToday {
    final now = DateTime.now();
    return tasks.where((t) {
      if (t.dueDate == null) return false;
      return t.dueDate!.year == now.year &&
          t.dueDate!.month == now.month &&
          t.dueDate!.day == now.day;
    }).length;
  }

  int get _highPriority =>
      tasks.where((t) => t.priority >= 4 && !t.isCompleted).length;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Task Overview",
            style: TextStyle(
              color: Color(0xFF5A4A6A),
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _stat("Total", tasks.length.toString(),
                  const Color(0xFF8A4FFF)),
              _stat("Completed", _completed.toString(),
                  const Color(0xFF7A6F8F)),
              _stat("Today", _dueToday.toString(),
                  const Color(0xFFE573B5)),
              _stat("High Priority", _highPriority.toString(),
                  const Color(0xFFFF8A3D)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF7A6F8F),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
