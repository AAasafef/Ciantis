import 'package:flutter/material.dart';
import '../../data/services/task_service.dart';
import '../../data/models/task_model.dart';
import 'task_details_screen.dart';

class TaskSuggestionsScreen extends StatefulWidget {
  const TaskSuggestionsScreen({super.key});

  @override
  State<TaskSuggestionsScreen> createState() => _TaskSuggestionsScreenState();
}

class _TaskSuggestionsScreenState extends State<TaskSuggestionsScreen> {
  final TaskService _taskService = TaskService();

  List<TaskModel> _suggestions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    final tasks = await _taskService.getSmartSuggestions();
    setState(() {
      _suggestions = tasks;
      _loading = false;
    });
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

  String _dueDateLabel(TaskModel task) {
    if (task.dueDate == null) return "No due date";

    final now = DateTime.now();
    final diff = task.dueDate!.difference(now).inDays;

    if (diff < 0) return "Overdue";
    if (diff == 0) return "Due today";
    if (diff == 1) return "Due tomorrow";
    return "Due in $diff days";
  }

  Widget _badge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskCard(TaskModel task) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskDetailsScreen(taskId: task.id),
          ),
        );
        _loadSuggestions();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE8E2F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5A4A6A),
              ),
            ),

            const SizedBox(height: 8),

            // Due date
            Text(
              _dueDateLabel(task),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7A6F8F),
              ),
            ),

            const SizedBox(height: 16),

            // Emotional + fatigue row
            Row(
              children: [
                _badge("Emotional", task.emotionalLoad.toString(),
                    const Color(0xFF8A4FFF)),
                const SizedBox(width: 10),
                _badge("Fatigue", task.fatigueImpact.toString(),
                    const Color(0xFF5A4A6A)),
                const Spacer(),
                // Priority dot
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _priorityColor(task.priority),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Streak
            Text(
              "Streak: ${task.streak}",
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7A6F8F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Task Suggestions',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _suggestions.isEmpty
              ? const Center(
                  child: Text(
                    'No suggestions right now',
                    style: TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: _suggestions.map(_taskCard).toList(),
                ),
    );
  }
}
