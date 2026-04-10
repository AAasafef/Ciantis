import 'package:flutter/material.dart';
import '../../data/services/appointment_service.dart';
import '../../data/models/appointment_model.dart';

class CalendarWeekView extends StatefulWidget {
  const CalendarWeekView({super.key});

  @override
  State<CalendarWeekView> createState() => _CalendarWeekViewState();
}

class _CalendarWeekViewState extends State<CalendarWeekView> {
  final AppointmentService _appointmentService = AppointmentService();

  DateTime _selectedDay = DateTime.now();
  List<AppointmentModel> _appointments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final list = await _appointmentService.getAppointmentsByDate(_selectedDay);
    setState(() {
      _appointments = list;
      _loading = false;
    });
  }

  List<DateTime> _weekDays(DateTime anchor) {
    final monday = anchor.subtract(Duration(days: anchor.weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  Widget _dayChip(DateTime day) {
    final isSelected =
        day.year == _selectedDay.year &&
        day.month == _selectedDay.month &&
        day.day == _selectedDay.day;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = day;
          _loading = true;
        });
        _loadAppointments();
      },
      child: Container(
        width: 48,
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8A4FFF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF8A4FFF)
                : const Color(0xFFE8E2F0),
          ),
        ),
        child: Column(
          children: [
            Text(
              ["M", "T", "W", "T", "F", "S", "S"][day.weekday - 1],
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF5A4A6A),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${day.day}",
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF5A4A6A),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appointmentTile(AppointmentModel a) {
    final emotionalColor = a.emotionalLoad >= 7
        ? const Color(0xFFE573B5)
        : const Color(0xFF8A4FFF);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8E2F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: emotionalColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.title,
                  style: const TextStyle(
                    color: Color(0xFF5A4A6A),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${a.startTime.hour.toString().padLeft(2, '0')}:${a.startTime.minute.toString().padLeft(2, '0')}  →  ${a.endTime.hour.toString().padLeft(2, '0')}:${a.endTime.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    color: Color(0xFF7A6F8F),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final week = _weekDays(_selectedDay);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Week View",
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Week strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: week.map(_dayChip).toList(),
            ),
          ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _appointments.isEmpty
                    ? const Center(
                        child: Text(
                          "No appointments",
                          style: TextStyle(
                            color: Color(0xFF7A6F8F),
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(20),
                        children: _appointments.map(_appointmentTile).toList(),
                      ),
          ),
        ],
      ),
    );
  }
}
