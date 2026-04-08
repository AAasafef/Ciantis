import 'package:flutter/material.dart';
import '../../data/services/task_service.dart';
import '../../data/models/task_model.dart';
import 'task_create_screen.dart';
import 'task_details_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskService _taskService = TaskService();

  List<TaskModel> _tasks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _taskService.getAllTasks();
    setState(() {
      _tasks = tasks;
      _loading = false;
    });
  }

  Future<void> _toggleComplete(TaskModel task) async {
    if (!task.completed) {
      await _taskService.completeTask(task.id);
    }
    _loadTasks();
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

  Widget _taskTile(TaskModel task) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskDetailsScreen(taskId: task.id),
          ),
        );
        _loadTasks();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE8E2F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Completion toggle
            GestureDetector(
              onTap: () => _toggleComplete(task),
              child: Container(
                width: 26,
                height: 26,
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
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
            ),

            const SizedBox(width: 16),

            // Title + due date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: task.completed
                          ? const Color(0xFF7A6F8F)
                          : const Color(0xFF5A4A6A),
                      decoration:
                          task.completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _dueDateLabel(task),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7A6F8F),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Priority dot
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: _priorityColor(task.priority),
                shape: BoxShape.circle,
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
          'Tasks',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? const Center(
                  child: Text(
                    'No tasks yet',
                    style: TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: _tasks.map(_taskTile).toList(),
                ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8A4FFF),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TaskCreateScreen(),
            ),
          );
          _loadTasks();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
