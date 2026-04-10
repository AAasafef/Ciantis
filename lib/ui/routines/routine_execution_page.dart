import 'package:flutter/material.dart';
import '../../data/models/routine_model.dart';
import '../../data/services/routine_service.dart';

class RoutineExecutionPage extends StatefulWidget {
  final RoutineModel routine;
  final RoutineService routineService;

  const RoutineExecutionPage({
    super.key,
    required this.routine,
    required this.routineService,
  });

  @override
  State<RoutineExecutionPage> createState() => _RoutineExecutionPageState();
}

class _RoutineExecutionPageState extends State<RoutineExecutionPage> {
  int _currentStepIndex = 0;
  late RoutineModel _routine;

  @override
  void initState() {
    super.initState();
    _routine = widget.routine;
  }

  Future<void> _completeStep() async {
    final step = _routine.steps[_currentStepIndex];

    // Mark step complete
    await widget.routineService.completeStep(_routine.id, step.id);

    // Refresh routine
    final updated = await widget.routineService.getRoutineById(_routine.id);
    if (updated != null) {
      setState(() => _routine = updated);
    }

    // Move to next step or finish routine
    if (_currentStepIndex < _routine.steps.length - 1) {
      setState(() => _currentStepIndex++);
    } else {
      await widget.routineService.completeRoutine(_routine.id);
      Navigator.pop(context, true); // return to detail page with refresh signal
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _routine.steps[_currentStepIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _routine.title,
          style: const TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Step counter
            Text(
              "Step ${_currentStepIndex + 1} of ${_routine.steps.length}",
              style: const TextStyle(
                color: Color(0xFF7A6F8F),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 30),

            // Step title
            Text(
              step.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF5A4A6A),
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 20),

            // Duration
            Text(
              "${step.durationMinutes} min",
              style: const TextStyle(
                color: Color(0xFF8A4FFF),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 40),

            // Emotional + fatigue indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _indicatorDot("Emotional", step.emotionalLoad,
                    const Color(0xFFE573B5)),
                const SizedBox(width: 20),
                _indicatorDot("Fatigue", step.fatigueImpact,
                    const Color(0xFFFFC94A)),
              ],
            ),

            const Spacer(),

            // Complete Step Button
            ElevatedButton(
              onPressed: _completeStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8A4FFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 40,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                _currentStepIndex == _routine.steps.length - 1
                    ? "Finish Routine"
                    : "Complete Step",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _indicatorDot(String label, int value, Color color) {
    return Column(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "$label: $value",
          style: const TextStyle(
            color: Color(0xFF5A4A6A),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
