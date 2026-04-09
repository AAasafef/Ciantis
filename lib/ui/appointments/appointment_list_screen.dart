import 'package:flutter/material.dart';
import '../../data/services/appointment_service.dart';
import '../../data/models/appointment_model.dart';
import 'appointment_details_screen.dart';
import 'appointment_create_screen.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  final AppointmentService _appointmentService = AppointmentService();

  bool _loading = true;
  List<AppointmentModel> _today = [];
  List<AppointmentModel> _upcoming = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final today = await _appointmentService.getAppointmentsByDate(DateTime.now());
    final upcoming = await _appointmentService.getUpcomingAppointments();

    setState(() {
      _today = today;
      _upcoming = upcoming.where((a) => !_isToday(a.startTime)).toList();
      _loading = false;
    });
  }

  bool _isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  Future<void> _toggle(AppointmentModel appt) async {
    await _appointmentService.toggleCompletion(appt);
    _load();
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

  Widget _appointmentTile(AppointmentModel a) {
    final emotionalColor = a.emotionalLoad >= 7
        ? const Color(0xFFE573B5)
        : const Color(0xFF8A4FFF);

    final fatigueColor = a.fatigueImpact >= 7
        ? const Color(0xFFFFC94A)
        : const Color(0xFF5A4A6A);

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AppointmentDetailsScreen(appointmentId: a.id),
          ),
        );
        _load();
      },
      child: Container(
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
            // Completion toggle
            GestureDetector(
              onTap: () => _toggle(a),
              child: Icon(
                a.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: a.isCompleted
                    ? const Color(0xFF8A4FFF)
                    : const Color(0xFFB6AFC8),
                size: 28,
              ),
            ),

            const SizedBox(width: 16),

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
                  const SizedBox(height: 6),
                  Text(
                    "${a.startTime.hour.toString().padLeft(2, '0')}:${a.startTime.minute.toString().padLeft(2, '0')}  →  ${a.endTime.hour.toString().padLeft(2, '0')}:${a.endTime.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontSize: 13,
                    ),
                  ),
                  if (a.location != null && a.location!.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        a.location!,
                        style: const TextStyle(
                          color: Color(0xFF9A8FB0),
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Badges
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _badge("E ${a.emotionalLoad}", emotionalColor),
                const SizedBox(height: 6),
                _badge("F ${a.fatigueImpact}", fatigueColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<AppointmentModel> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF5A4A6A),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              "No appointments",
              style: TextStyle(
                color: Color(0xFF7A6F8F),
                fontSize: 15,
              ),
            ),
          )
        else
          Column(
            children: list.map(_appointmentTile).toList(),
          ),
        const SizedBox(height: 30),
      ],
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
          "Appointments",
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
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
          _load();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _section("Today", _today),
                  _section("Upcoming", _upcoming),
                ],
              ),
            ),
    );
  }
}
