import 'package:flutter/material.dart';
import '../../data/services/appointment_service.dart';
import '../../data/models/appointment_model.dart';

class CalendarDayView extends StatefulWidget {
  final DateTime date;

  const CalendarDayView({super.key, required this.date});

  @override
  State<CalendarDayView> createState() => _CalendarDayViewState();
}

class _CalendarDayViewState extends State<CalendarDayView> {
  final AppointmentService _appointmentService = AppointmentService();

  bool _loading = true;
  List<AppointmentModel> _appointments = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await _appointmentService.getAppointmentsByDate(widget.date);
    setState(() {
      _appointments = list;
      _loading = false;
    });
  }

  Widget _appointmentTile(AppointmentModel a) {
    final emotionalColor = a.emotionalLoad >= 7
        ? const Color(0xFFE573B5)
        : const Color(0xFF8A4FFF);

    final fatigueColor = a.fatigueImpact >= 7
        ? const Color(0xFFFFC94A)
        : const Color(0xFF5A4A6A);

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
          // Time
          Container(
            width: 70,
            child: Text(
              "${a.startTime.hour.toString().padLeft(2, '0')}:${a.startTime.minute.toString().padLeft(2, '0')}",
              style: const TextStyle(
                color: Color(0xFF5A4A6A),
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Main content
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
                if (a.location != null && a.location!.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      a.location!,
                      style: const TextStyle(
                        color: Color(0xFF7A6F8F),
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Emotional + fatigue dots
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: emotionalColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: fatigueColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        "${widget.date.month}/${widget.date.day}/${widget.date.year}";

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          dateLabel,
          style: const TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _appointments.isEmpty
              ? const Center(
                  child: Text(
                    "No appointments today",
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
    );
  }
}
