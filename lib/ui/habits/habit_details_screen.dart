import 'package:flutter/material.dart';
import '../../data/services/habit_service.dart';
import '../../data/models/habit_model.dart';
import 'habit_create_screen.dart';

class HabitDetailsScreen extends StatefulWidget {
  final String habitId;

  const HabitDetailsScreen({super.key, required this.habitId});

  @override
  State<HabitDetailsScreen> createState() => _HabitDetailsScreenState();
}

class _HabitDetailsScreenState extends State<HabitDetailsScreen> {
  final HabitService _habitService = HabitService();

  HabitModel? _habit;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHabit();
  }

  Future<void> _loadHabit() async {
    final habit = await _habitService.getHabitById(widget.habitId);
    setState(() {
      _habit = habit;
      _loading = false;
    });
  }

  Future<void> _toggleComplete() async {
    if (_habit == null) return;

    await _habitService.completeHabit(_habit!.id);
    _loadHabit();
  }

  Future<void> _deleteHabit() async {
    if (_habit == null) return;

    await _habitService.deleteHabit(_habit!.id);
    if (mounted) Navigator.pop(context);
  }

  String _weekdayName(int day) {
    switch (day) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thu";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return "";
    }
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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7F4F9),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_habit == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7F4F9),
        body: Center(
          child: Text(
            "Habit not found",
            style: TextStyle(
              color: Color(0xFF7A6F8F),
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    final habit = _habit!;
    final today = DateTime.now().weekday;
    final isTodayHabit = habit.days.contains(today);
    final completedToday = _isToday(habit.lastCompletedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Habit Details',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFF8A4FFF)),
            onPressed: _deleteHabit,
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
              habit.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5A4A6A),
              ),
            ),

            const SizedBox(height: 12),

            // Description
            if (habit.description != null && habit.description!.isNotEmpty)
              Text(
                habit.description!,
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
                  onTap: isTodayHabit ? _toggleComplete : null,
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
                      : isTodayHabit
                          ? "Mark as complete"
                          : "Not scheduled today",
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
                      habit.category[0].toUpperCase() + habit.category.substring(1)),
                  _infoRow("Priority", habit.priority
