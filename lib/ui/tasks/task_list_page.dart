import 'package:flutter/material.dart';

import '../../data/services/task_service.dart';
import '../../data/models/task_model.dart';

import 'task_creation_page.dart';
import 'task_detail_page.dart';
import 'widgets/task_tile.dart';

class TaskListPage extends StatefulWidget {
  final TaskService taskService;

  const TaskListPage({
    super.key,
    required this.taskService,
  });

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  bool _loading = true;
  List<TaskModel> _tasks = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await widget.taskService.getAllTasks();
    setState(() {
      _tasks = list;
      _loading = false;
    });
  }

  Future<void> _openCreation() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskCreationPage(
          taskService: widget.taskService,
        ),
      ),
    );
    _load();
  }

  Future<void> _openDetail(TaskModel task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskDetailPage(
          task: task,
          taskService: widget.taskService,
        ),
      ),
    );
    _load();
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
          "Tasks",
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF8A4FFF)),
            onPressed: _openCreation,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? const Center(
                  child: Text(
                    "No tasks yet",
                    style: TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _tasks.length,
                  itemBuilder: (context, i) {
                    final task = _tasks[i];
                    return TaskTile(
                      task: task,
                      onTap: () => _openDetail(task),
                    );
                  },
                ),
    );
  }
}
