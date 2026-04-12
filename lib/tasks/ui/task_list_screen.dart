import 'package:flutter/material.dart';

import '../task_facade.dart';
import '../models/task.dart';
import 'task_tile.dart';

/// TaskListScreen is the main UI for viewing tasks.
/// It shows:
/// - Live updates from TaskFacade.stream
/// - Sorted task list
/// - Quick actions (complete, star)
/// - Premium minimal UI
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final facade = TaskFacade.instance;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Tasks"),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<List<Task>>(
        stream: facade.stream,
        builder: (context, snapshot) {
          final tasks = snapshot.data ?? [];

          if (tasks.isEmpty) {
            return const Center(
              child: Text(
                "No tasks yet",
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            );
          }

          final sorted = facade.sorted();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sorted.length,
            itemBuilder: (context, index) {
              final task = sorted[index];
              return TaskTile(task: task);
            },
          );
        },
      ),
    );
  }
}
