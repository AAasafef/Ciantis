import 'package:flutter/material.dart';
import '../../data/services/calendar_event_service.dart';
import '../../data/models/calendar_event_model.dart';

class CalendarInsightsScreen extends StatefulWidget {
  const CalendarInsightsScreen({super.key});

  @override
  State<CalendarInsightsScreen> createState() => _CalendarInsightsScreenState();
}

class _CalendarInsightsScreenState extends State<CalendarInsightsScreen> {
  final CalendarEventService _calendarService = CalendarEventService();

  bool _loading = true;

  int _weeklyEmotionalLoad = 0;
  int _weeklyFatigue = 0;

  List<DateTime> _overloadedDays = [];
  List<DateTime> _recommendedWindows = [];

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    final now = DateTime.now();

    final startOfWeek =
        now.subtract(Duration(days: now.weekday - 1)); // Monday
    final endOfWeek =
        startOfWeek.add(const Duration(days: 6)); // Sunday

    final events = await _calendarService.getEventsInRange(
      DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day, 0, 0),
      DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59),
    );

    int emotionalSum = 0;
    int fatigueSum = 0;

    final overloadedDays = <DateTime>[];

    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));

      final dayEvents = events.where((e) =>
          e.startTime.year == day.year &&
          e.startTime.month == day.month &&
          e.startTime.day == day.day);

      int dayEmotional = 0;
      int dayFatigue = 0;

      for (final e in dayEvents) {
        dayEmotional += e.emotionalLoad;
        dayFatigue += e.fatigueImpact;
      }

      emotionalSum += dayEmotional;
      fatigueSum += dayFatigue;

      if (dayEmotional > 20 || dayFatigue > 20) {
        overloadedDays.add(day);
      }
    }

    // Recommended scheduling windows for the next 3 days
    final recommended = <DateTime>[];
    for (int i = 0; i < 3; i++) {
      final day = now.add(Duration(days: i));
      final windows = await _calendarService.getIdealSchedulingWindows(day);
      recommended.addAll(windows);
    }

    setState(() {
      _weeklyEmotionalLoad = emotionalSum;
      _weeklyFatigue = fatigueSum;
      _overloadedDays = overloadedDays;
      _recommendedWindows = recommended;
      _loading = false;
    });
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final ampm = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
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
          'Insights',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Weekly Emotional Load'),
          _scoreBar(_weeklyEmotionalLoad.clamp(0, 70) / 70, Colors.pinkAccent),
          const SizedBox(height: 20),

          _sectionTitle('Weekly Fatigue Impact'),
          _scoreBar(_weeklyFatigue.clamp(0, 70) / 70, Colors.deepPurpleAccent),
          const SizedBox(height: 30),

          _sectionTitle('Overloaded Days'),
          const SizedBox(height: 10),
          _overloadedDays.isEmpty
              ? const Text(
                  'No overloaded days this week',
                  style: TextStyle(
                    color: Color(0xFF7A6F8F),
                    fontSize: 14,
                  ),
                )
              : Wrap(
                  spacing: 10,
                  children: _overloadedDays
                      .map((d) => _chip(_formatDate(d), Colors.redAccent))
                      .toList(),
                ),
          const SizedBox(height: 30),

          _sectionTitle('Recommended Scheduling Windows'),
          const SizedBox(height: 10),
          _recommendedWindows.isEmpty
              ? const Text(
                  'No ideal windows available',
                  style: TextStyle(
                    color: Color(0xFF7A6F8F),
                    fontSize: 14,
                  ),
                )
              : Wrap(
                  spacing: 10,
                  children: _recommendedWindows
                      .map((w) => _chip(
                          '${_formatDate(w)} • ${_formatTime(w)}',
                          const Color(0xFF8A4FFF)))
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _scoreBar(double factor, Color color) {
    return Container(
      height: 14,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: factor,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF8A4FFF),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
