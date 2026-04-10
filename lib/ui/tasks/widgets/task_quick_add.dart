import 'package:flutter/material.dart';
import '../../../data/services/task_service.dart';

class TaskQuickAdd extends StatefulWidget {
  final TaskService taskService;
  final VoidCallback onAdded;

  const TaskQuickAdd({
    super.key,
    required this.taskService,
    required this.onAdded,
  });

  @override
  State<TaskQuickAdd> createState() => _TaskQuickAddState();
}

class _TaskQuickAddState extends State<TaskQuickAdd> {
  final TextEditingController _controller = TextEditingController();
  int _priority = 3;
  bool _saving = false;

  Future<void> _save() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => _saving = true);

    await widget.taskService.createTask(
      title: _controller.text.trim(),
      description: "",
      category: "personal",
      priority: _priority,
      emotionalLoad: 3,
      fatigueImpact: 3,
      dueDate: null,
    );

    _controller.clear();
    setState(() => _saving = false);

    widget.onAdded();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E2F0)),
      ),
      child: Row(
        children: [
          // Text field
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Quick add task...",
                border: InputBorder.none,
              ),
            ),
          ),

          // Priority selector
          DropdownButton<int>(
            value: _priority,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 5, child: Text("P5")),
              DropdownMenuItem(value: 4, child: Text("P4")),
              DropdownMenuItem(value: 3, child: Text("P3")),
              DropdownMenuItem(value: 2, child: Text("P2")),
              DropdownMenuItem(value: 1, child: Text("P1")),
            ],
            onChanged: (v) => setState(() => _priority = v!),
          ),

          const SizedBox(width: 10),

          // Save button
          _saving
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : GestureDetector(
                  onTap: _save,
                  child: const Icon(
                    Icons.send,
                    color: Color(0xFF8A4FFF),
                  ),
                ),
        ],
      ),
    );
  }
}
