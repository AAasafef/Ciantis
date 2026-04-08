import 'package:flutter/material.dart';
import '../../data/services/appointment_service.dart';
import '../../data/models/appointment_model.dart';
import 'appointment_create_screen.dart';
import 'appointment_details_screen.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  final AppointmentService _appointmentService = AppointmentService();

  List<AppointmentModel> _appointments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final appts = await _appointmentService.getAllAppointments();
    setState(() {
      _appointments = appts;
      _loading = false;
    });
  }

  Future<void> _toggleComplete(AppointmentModel appt) async {
    if (!appt.completed) {
      await _appointmentService.completeAppointment(appt.id);
    }
    _loadAppointments();
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? "PM" : "AM";
    return "$h:$m $ampm";
  }

  Widget _badge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _appointmentTile(AppointmentModel appt) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AppointmentDetailsScreen(appointmentId: appt.id),
          ),
        );
        _loadAppointments();
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
              onTap: () => _toggleComplete(appt),
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: appt.completed
                      ? const Color(0xFF8A4FFF)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF8A4FFF),
                    width: 2,
                  ),
                ),
                child: appt.completed
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
            ),

            const SizedBox(width: 16),

            // Title + time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appt.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: appt.completed
                          ? const Color(0xFF7A6F8F)
                          : const Color(0xFF5A4A6A),
                      decoration:
                          appt.completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${_formatTime(appt.startTime)} - ${_formatTime(appt.endTime)}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7A6F8F),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Emotional + fatigue badges
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _badge("E", appt.emotionalLoad.toString(),
                    const Color(0xFF8A4FFF)),
                const SizedBox(height: 6),
                _badge("F", appt.fatigueImpact.toString(),
                    const Color(0xFF5A4A6A)),
              ],
            ),
          ],
        ),
      ),
    );
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
          'Appointments',
          style: TextStyle(
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
                    'No appointments yet',
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

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8A4FFF),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AppointmentCreateScreen(),
            ),
          );
          _loadAppointments();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
