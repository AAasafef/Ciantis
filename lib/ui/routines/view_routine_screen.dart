import 'package:flutter/material.dart';
import '../../data/services/routine_service.dart';
import '../../data/models/routine_model.dart';
import 'edit_routine_screen.dart';

class ViewRoutineScreen extends StatefulWidget {
  final String routineId;

  const ViewRoutineScreen({super.key, required this.routineId});

  @override
  State<ViewRoutineScreen> createState() => _ViewRoutineScreenState();
}

class _ViewRoutineScreenState extends State<ViewRoutineScreen> {
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

  Future<void> _toggleStep(RoutineStep step) async {
    await _routineService.toggleStep(widget.routineId, step);
    _loadRoutine();
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
          'Routine',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF8A4FFF)),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditRoutineScreen(routineId: widget.routineId),
                ),
              );
              _loadRoutine();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _routine == null
              ? const Center(
                  child: Text(
                    'Routine not found',
                    style: TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontSize: 16,
                    ),
                  ),
                )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _routine!.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF5A4A6A),
            ),
          ),
          if (_routine!.description != null &&
              _routine!.description!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _routine!.description!,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF7A6F8F),
                ),
              ),
            ),
          const SizedBox(height: 20),
          const Text(
            'Steps',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8A4FFF),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _routine!.steps.length,
              itemBuilder: (context, index) {
                final step = _routine!.steps[index];
                return _stepTile(step);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepTile(RoutineStep step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _toggleStep(step),
            child: Icon(
              step.isCompleted
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined,
              color: const Color(0xFF8A4FFF),
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              step.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: step.isCompleted
                    ? const Color(0xFF7A6F8F)
                    : const Color(0xFF5A4A6A),
                decoration: step.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
          if (step.durationMinutes != null)
            Text(
              '${step.durationMinutes} min',
              style: const TextStyle(
                color: Color(0xFF7A6F8F),
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }
}
