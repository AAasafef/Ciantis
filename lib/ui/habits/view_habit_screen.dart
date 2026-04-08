import 'package:flutter/material.dart';
import '../../data/services/habit_service.dart';
import '../../data/models/habit_model.dart';

class ViewHabitScreen extends StatefulWidget {
  final String habitId;

  const ViewHabitScreen({super.key, required this.habitId});

  @override
  State<ViewHabitScreen> createState() => _ViewHabitScreenState();
}

class _ViewHabitScreenState extends State<ViewHabitScreen> {
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

  Future<void> _completeHabit() async {
    await _habitService.completeHabit(widget.habitId);
    _loadHabit();
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
          'Habit',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _habit == null
              ? const Center(
                  child: Text(
                    'Habit not found',
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
    final habit = _habit!;
    final dueToday = _habitService.isHabitDueToday(habit);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            habit.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF5A4A6A),
            ),
          ),
          if (habit.description != null &&
              habit.description!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                habit.description!,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF7A6F8F),
                ),
              ),
            ),
          const SizedBox(height: 24),

          // Frequency
          _sectionTitle('Frequency'),
          Text(
            _formatFrequency(habit),
            style: const TextStyle(
              color: Color(0xFF5A4A6A),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),

          // Streak
          _sectionTitle('Streak'),
          Text(
            '${habit.streakCount} day streak',
            style: const TextStyle(
              color: Color(0xFF8A4FFF),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),

          // Last completed
          _sectionTitle('Last Completed'),
          Text(
            habit.lastCompletedDate == null
                ? 'Never'
                : _formatDate(habit.lastCompletedDate!),
            style: const TextStyle(
              color: Color(0xFF5A4A6A),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 40),

          // Complete button
         
