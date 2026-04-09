import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/services/routine_service.dart';
import '../../data/models/routine_model.dart';
import '../../data/models/routine_step_model.dart';

class RoutineExecutionScreen extends StatefulWidget {
  final String routineId;

  const RoutineExecutionScreen({super.key, required this.routineId});

  @override
  State<RoutineExecutionScreen> createState() => _RoutineExecutionScreenState();
}

class _RoutineExecutionScreenState extends State<RoutineExecutionScreen> {
  final RoutineService _routineService = RoutineService();

  RoutineModel? _routine;
  List<RoutineStepModel> _steps = [];

  int _currentIndex = 0;
  int _remainingSeconds = 0;

  Timer? _timer;
  bool _loading = true;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _loadRoutine();
  }

  Future<void> _loadRoutine() async {
    final (routine, steps) =
        await _routineService.getRoutineWithSteps(widget.routineId);

    setState(() {
      _routine = routine;
      _steps = steps;
      _loading = false;
    });

    if (_steps.isNotEmpty) {
      _startStep(_steps[0]);
    }
  }

  void _startStep(RoutineStepModel step) {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = step.duration * 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds <= 1) {
        t.cancel();
        _completeStep();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  Future<void> _completeStep() async {
    final step = _steps[_currentIndex];

    final updated = step.copyWith(
      completed: true,
      updatedAt: DateTime.now(),
    );

    await _routineService._repo.updateStep(updated);

    if (_currentIndex + 1 < _steps.length) {
      setState(() => _currentIndex++);
      _startStep(_steps[_currentIndex]);
    } else {
      await _finishRoutine();
    }
  }

  Future<void> _finishRoutine() async {
    _timer?.cancel();
    await _routineService.completeRoutine(widget.routineId);
    setState(() => _finished = true);
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  Widget _progressDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_steps.length, (i) {
        final active = i == _currentIndex;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 14 : 10,
          height: active ? 14 : 10,
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF8A4FFF)
                : const Color(0xFFD8C7F5),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _insightBanner() {
    final insight = _routineService.generateRoutineInsight(_routine!);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF8A4FFF).withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        insight,
        style: const TextStyle(
          color: Color(0xFF5A4A6A),
          fontSize: 14,
          height: 1.4,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // -----------------------------
  // UI
  // -----------------------------
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7F4F9),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_finished) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F4F9),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle,
                  size: 80, color: Color(0xFF8A4FFF)),
              const SizedBox(height: 20),
              const Text(
                "Routine Complete",
                style: TextStyle(
                  color: Color(0xFF5A4A6A),
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "${_routine!.streak} day streak",
                style: const TextStyle(
                  color: Color(0xFF8A4FFF),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A4FFF),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Done",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final step = _steps[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _routine!.title,
          style: const TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _insightBanner(),
            _progressDots(),
            const SizedBox(height: 30),

            // Step title
            Text(
              step.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF5A4A6A),
                fontWeight: FontWeight.w700,
                fontSize: 22,
              ),
            ),

            const SizedBox(height: 20),

            // Timer
            Text(
              _formatTime(_remainingSeconds),
              style: const TextStyle(
                color: Color(0xFF8A4FFF),
                fontWeight: FontWeight.w700,
                fontSize: 48,
              ),
            ),

            const SizedBox(height: 40),

            // Emotional + fatigue badges
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _badge("E", step.emotionalLoad),
                const SizedBox(width: 12),
                _badge("F", step.fatigueImpact),
              ],
            ),

            const Spacer(),

            // Skip button
            TextButton(
              onPressed: _completeStep,
              child: const Text(
                "Skip Step",
                style: TextStyle(
                  color: Color(0xFF7A6F8F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, int value) {
    Color color;
    if (value >= 4) {
      color = const Color(0xFF8A4FFF);
    } else if (value >= 2) {
      color = const Color(0xFFB76EFF);
    } else {
      color = const Color(0xFFD8C7F5);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "$label$value",
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}
