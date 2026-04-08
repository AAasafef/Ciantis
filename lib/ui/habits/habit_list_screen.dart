import 'package:flutter/material.dart';
import '../../data/services/habit_service.dart';
import '../../data/models/habit_model.dart';
import 'habit_create_screen.dart';
import 'habit_details_screen.dart';

class HabitListScreen extends StatefulWidget {
  const HabitListScreen({super.key});

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  final HabitService _habitService = HabitService();

  List<HabitModel> _habits = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final habits = await _habitService.getAllHabits();
    setState(() {
      _habits = habits;
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

  Widget _habitTile(HabitModel habit) {
    final today = DateTime.now().weekday;
    final isTodayHabit = habit.days.contains(today);

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HabitDetailsScreen(habitId: habit.id),
          ),
        );
        _loadHabits();
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
            // Completion toggle
            GestureDetector(
              onTap: () async {
                await _habitService.completeHabit(habit.id);
                _loadHabits();
              },
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: isTodayHabit &&
                          habit.lastCompletedDate != null &&
                          _isToday(habit.lastCompletedDate!)
                      ? const Color(0xFF8A4FFF)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF8A4FFF),
                    width: 2,
                  ),
                ),
                child: isTodayHabit &&
                        habit.lastCompletedDate != null &&
                        _isToday(habit.lastCompletedDate!)
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
            ),

            const SizedBox(width: 16),

            // Title + streak
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5A4A6A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Streak: ${habit.streak}",
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
                color: _priorityColor(habit.priority),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
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
          'Habits',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _habits.isEmpty
              ? const Center(
                  child: Text(
                    'No habits yet',
                    style: TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: _habits.map(_habitTile).toList(),
                ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8A4FFF),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const HabitCreateScreen(),
            ),
          );
          _loadHabits();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
