import 'dart:async';
import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../data/services/task_service.dart';

class TaskExecutionPage extends StatefulWidget {
  final TaskModel task;
  final TaskService taskService;

  const TaskExecutionPage({
    super.key,
    required this.task,
    required this.taskService,
  });

  @override
  State<TaskExecutionPage> createState() => _TaskExecutionPageState();
}

class _TaskExecutionPageState extends State<TaskExecutionPage> {
  bool _started = false;
  int _seconds = 0;
  Timer? _timer;

  final TextEditingController _notes = TextEditingController();

  @override
  void dispose() {
    _timer?.cancel();
    _notes.dispose();
    super.dispose();
  }

  void _start() {
    setState(() => _started = true);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  Future<void> _finish() async {
    _timer?.cancel();

    // Mark task complete
    await widget.taskService.completeTask(widget.task.id);

    Navigator.pop(context, true);
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          task.title,
          style: const TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Timer
          Center(
            child: Text(
              _formatTime(_seconds),
              style: const TextStyle(
                color: Color(0xFF5A4A6A),
                fontWeight: FontWeight.w800,
                fontSize: 48,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Emotional + fatigue indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    "Emotional",
                    style: TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE573B5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.emotionalLoad.toString(),
                    style: const TextStyle(
                      color: Color(0xFF5A4A6A),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 40),
              Column(
                children: [
                  const Text(
                    "Fatigue",
                    style: TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFC94A),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.fatigueImpact.toString(),
                    style: const TextStyle(
                      color: Color(0xFF5A4A6A),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Notes
          const Text(
            "Notes",
            style: TextStyle(
              color: Color(0xFF5A4A6A),
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _notes,
            maxLines: 5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE8E2F0)),
            ).buildInputDecoration(),
          ),

          const SizedBox(height: 40),

          // Start or Finish button
          ElevatedButton(
            onPressed: _started ? _finish : _start,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _started ? const Color(0xFFE57373) : const Color(0xFF8A4FFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              _started ? "Finish Task" : "Start Task",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension _DecorationHelper on BoxDecoration {
  InputDecoration buildInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: color,
      border: OutlineInputBorder(
        borderRadius: borderRadius as BorderRadius,
        borderSide: BorderSide(color: border!.top.color),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius as BorderRadius,
        borderSide: BorderSide(color: border!.top.color),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius as BorderRadius,
        borderSide: const BorderSide(color: Color(0xFF8A4FFF)),
      ),
    );
  }
}
