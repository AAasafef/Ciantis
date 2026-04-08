import 'package:flutter/material.dart';
import '../../data/services/routine_service.dart';
import '../../data/models/routine_model.dart';
import 'routine_create_screen.dart';
import 'routine_execution_screen.dart';

class RoutineDetailsScreen extends StatefulWidget {
  final String routineId;

  const RoutineDetailsScreen({super.key, required this.routineId});

  @override
  State<RoutineDetailsScreen> createState() => _RoutineDetailsScreenState();
}

class _RoutineDetailsScreenState extends State<RoutineDetailsScreen> {
  final RoutineService _routineService = RoutineService();

  RoutineModel? _routine;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRoutine();
  }

  Future<void> _loadRoutine() async {
    final routine = await _routineService.getRoutineById(widget.routineId);
    setState(() {
      _routine = routine;
      _loading = false;
    });
  }

  Future<void> _completeRoutine() async {
    if (_routine == null) return;

    await _routineService.completeRoutine(_routine!.id);
    _loadRoutine();
  }

  Future<void> _deleteRoutine() async {
    if (_routine == null) return;

    await _routineService.deleteRoutine(_routine!.id);
    if (mounted) Navigator.pop(context);
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

  bool _isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Widget _infoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF7A6F8F),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color ?? const Color(0xFF5A4A6A),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepTile(RoutineStepModel step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          // Step number
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF8A4FFF).withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '${step.order}',
                style: const TextStyle(
                  color: Color(0xFF8A4FFF),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Step title + duration
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: const TextStyle(
                    color: Color(0xFF5A4A6A),
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${step.durationMinutes} min • Emo ${step.emotionalLoad} • Fatigue ${step.fatigueImpact}",
                  style: const TextStyle(
                    color: Color(0xFF7A6F8F),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7F4F9),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_routine == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7F4F9),
        body: Center(
          child: Text(
            "Routine not found",
            style: TextStyle(
              color: Color(0xFF7A6F8F),
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    final routine = _routine!;
    final completedToday = _isToday(routine.lastCompletedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Routine Details',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFF8A4FFF)),
            onPressed: _deleteRoutine,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              routine.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5A4A6A),
              ),
            ),

            const SizedBox(height: 12),

            // Description
            if (routine.description != null &&
                routine.description!.isNotEmpty)
              Text(
                routine.description!,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF7A6F8F),
                  height: 1.4,
                ),
              ),

            const SizedBox(height: 24),

            // Completion toggle
            Row(
              children: [
                GestureDetector(
                  onTap: _completeRoutine,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: completedToday
                          ? const Color(0xFF8A4FFF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF8A4FFF),
                        width: 2,
                      ),
                    ),
                    child: completedToday
                        ? const Icon(Icons.check,
                            color: Colors.white, size: 20)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  completedToday
                      ? "Completed Today"
                      : "Mark as complete",
                  style: const TextStyle(
                    color: Color(0xFF5A4A6A),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Info card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _infoRow("Category",
                      routine.category[0].toUpperCase() + routine.category.substring(1)),
                  _infoRow("Priority", routine.priority.toString(),
                      color: _priorityColor(routine.priority)),
                  _infoRow("Streak", routine.streak.toString()),
                  _infoRow("Emotional Load", routine.emotionalLoad.toString()),
                  _infoRow("Fatigue Impact", routine.fatigueImpact.toString()),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Steps header
            const Text(
              "Steps",
              style: TextStyle(
                color: Color(0xFF5A4A6A),
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 12),

            ...routine.steps.map(_stepTile).toList(),

            const SizedBox(height: 40),

            // Start Routine Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RoutineExecutionScreen(routine: routine),
                    ),
                  );
                  _loadRoutine();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A4FFF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Start Routine',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Edit Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RoutineCreateScreen(),
                    ),
                  );
                  _loadRoutine();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF8A4FFF)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Edit Routine',
                  style: TextStyle(
                    color: Color(0xFF8A4FFF),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
