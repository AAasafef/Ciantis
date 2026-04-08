import 'package:flutter/material.dart';
import '../../data/services/appointment_service.dart';
import '../../data/models/appointment_model.dart';
import 'appointment_create_screen.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final String appointmentId;

  const AppointmentDetailsScreen({super.key, required this.appointmentId});

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  final AppointmentService _appointmentService = AppointmentService();

  AppointmentModel? _appointment;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointment();
  }

  Future<void> _loadAppointment() async {
    final appt =
        await _appointmentService.getAppointmentById(widget.appointmentId);
    setState(() {
      _appointment = appt;
      _loading = false;
    });
  }

  Future<void> _toggleComplete() async {
    if (_appointment == null) return;

    if (!_appointment!.completed) {
      await _appointmentService.completeAppointment(_appointment!.id);
    }

    _loadAppointment();
  }

  Future<void> _deleteAppointment() async {
    if (_appointment == null) return;

    await _appointmentService.deleteAppointment(_appointment!.id);
    if (mounted) Navigator.pop(context);
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? "PM" : "AM";
    return "$h:$m $ampm";
  }

  Widget _infoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF7A6F8F),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color ?? const Color(0xFF5A4A6A),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7F4F9),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_appointment == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7F4F9),
        body: Center(
          child: Text(
            "Appointment not found",
            style: TextStyle(
              color: Color(0xFF7A6F8F),
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    final appt = _appointment!;
    final completed = appt.completed;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Appointment Details',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFF8A4FFF)),
            onPressed: _deleteAppointment,
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
              appt.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5A4A6A),
              ),
            ),

            const SizedBox(height: 12),

            // Description
            if (appt.description != null && appt.description!.isNotEmpty)
              Text(
                appt.description!,
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
                  onTap: _toggleComplete,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: completed
                          ? const Color(0xFF8A4FFF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF8A4FFF),
                        width: 2,
                      ),
                    ),
                    child: completed
                        ? const Icon(Icons.check,
                            color: Colors.white, size: 20)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  completed ? "Completed" : "Mark as complete",
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
                      appt.category[0].toUpperCase() + appt.category.substring(1)),
                  _infoRow("Location", appt.location ?? "None"),
                  _infoRow("Start", _formatTime(appt.startTime)),
                  _infoRow("End", _formatTime(appt.endTime)),
                  _infoRow("Emotional Load", appt.emotionalLoad.toString()),
                  _infoRow("Fatigue Impact", appt.fatigueImpact.toString()),
                  _infoRow("Reminder",
                      appt.reminderEnabled ? "Enabled" : "Disabled"),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Edit Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AppointmentCreateScreen(),
                    ),
                  );
                  _loadAppointment();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF8A4FFF)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Edit Appointment',
                  style: TextStyle(
                    color: Color(0xFF8A4FFF),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
