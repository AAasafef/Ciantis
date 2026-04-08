import 'package:flutter/material.dart';
import '../../data/services/calendar_service.dart';
import '../../data/models/calendar_day_model.dart';
import 'calendar_day_view.dart';

class CalendarMonthView extends StatefulWidget {
  const CalendarMonthView({super.key});

  @override
  State<CalendarMonthView> createState() => _CalendarMonthViewState();
}

class _CalendarMonthViewState extends State<CalendarMonthView> {
  final CalendarService _calendarService = CalendarService();

  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  Map<String, CalendarDayModel> _dayCache = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMonth();
  }

  Future<void> _loadMonth() async {
    setState(() => _loading = true);

    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDay = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);

    final Map<String, CalendarDayModel> cache = {};

    for (int i = 0; i < lastDay.day; i++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, i + 1);
      final model = await _calendarService.getDay(date);
      cache[date.toIso8601String()] = model;
    }

    setState(() {
      _dayCache = cache;
      _loading = false;
    });
  }

  void _changeMonth(int offset) {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + offset);
    });
    _loadMonth();
  }

  Color _scoreColor(int score) {
    if (score >= 25) return const Color(0xFF8A4FFF);
    if (score >= 15) return const Color(0xFFB76EFF);
    if (score >= 8) return const Color(0xFFD8C7F5);
    return const Color(0xFFEDE7F8);
  }

  Widget _dayCell(DateTime date) {
    final key = date.toIso8601String();
    final model = _dayCache[key];

    final isToday = DateTime.now().year == date.year &&
        DateTime.now().month == date.month &&
        DateTime.now().day == date.day;

    return GestureDetector(
      onTap: model == null
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CalendarDayView(date: date),
                ),
              );
            },
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isToday ? const Color(0xFF8A4FFF) : const Color(0xFFE8E2F0),
            width: isToday ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: model == null
            ? const SizedBox()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color:
                          isToday ? const Color(0xFF8A4FFF) : const Color(0xFF5A4A6A),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Emotional load dot
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _scoreColor(model.emotionalLoadScore),
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Fatigue dot
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _scoreColor(model.fatigueImpactScore),
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Busy dot
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _scoreColor(model.busynessScore),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  List<Widget> _buildGrid() {
    final firstDayOfMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final weekdayOffset = firstDayOfMonth.weekday % 7;

    final lastDay =
        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;

    final totalCells = weekdayOffset + lastDay;
    final rows = (totalCells / 7).ceil();

    List<Widget> grid = [];

    int dayCounter = 1;

    for (int r = 0; r < rows; r++) {
      List<Widget> row = [];

      for (int c = 0; c < 7; c++) {
        final cellIndex = r * 7 + c;

        if (cellIndex < weekdayOffset || dayCounter > lastDay) {
          row.add(Expanded(child: Container()));
        } else {
          final date =
              DateTime(_focusedMonth.year, _focusedMonth.month, dayCounter);
          row.add(Expanded(child: _dayCell(date)));
          dayCounter++;
        }
      }

      grid.add(Row(children: row));
    }

    return grid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "${_focusedMonth.month}/${_focusedMonth.year}",
          style: const TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Color(0xFF8A4FFF)),
            onPressed: () => _changeMonth(-1),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Color(0xFF8A4FFF)),
            onPressed: () => _changeMonth(1),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: _buildGrid(),
              ),
            ),
    );
  }
}
