import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/routine_model.dart';
import '../../data/services/routine_service.dart';

class RoutineExecutionScreen extends StatefulWidget {
  final RoutineModel routine;

  const RoutineExecutionScreen({super.key, required this.routine});

  @override
  State<RoutineExecutionScreen> createState() => _RoutineExecutionScreenState();
}

class _RoutineExecutionScreenState extends State<RoutineExecutionScreen> {
  final RoutineService _routineService = RoutineService();

  int _currentStepIndex = 0;
  int _remainingSeconds = 0;
  Timer? _timer;

  RoutineStepModel get _currentStep =>
      widget.routine.steps[_currentStepIndex];

  @override
  void initState() {
    super.initState();
    _startStepTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startStepTimer() {
    _remainingSeconds = _currentStep.durationMinutes * 60;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds <= 0) {
        t.cancel();
        _goToNextStep();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _goToNextStep() {
    if (_currentStepIndex < widget.routine.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
      _startStepTimer();
    } else {
      _completeRoutine();
    }
  }

  Future<void> _completeRoutine() async {
    await _routineService.completeRoutine(widget.routine.id);

    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFFF7F4F9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            "Routine Complete",
            style: TextStyle(
              color: Color(0xFF5A4A6A),
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            "You finished the entire routine. Beautiful work.",
            style: TextStyle(
              color: Color(0xFF7A6F8F),
              height: 1.4,
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8A4FFF),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                "Done",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  double _progress() {
    final total = widget.routine.steps.length;
    return (_currentStepIndex + 1) / total;
  }

  @override
  Widget build(BuildContext context) {
    final step = _currentStep;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.routine.title,
          style: const TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: _progress(),
              backgroundColor: const Color(0xFFE8E2F0),
              color: const Color(0xFF8A4FFF),
              minHeight: 8,
              borderRadius: BorderRadius.circular(12),
            ),

            const SizedBox(height: 30),

            // Step number
            Text(
              "Step ${_currentStepIndex + 1} of ${widget.routine.steps.length}",
              style: const TextStyle(
                color: Color(0xFF7A6F8F),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            // Step title
            Text(
              step.title,
              style: const TextStyle(
                color: Color(0xFF5A4A6A),
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 20),

            // Emotional + fatigue indicators
            Row(
              children: [
                _badge("Emotional", step.emotionalLoad.toString(),
                    const Color(0xFF8A4FFF)),
                const SizedBox(width: 10),
                _badge("Fatigue", step.fatigueImpact.toString(),
                    const Color(0xFF5A4A6A)),
              ],
            ),

            const SizedBox(height: 30),

            // Timer
            Center(
              child: Text(
                _formatTime(_remainingSeconds),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8A4FFF),
                ),
              ),
            ),

            const Spacer(),

            // Next button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _goToNextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A4FFF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  _currentStepIndex == widget.routine.steps.length - 1
                      ? "Complete Routine"
                      : "Next Step",
                  style: const TextStyle(
                    color: Colors.white,
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

  Widget _badge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: Box
