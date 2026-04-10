import 'package:flutter/material.dart';
import '../../../data/models/appointment_model.dart';

class CalendarEventIndicators extends StatelessWidget {
  final List<AppointmentModel> appointments;
  final int maxDots;

  const CalendarEventIndicators({
    super.key,
    required this.appointments,
    this.maxDots = 3,
  });

  Color _dotColor(AppointmentModel a) {
    if (a.emotionalLoad >= 8) {
      return const Color(0xFFE573B5); // high emotional
    }
    if (a.fatigueImpact >= 8) {
      return const Color(0xFFFFC94A); // high fatigue
    }
    return const Color(0xFF8A4FFF); // default jewel tone
  }

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) return const SizedBox.shrink();

    final visible = appointments.take(maxDots).toList();
    final extra = appointments.length - visible.length;

    return Row(
      children: [
        ...visible.map(
          (a) => Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: _dotColor(a),
              shape: BoxShape.circle,
            ),
          ),
        ),
        if (extra > 0)
          Text(
            "+$extra",
            style: const TextStyle(
              color: Color(0xFF7A6F8F),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}
