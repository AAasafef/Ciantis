import 'package:flutter/material.dart';
import '../../data/services/routine_service.dart';
import '../../data/models/routine_model.dart';
import 'routine_details_screen.dart';

class RoutineSuggestionsScreen extends StatefulWidget {
  const RoutineSuggestionsScreen({super.key});

  @override
  State<RoutineSuggestionsScreen> createState() =>
      _RoutineSuggestionsScreenState();
}

class _RoutineSuggestionsScreenState extends State<RoutineSuggestionsScreen> {
  final RoutineService _routineService = RoutineService();

  List<RoutineModel> _suggestions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    final routines = await _routineService.getSmartSuggestions();
    setState(() {
      _suggestions = routines;
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

  Widget _routineCard(RoutineModel routine) {
    final completedToday = _isToday(routine.lastCompletedDate);

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RoutineDetailsScreen(routineId: routine.id),
          ),
        );
        _loadSuggestions();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE8E2F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              routine.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5A4A6A),
              ),
            ),

            const SizedBox(height: 8),

            // Streak
            Text(
              "Streak: ${routine.streak}",
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7A6F8F),
              ),
            ),

            const SizedBox(height: 16),

            // Emotional + fatigue row
            Row(
              children: [
                _badge("Emotional", routine.emotionalLoad.toString(),
                    const Color(0xFF8A4FFF)),
                const SizedBox(width: 10),
                _badge("Fatigue", routine.fatigueImpact.toString(),
                    const Color(0xFF5A4A6A)),
                const Spacer(),
                // Priority dot
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _priorityColor(routine.priority),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Completion indicator
            Row(
              children: [
                Icon(
                  completedToday
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: completedToday
                      ? const Color(0xFF8A4FFF)
                      : const Color(0xFF7A6F8F),
                ),
                const SizedBox(width: 8),
                Text(
                  completedToday
                      ? "Completed Today"
                      : "Tap to view routine",
                  style: const TextStyle(
                    color: Color(0xFF5A4A6A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
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
          'Routine Suggestions',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _suggestions.isEmpty
              ? const Center(
                  child: Text(
                    'No suggestions right now',
                    style: TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: _suggestions.map(_routineCard).toList(),
                ),
    );
  }
}
