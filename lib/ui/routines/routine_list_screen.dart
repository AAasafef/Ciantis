import 'package:flutter/material.dart';
import '../../data/services/routine_service.dart';
import '../../data/models/routine_model.dart';
import 'routine_create_screen.dart';
import 'routine_details_screen.dart';

class RoutineListScreen extends StatefulWidget {
  const RoutineListScreen({super.key});

  @override
  State<RoutineListScreen> createState() => _RoutineListScreenState();
}

class _RoutineListScreenState extends State<RoutineListScreen> {
  final RoutineService _routineService = RoutineService();

  List<RoutineModel> _routines = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRoutines();
  }

  Future<void> _loadRoutines() async {
    final routines = await _routineService.getAllRoutines();
    setState(() {
      _routines = routines;
      _loading = false;
    });
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

  Widget _routineTile(RoutineModel routine) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RoutineDetailsScreen(routineId: routine.id),
          ),
        );
        _loadRoutines();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
            // Streak badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF8A4FFF).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "🔥 ${routine.streak}",
                style: const TextStyle(
                  color: Color(0xFF8A4FFF),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Title + steps count
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    routine.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5A4A6A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${routine.steps.length} steps",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7A6F8F),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Priority dot
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: _priorityColor(routine.priority),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
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
          'Routines',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _routines.isEmpty
              ? const Center(
                  child: Text(
                    'No routines yet',
                    style: TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: _routines.map(_routineTile).toList(),
                ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8A4FFF),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RoutineCreateScreen(),
            ),
          );
          _loadRoutines();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
