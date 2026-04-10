import 'package:flutter/material.dart';

import '../../data/services/task_service.dart';
import '../../data/models/task_model.dart';

import 'task_creation_page.dart';
import 'task_detail_page.dart';
import 'widgets/task_tile.dart';
import 'widgets/task_filter_bar.dart';

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
  List<TaskModel> _allTasks = [];
  List<TaskModel> _filteredTasks = [];

  String _searchQuery = "";
  String _category = "all";
  int _priority = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await widget.taskService.getAllTasks();
    setState(() {
      _allTasks = list;
      _filteredTasks = list;
      _loading = false;
    });
  }

  void _applyFilters() {
    List<TaskModel> tasks = List.from(_allTasks);

    // Search filter
    if (_searchQuery.trim().isNotEmpty) {
      tasks = tasks.where((t) {
        return t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (t.description ?? "")
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Category filter
    if (_category != "all") {
      tasks = tasks.where((t) => t.category == _category).toList();
    }

    // Priority filter
    if (_priority != 0) {
      tasks = tasks.where((t) => t.priority == _priority).toList();
    }

    setState(() => _filteredTasks = tasks);
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
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // ---------------------------
                // FILTER BAR
                // ---------------------------
                TaskFilterBar(
                  onSearch: (query) {
                    _searchQuery = query;
                    _applyFilters();
                  },
                  onCategoryChange: (cat) {
                    _category = cat;
                    _applyFilters();
                  },
                  onPriorityChange: (p) {
                    _priority = p;
                    _applyFilters();
                  },
                ),

                const SizedBox(height: 20),

                // ---------------------------
                // TASK LIST
                // ---------------------------
                if (_filteredTasks.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        "No tasks match your filters",
                        style: TextStyle(
                          color: Color(0xFF7A6F8F),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                else
                  ..._filteredTasks.map(
                    (task) => TaskTile(
                      task: task,
                      onTap: () => _openDetail(task),
                    ),
                  ),
              ],
            ),
    );
  }
}
