import 'package:flutter/material.dart';
import '../../data/services/calendar_event_service.dart';
import '../../data/models/calendar_event_model.dart';
import 'day_view_screen.dart';
import 'create_event_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarEventService _calendarService = CalendarEventService();

  DateTime _focusedMonth = DateTime.now();
  List<CalendarEventModel> _events = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final events = await _calendarService.getAllEvents();
    setState(() {
      _events = events;
      _loading = false;
    });
  }

  List<CalendarEventModel> _eventsForDay(DateTime day) {
    return _events.where((e) {
      return e.startTime.year == day.year &&
          e.startTime.month == day.month &&
          e.startTime.day == day.day;
    }).toList();
  }

  void _goToPreviousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    });
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
          'Calendar',
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
            MaterialPageRoute(builder: (_) => const CreateEventScreen()),
          );
          _loadEvents();
        },
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _buildCalendar(),
    );
  }

  Widget _buildCalendar() {
    final daysInMonth = DateUtils.getDaysInMonth(
      _focusedMonth.year,
      _focusedMonth.month,
    );

    final firstDayOfMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month, 1);

    final startingWeekday = firstDayOfMonth.weekday;

    final totalCells = daysInMonth + (startingWeekday - 1);

    return Column(
      children: [
        _monthHeader(),
        const SizedBox(height: 10),
        _weekdayRow(),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: totalCells,
            itemBuilder: (context, index) {
              final dayNumber = index - (startingWeekday - 2);

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }

              final day = DateTime(
                _focusedMonth.year,
                _focusedMonth.month,
                dayNumber,
              );

              final events = _eventsForDay(day);

              final isToday = DateUtils.isSameDay(day, DateTime.now());

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DayViewScreen(date: day),
                    ),
                  ).then((_) => _loadEvents());
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: isToday
                        ? Border.all(color: const Color(0xFF8A4FFF), width: 2)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Text(
                          '$dayNumber',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isToday
                                ? const Color(0xFF8A4FFF)
                                : const Color(0xFF5A4A6A),
                          ),
                        ),
                      ),
                      if (events.isNotEmpty)
                        Positioned(
                          bottom: 6,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF8A4FFF),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _monthHeader() {
    final monthName = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ][_focusedMonth.month - 1];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Color(0xFF8A4FFF)),
            onPressed: _goToPreviousMonth,
          ),
          Text(
            '$monthName ${_focusedMonth.year}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF5A4A6A),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Color(0xFF8A4FFF)),
            onPressed: _goToNextMonth,
          ),
        ],
      ),
    );
  }

  Widget _weekdayRow() {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days
            .map(
              (d) => Text(
                d,
                style: const TextStyle(
                  color: Color(0xFF7A6F8F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
