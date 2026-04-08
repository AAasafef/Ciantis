import 'package:flutter/material.dart';
import '../../data/services/habit_service.dart';
import '../../data/models/habit_model.dart';
import 'create_habit_screen.dart';
import 'view_habit_screen.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
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

  Future<void> _completeHabit(String id) async {
    await _habitService.completeHabit(id);
    _loadHabits();
  }

  Future<void> _deleteHabit(String id) async {
    await _habitService.deleteHabit(id);
    _loadHabits();
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8A4FFF),
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateHabitScreen()),
          );
          _loadHabits();
        },
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
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _habits.length,
                  itemBuilder: (context, index) {
                    final habit = _habits[index];
                    return _habitTile(habit);
                  },
                ),
    );
  }

  Widget _habitTile(HabitModel habit) {
    final dueToday = _habitService.isHabitDueToday(habit);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ViewHabitScreen(habitId: habit.id),
          ),
        ).then((_) => _loadHabits());
      },
      child: Container(
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
              onTap: dueToday ? () => _completeHabit(habit.id) : null,
              child: Icon(
                Icons.check_circle_rounded,
                size: 30,
                color: dueToday
                    ? const Color(0xFF8A4FFF)
                    : const Color(0xFFBDB4C8),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                habit.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5A4A6A),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${habit.streakCount} day streak',
                  style: const TextStyle(
                    color: Color(0xFF8A4FFF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!dueToday)
                  const Text(
                    'Not due today',
                    style: TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  color: Color(0xFF8A4FFF)),
              onPressed: () => _deleteHabit(habit.id),
            ),
          ],
        ),
      ),
    );
  }
}
