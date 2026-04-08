import 'package:flutter/material.dart';
import '../../data/services/task_service.dart';
import '../../data/models/task_model.dart';
import 'task_create_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final TaskService _taskService = TaskService();

  TaskModel? _task;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  Future<void> _loadTask() async {
    final task = await _taskService.getTaskById(widget.taskId);
    setState(() {
      _task = task;
      _loading = false;
    });
  }

  Future<void> _toggleComplete() async {
    if (_task == null) return;

    final updated = _task!.copyWith(
      completed: !_task!.completed,
      updatedAt: DateTime.now(),
    );

    await _taskService.updateTask(updated);
    _loadTask();
  }

  Future<void> _deleteTask() async {
    if (_task == null) return;

    await _taskService.deleteTask(_task!.id);
    if (mounted) Navigator.pop(context);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "No due date";
    return "${date.month}/${date.day}/${date.year}";
  }

  Color _priorityColor(int priority) {
    switch (priority) {
      case 5:
        return Colors.redAccent;
      case 4:
        return Colors.orangeAccent;
      case 3:
        return Colors.amber;
      case 2:
        return Colors.greenAccent;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7F4F9),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_task == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7F4F9),
        body: Center(
          child: Text(
            "Task not found",
            style: TextStyle(
              color: Color(0xFF7A6F8F),
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    final task = _task!;
    final overdue = task.dueDate != null &&
        !task.completed &&
        task.dueDate!.isBefore(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Task Details',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFF8A4FFF)),
            onPressed: _deleteTask,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              task.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: overdue ? Colors.redAccent : const Color(0xFF5A4A6A),
                decoration:
                    task.completed ? TextDecoration.lineThrough : null,
              ),
            ),

            const SizedBox(height: 12),

            // Description
            if (task.description != null && task.description!.isNotEmpty)
              Text(
                task.description!,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF7A6F8F),
                  height: 1.4,
                ),
              ),

            const SizedBox(height: 24),

            // Completion toggle
            Row(
              children: [
                GestureDetector(
                  onTap: _toggleComplete,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: task.completed
                          ? const Color(0xFF8A4FFF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF8A4FFF),
                        width: 2,
                      ),
                    ),
                    child: task.completed
                        ? const Icon(Icons.check,
                            color: Colors.white, size: 20)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  task.completed ? "Completed" : "Mark as complete",
                  style: const TextStyle(
                    color: Color(0xFF5A4A6A),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Info card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _infoRow("Category",
                      task.category[0].toUpperCase() + task.category.substring(1)),
                  _infoRow("Priority", task.priority.toString(),
                      trailingColor: _priorityColor(task.priority)),
                  _infoRow("Due Date", _formatDate(task.dueDate),
                      highlight: overdue),
                  _infoRow("Emotional Load", task.emotionalLoad.toString()),
                  _infoRow("Fatigue Impact", task.fatigueImpact.toString()),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Edit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TaskCreateScreen(),
                    ),
                  );
                  _loadTask();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A4FFF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Edit Task',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value,
      {bool highlight = false, Color? trailingColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF7A6F8F),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: highlight
                  ? Colors.redAccent
                  : trailingColor ?? const Color(0xFF5A4A6A),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
