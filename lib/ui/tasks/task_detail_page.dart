import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../data/services/task_service.dart';

class TaskDetailPage extends StatefulWidget {
  final TaskModel task;
  final TaskService taskService;

  const TaskDetailPage({
    super.key,
    required this.task,
    required this.taskService,
  });

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late TaskModel _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  Future<void> _toggleComplete() async {
    if (_task.isCompleted) {
      // Un-complete
      final updated = _task.copyWith(isCompleted: false);
      await widget.taskService.updateTask(updated);
      setState(() => _task = updated);
    } else {
      // Complete
      await widget.taskService.completeTask(_task.id);
      final refreshed = await widget.taskService.getTaskById(_task.id);
      if (refreshed != null) {
        setState(() => _task = refreshed);
      }
    }
  }

  Future<void> _deleteTask() async {
    await widget.taskService.deleteTask(_task.id);
    Navigator.pop(context);
  }

  Color _priorityColor(int priority) {
    switch (priority) {
      case 5:
        return const Color(0xFFE57373);
      case 4:
        return const Color(0xFFFF8A3D);
      case 3:
        return const Color(0xFFFFC94A);
      case 2:
        return const Color(0xFF8A4FFF);
      default:
        return const Color(0xFFB6AFC8);
    }
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF7A6F8F),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF5A4A6A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final due = _task.dueDate != null
        ? "${_task.dueDate!.month}/${_task.dueDate!.day}/${_task.dueDate!.year}"
        : "None";

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Task Details",
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFFE57373)),
            onPressed: _deleteTask,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Title
          Text(
            _task.title,
            style: const TextStyle(
              color: Color(0xFF5A4A6A),
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),

          const SizedBox(height: 10),

          // Description
          if (_task.description != null &&
              _task.description!.trim().isNotEmpty)
            Text(
              _task.description!,
              style: const TextStyle(
                color: Color(0xFF7A6F8F),
                fontSize: 15,
              ),
            ),

          const SizedBox(height: 20),

          // Priority
          Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: _priorityColor(_task.priority),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Priority: ${_task.priority}",
                style: const TextStyle(
                  color: Color(0xFF5A4A6A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Emotional + fatigue
          _infoRow("Emotional Load", _task.emotionalLoad.toString()),
          _infoRow("Fatigue Impact", _task.fatigueImpact.toString()),

          // Category
          _infoRow("Category", _task.category),

          // Due date
          _infoRow("Due Date", due),

          const SizedBox(height: 30),

          // Complete / Un-complete button
          ElevatedButton(
            onPressed: _toggleComplete,
            style: ElevatedButton.styleFrom(
              backgroundColor: _task.isCompleted
                  ? const Color(0xFF7A6F8F)
                  : const Color(0xFF8A4FFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              _task.isCompleted ? "Mark as Incomplete" : "Mark as Complete",
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
