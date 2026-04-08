import 'package:uuid/uuid.dart';
import '../models/appointment_model.dart';
import '../repositories/appointment_repository.dart';
import 'mode_engine_service.dart';

class AppointmentService {
  final AppointmentRepository _repository = AppointmentRepository();
  final ModeEngineService _modeEngine = ModeEngineService();
  final Uuid _uuid = const Uuid();

  // -----------------------------
  // CREATE APPOINTMENT
  // -----------------------------
  Future<void> createAppointment({
    required String title,
    String? description,
    String? location,
    required String category,
    required DateTime startTime,
    required DateTime endTime,
    required int emotionalLoad,
    required int fatigueImpact,
    required bool reminderEnabled,
  }) async {
    final now = DateTime.now();

    final appointment = AppointmentModel(
      id: _uuid.v4(),
      title: title.trim(),
      description: description?.trim(),
      location: location?.trim(),
      category: category,
      startTime: startTime,
      endTime: endTime,
      emotionalLoad: emotionalLoad.clamp(1, 10),
      fatigueImpact: fatigueImpact.clamp(1, 10),
      reminderEnabled: reminderEnabled,
      completed: false,
      createdAt: now,
      updatedAt: now,
    );

    await _repository.addAppointment(appointment);

    // MODE ENGINE HOOK
    final suggestion = _modeEngine.evaluateAppointmentImpact(
      emotionalLoad: emotionalLoad,
      fatigue: fatigueImpact,
      durationMinutes: endTime.difference(startTime).inMinutes,
    );

    _modeEngine.setSuggestion(suggestion);
  }

  // -----------------------------
  // UPDATE APPOINTMENT
  // -----------------------------
  Future<void> updateAppointment(AppointmentModel appointment) async {
    final updated = appointment.copyWith(
      updatedAt: DateTime.now(),
    );

    await _repository.updateAppointment(updated);

    // MODE ENGINE HOOK
    final suggestion = _modeEngine.evaluateAppointmentImpact(
      emotionalLoad: updated.emotionalLoad,
      fatigue: updated.fatigueImpact,
      durationMinutes:
          updated.endTime.difference(updated.startTime).inMinutes,
    );

    _modeEngine.setSuggestion(suggestion);
  }

  // -----------------------------
  // DELETE APPOINTMENT
  // -----------------------------
  Future<void> deleteAppointment(String id) async {
    await _repository.deleteAppointment(id);
  }

  // -----------------------------
  // GET ALL APPOINTMENTS
  // -----------------------------
  Future<List<AppointmentModel>> getAllAppointments() async {
    return await _repository.getAllAppointments();
  }

  // -----------------------------
  // GET APPOINTMENT BY ID
  // -----------------------------
  Future<AppointmentModel?> getAppointmentById(String id) async {
    return await _repository.getAppointmentById(id);
  }

  // -----------------------------
  // COMPLETE APPOINTMENT
  // -----------------------------
  Future<void> completeAppointment(String id) async {
    final appointment = await _repository.getAppointmentById(id);
    if (appointment == null) return;

    final updated = appointment.copyWith(
      completed: true,
      updatedAt: DateTime.now(),
    );

    await _repository.updateAppointment(updated);

    // MODE ENGINE HOOK
    final suggestion = _modeEngine.evaluateAppointmentImpact(
      emotionalLoad: updated.emotionalLoad,
      fatigue: updated.fatigueImpact,
      durationMinutes:
          updated.endTime.difference(updated.startTime).inMinutes,
    );

    _modeEngine.setSuggestion(suggestion);
  }

  // -----------------------------
  // GET APPOINTMENTS FOR A SPECIFIC DAY
  // -----------------------------
  Future<List<AppointmentModel>> getAppointmentsForDay(DateTime date) async {
    return await _repository.getAppointmentsByDate(date);
  }

  // -----------------------------
  // SMART APPOINTMENT INSIGHTS
  // -----------------------------
  Future<List<AppointmentModel>> getSmartInsights() async {
    final appointments = await getAllAppointments();

    appointments.sort((a, b) {
      int scoreA = _appointmentScore(a);
      int scoreB = _appointmentScore(b);
      return scoreB.compareTo(scoreA);
    });

    return appointments.take(5).toList();
  }

  int _appointmentScore(AppointmentModel appt) {
    int score = 0;

    // Emotional load weighting
    score += appt.emotionalLoad * 5;

    // Fatigue impact weighting
    score += appt.fatigueImpact * 4;

    // Duration weighting
    final duration = appt.endTime.difference(appt.startTime).inMinutes;
    score += (duration ~/ 15);

    // Upcoming weighting
    final diffHours = appt.startTime.difference(DateTime.now()).inHours;
    if (diffHours <= 0) {
      score += 40; // happening now or overdue
    } else {
      score += (80 ~/ diffHours.clamp(1, 80));
    }

    return score;
  }
}
