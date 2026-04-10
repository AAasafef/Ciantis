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

  Future<void> _toggleCompletion() async {
    await widget.taskService.toggleCompletion(_task);
    final updated = await widget.taskService.getTaskById(_task.id);
    if (updated != null) {
      setState(() => _task = updated);
    }
  }

  Future<void> _delete() async {
    await widget.taskService.deleteTask(_task.id);
    Navigator.pop(context);
  }

  Color _emotionalColor(int value) {
    if (value >= 8) return const Color(0xFFE573B5);
    if (value >= 5) return const Color(0xFF8A4FFF);
    return const Color(0xFFB6AFC8);
  }

  Color _fatigueColor(int value) {
    if (value >= 8) return const Color(0xFFFFC94A);
    if (value >= 5) return const Color(0xFF7A6F8F);
    return const Color(0xFFD8D2E3);
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
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFFE57373)),
            onPressed: _delete,
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

          // Emotional + fatigue indicators
          Row(
            children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: _emotionalColor(_task.emotionalLoad),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "Emotional Load: ${_task.emotionalLoad}",
              style: const TextStyle(
                color: Color(0xFF5A4A6A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: _fatigueColor(_task.fatigueImpact),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "Fatigue Impact: ${_task.fatigueImpact}",
              style: const TextStyle(
                color: Color(0xFF5A4A6A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Info rows
        _infoRow("Category", _task.category),
        _infoRow("Due Date", due),
        _infoRow("Reminder", _task.reminderEnabled ? "Enabled" : "Disabled"),
        if (_task.reminderEnabled)
          _infoRow("Reminder Before", "${_task.reminderMinutesBefore} min"),
        _infoRow("Recurring", _task.isRecurring ? "Yes" : "No"),
        if (_task.isRecurring)
          _infoRow("Recurrence Rule", _task.recurrenceRule ?? "—"),

        const SizedBox(height: 30),

        // Completion toggle
        ElevatedButton(
          onPressed: _toggleCompletion,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8A4FFF),
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
