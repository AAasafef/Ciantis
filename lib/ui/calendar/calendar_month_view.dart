import 'package:flutter/material.dart';
import '../../data/services/appointment_service.dart';
import '../../data/models/appointment_model.dart';

class CalendarMonthView extends StatefulWidget {
  const CalendarMonthView({super.key});

  @override
  State<CalendarMonthView> createState() => _CalendarMonthViewState();
}

class _CalendarMonthViewState extends State<CalendarMonthView> {
  final AppointmentService _appointmentService = AppointmentService();

  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  Map<String, List<AppointmentModel>> _appointmentsByDay = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final all = await _appointmentService.getAllAppointments();

    final map = <String, List<AppointmentModel>>{};

    for (final a in all) {
      final key = "${a.startTime.year}-${a.startTime.month}-${a.startTime.day}";
      map.putIfAbsent(key, () => []);
      map[key]!.add(a);
    }

    setState(() {
      _appointmentsByDay = map;
      _loading = false;
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  void _prevMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  List<DateTime> _daysInMonth(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0);

    final days = <DateTime>[];

    for (int i = 0; i < first.weekday - 1; i++) {
      days.add(DateTime(0)); // empty placeholder
    }

    for (int d = 1; d <= last.day; d++) {
      days.add(DateTime(month.year, month.month, d));
    }

    return days;
  }

  Widget _dayCell(DateTime day) {
    if (day.year == 0) {
      return Container();
    }

    final key = "${day.year}-${day.month}-${day.day}";
    final hasAppts = _appointmentsByDay.containsKey(key);
    final appts = hasAppts ? _appointmentsByDay[key]! : [];

    return GestureDetector(
      onTap: () {
        if (appts.isNotEmpty) {
          Navigator.pushNamed(context, "/appointmentsForDay",
              arguments: day);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasAppts ? const Color(0xFF8A4FFF) : const Color(0xFFE8E2F0),
            width: hasAppts ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 12,
              child: Text(
                "${day.day}",
                style: const TextStyle(
                  color: Color(0xFF5A4A6A),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),

            if (hasAppts)
              Positioned(
                bottom: 10,
                left: 12,
                right: 12,
                child: Row(
                  children: appts.take(3).map((a) {
                    final color = a.emotionalLoad >= 7
                        ? const Color(0xFFE573B5)
                        : const Color(0xFF8A4FFF);

                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = _daysInMonth(_focusedMonth);

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
            onPressed: _prevMonth,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Color(0xFF8A4FFF)),
            onPressed: _nextMonth,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.count(
              crossAxisCount: 7,
              padding: const EdgeInsets.all(12),
              children: days.map(_dayCell).toList(),
            ),
    );
  }
}
