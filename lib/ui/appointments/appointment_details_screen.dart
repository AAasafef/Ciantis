import 'package:flutter/material.dart';
import '../../data/services/appointment_service.dart';
import '../../data/models/appointment_model.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final String appointmentId;

  const AppointmentDetailsScreen({super.key, required this.appointmentId});

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  final AppointmentService _appointmentService = AppointmentService();

  bool _loading = true;
  AppointmentModel? _appointment;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final all = await _appointmentService.getAllAppointments();
    final matches =
        all.where((a) => a.id == widget.appointmentId).toList();

    setState(() {
      _appointment = matches.isNotEmpty ? matches.first : null;
      _loading = false;
    });
  }

  Future<void> _toggleCompletion() async {
    if (_appointment == null) return;
    await _appointmentService.toggleCompletion(_appointment!);
    await _load();
  }

  Future<void> _delete() async {
    if (_appointment == null) return;
    await _appointmentService.deleteAppointment(_appointment!.id);
    if (mounted) Navigator.pop(context);
  }

  String _formatDateTime(DateTime dt) {
    final date = "${dt.month}/${dt.day}/${dt.year}";
    final time =
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    return "$date  •  $time";
  }

  Color _categoryColor(String category) {
    switch (category) {
      case "school":
        return const Color(0xFF8A4FFF);
      case "kids":
        return const Color(0xFFE573B5);
      case "salon":
        return const Color(0xFFB76EFF);
      case "health":
        return const Color(0xFFFFC94A);
      case "personal":
      default:
        return const Color(0xFF5A4A6A);
    }
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
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
      return Scaffold(
        backgroundColor: const Color(0xFFF7F4F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Appointment Details",
            style: TextStyle(
              color: Color(0xFF8A4FFF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: const Center(
          child: Text(
            "Appointment not found",
            style: TextStyle(
              color: Color(0xFF7A6F8F),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    final a = _appointment!;
    final priority = _appointmentService.calculatePriorityScore(a);
    final recovery = _appointmentService.recoverySuggestion(a);

    final emotionalColor = a.emotionalLoad >= 7
        ? const Color(0xFFE573B5)
        : const Color(0xFF8A4FFF);

    final fatigueColor = a.fatigueImpact >= 7
        ? const Color(0xFFFFC94A)
        : const Color(0xFF5A4A6A);

    final categoryColor = _categoryColor(a.category);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Appointment Details",
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFFE57373)),
            onPressed: _delete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header card
            Container(
              padding: const EdgeInsets.all(20),
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
                  GestureDetector(
                    onTap: _toggleCompletion,
                    child: Icon(
                      a.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: a.isCompleted
                          ? const Color(0xFF8A4FFF)
                          : const Color(0xFFB6AFC8),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.title,
                          style: const TextStyle(
                            color: Color(0xFF5A4A6A),
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _formatDateTime(a.startTime),
                          style: const TextStyle(
                            color: Color(0xFF7A6F8F),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "to ${_formatDateTime(a.endTime)}",
                          style: const TextStyle(
                            color: Color(0xFF9A8FB0),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Context card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE8E2F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Context",
                    style: TextStyle(
                      color: Color(0xFF5A4A6A),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _badge(a.category.toUpperCase(), categoryColor),
                      const SizedBox(width: 10),
                      if (a.location != null &&
                          a.location!.trim().isNotEmpty)
                        Expanded(
                          child: Text(
                            a.location!,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Color(0xFF7A6F8F),
                              fontSize: 13,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (a.description != null &&
                      a.description!.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Text(
                        a.description!,
                        style: const TextStyle(
                          color: Color(0xFF7A6F8F),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Emotional & energy card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE8E2F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Emotional & Energy",
                    style: TextStyle(
                      color: Color(0xFF5A4A6A),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _badge("Emotional ${a.emotionalLoad}", emotionalColor),
                      const SizedBox(width: 10),
                      _badge("Fatigue ${a.fatigueImpact}", fatigueColor),
                      const Spacer(),
                      _badge("Priority $priority", const Color(0xFF8A4FFF)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    recovery,
                    style: const TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Reminder card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Icon(
                    a.reminderEnabled
                        ? Icons.notifications_active
                        : Icons.notifications_off,
                    color: const Color(0xFF8A4FFF),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      a.reminderEnabled
                          ? "Reminder enabled • ${a.reminderMinutesBefore} minutes before"
                          : "No reminder set",
                      style: const TextStyle(
                        color: Color(0xFF5A4A6A),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
