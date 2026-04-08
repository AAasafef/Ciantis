import 'package:flutter/material.dart';
import '../../data/services/appointment_service.dart';
import '../../data/models/appointment_model.dart';
import 'appointment_details_screen.dart';

class AppointmentInsightsScreen extends StatefulWidget {
  const AppointmentInsightsScreen({super.key});

  @override
  State<AppointmentInsightsScreen> createState() =>
      _AppointmentInsightsScreenState();
}

class _AppointmentInsightsScreenState
    extends State<AppointmentInsightsScreen> {
  final AppointmentService _appointmentService = AppointmentService();

  List<AppointmentModel> _insights = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    final appts = await _appointmentService.getSmartInsights();
    setState(() {
      _insights = appts;
      _loading = false;
    });
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? "PM" : "AM";
    return "$h:$m $ampm";
  }

  Widget _badge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _insightCard(AppointmentModel appt) {
    final duration =
        appt.endTime.difference(appt.startTime).inMinutes.toString();

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                AppointmentDetailsScreen(appointmentId: appt.id),
          ),
        );
        _loadInsights();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE8E2F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              appt.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5A4A6A),
              ),
            ),

            const SizedBox(height: 8),

            // Time
            Text(
              "${_formatTime(appt.startTime)} - ${_formatTime(appt.endTime)}",
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7A6F8F),
              ),
            ),

            const SizedBox(height: 16),

            // Emotional + fatigue + duration
            Row(
              children: [
                _badge("Emotional", appt.emotionalLoad.toString(),
                    const Color(0xFF8A4FFF)),
                const SizedBox(width: 10),
                _badge("Fatigue", appt.fatigueImpact.toString(),
                    const Color(0xFF5A4A6A)),
                const SizedBox(width: 10),
                _badge("Duration", "$duration min",
                    const Color(0xFFB76EFF)),
              ],
            ),

            const SizedBox(height: 16),

            // Suggestion text
            Text(
              "Ciantis suggests preparing emotionally and physically for this appointment.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(0.55),
                height: 1.4,
              ),
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
          'Appointment Insights',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _insights.isEmpty
              ? const Center(
                  child: Text(
                    'No insights available',
                    style: TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: _insights.map(_insightCard).toList(),
                ),
    );
  }
}
