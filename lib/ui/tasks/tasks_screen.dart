import 'package:flutter/material.dart';
import '../../data/services/task_service.dart';
import '../../data/models/task_model.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
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

  Future<void> _toggle(TaskModel task) async {
    await _taskService.toggleTaskCompletion(task);
    _loadTasks();
  }

  Future<void> _delete(String id) async {
    await _taskService.deleteTask(id);
    _loadTasks();
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8A4FFF),
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
          _loadTasks();
        },
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
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return _taskTile(task);
                  },
                ),
    );
  }

  Widget _taskTile(TaskModel task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _toggle(task),
            child: Icon(
              task.isCompleted
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined,
              color: const Color(0xFF8A4FFF),
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditTaskScreen(task: task),
                  ),
                ).then((_) => _loadTasks());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: task.isCompleted
                          ? const Color(0xFF7A6F8F)
                          : const Color(0xFF5A4A6A),
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  if (task.description != null &&
                      task.description!.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        task.description!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF7A6F8F),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: Color(0xFF8A4FFF)),
            onPressed: () => _delete(task.id),
          ),
        ],
      ),
    );
  }
}
