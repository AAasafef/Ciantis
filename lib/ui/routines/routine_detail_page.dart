import 'package:flutter/material.dart';
import '../../data/models/routine_model.dart';
import '../../data/services/routine_service.dart';
import 'routine_execution_page.dart';

class RoutineDetailPage extends StatefulWidget {
  final RoutineModel routine;
  final RoutineService routineService;

  const RoutineDetailPage({
    super.key,
    required this.routine,
    required this.routineService,
  });

  @override
  State<RoutineDetailPage> createState() => _RoutineDetailPageState();
}

class _RoutineDetailPageState extends State<RoutineDetailPage> {
  late RoutineModel _routine;

  @override
  void initState() {
    super.initState();
    _routine = widget.routine;
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

  Future<void> _toggleStep(String stepId) async {
    await widget.routineService.completeStep(_routine.id, stepId);
    final updated = await widget.routineService.getRoutineById(_routine.id);
    if (updated != null) {
      setState(() => _routine = updated);
    }
  }

  Future<void> _deleteRoutine() async {
    await widget.routineService.deleteRoutine(_routine.id);
    Navigator.pop(context);
  }

  Future<void> _completeRoutine() async {
    await widget.routineService.completeRoutine(_routine.id);
    final updated = await widget.routineService.getRoutineById(_routine.id);
    if (updated != null) {
      setState(() => _routine = updated);
    }
  }

  Future<void> _startExecution() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RoutineExecutionPage(
          routine: _routine,
          routineService: widget.routineService,
        ),
      ),
    );

    final updated = await widget.routineService.getRoutineById(_routine.id);
    if (updated != null) {
      setState(() => _routine = updated);
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
    final lastCompleted = _routine.lastCompletedAt != null
        ? "${_routine.lastCompletedAt!.month}/${_routine.lastCompletedAt!.day}/${_routine.lastCompletedAt!.year}"
        : "Never";

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Routine Details",
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFFE57373)),
            onPressed: _deleteRoutine,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Title
          Text(
            _routine.title,
            style: const TextStyle(
              color: Color(0xFF5A4A6A),
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),

          const SizedBox(height: 10),

          // Description
          if (_routine.description != null &&
              _routine.description!.trim().isNotEmpty)
            Text(
              _routine.description!,
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
                  color: _emotionalColor(_routine.emotionalLoad),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Emotional Load: ${_routine.emotionalLoad}",
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
                  color: _fatigueColor(_routine.fatigueImpact),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Fatigue Impact: ${_routine.fatigueImpact}",
                style: const TextStyle(
                  color: Color(0xFF5A4A6A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Info rows
          _infoRow("Category", _routine.category),
          _infoRow("Streak", "${_routine.streak} days"),
          _infoRow("Last Completed", lastCompleted),

          const SizedBox(height: 20),

          // Steps
          const Text(
            "Steps",
            style: TextStyle(
              color: Color(0xFF5A4A6A),
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 10),

          Column(
            children: _routine.steps.map((step) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Color(0xFFE8E2F0)),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: step.isCompleted,
                      activeColor: const Color(0xFF8A4FFF),
                      onChanged: (_) => _toggleStep(step.id),
                    ),
                    Expanded(
                      child: Text(
                        step.title,
                        style: TextStyle(
                          color: step.isCompleted
                              ? const Color(0xFFB6AFC8)
                              : const Color(0xFF5A4A6A),
                          fontWeight: FontWeight.w600,
                          decoration: step.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 30),

          // Start Execution Button
          ElevatedButton(
            onPressed: _startExecution,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8A4FFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Start Routine",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),

          const SizedBox(height: 14),

          // Complete Routine Button
          ElevatedButton(
            onPressed: _completeRoutine,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8A3D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Mark Routine Complete",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
