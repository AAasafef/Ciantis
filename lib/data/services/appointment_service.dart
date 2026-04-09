import 'package:uuid/uuid.dart';
import '../models/appointment_model.dart';
import '../repositories/appointment_repository.dart';

class AppointmentService {
  final AppointmentRepository _repo = AppointmentRepository();
  final Uuid _uuid = const Uuid();

  // -----------------------------
  // CREATE APPOINTMENT
  // -----------------------------
  Future<String> createAppointment({
    required String title,
    String? description,
    String? location,
    required String category,
    required DateTime startTime,
    required DateTime endTime,
    required int emotionalLoad,
    required int fatigueImpact,
    bool reminderEnabled = false,
    int? reminderMinutesBefore,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();

    final appt = AppointmentModel(
      id: id,
      title: title,
      description: description,
      location: location,
      category: category,
      startTime: startTime,
      endTime: endTime,
      emotionalLoad: emotionalLoad,
      fatigueImpact: fatigueImpact,
      isCompleted: false,
      reminderEnabled: reminderEnabled,
      reminderMinutesBefore: reminderMinutesBefore,
      createdAt: now,
      updatedAt: now,
    );

    await _repo.addAppointment(appt);
    return id;
  }

  // -----------------------------
  // UPDATE APPOINTMENT
  // -----------------------------
  Future<void> updateAppointment(AppointmentModel appt) async {
    final updated = appt.copyWith(
      updatedAt: DateTime.now(),
    );
    await _repo.updateAppointment(updated);
  }

  // -----------------------------
  // DELETE APPOINTMENT
  // -----------------------------
  Future<void> deleteAppointment(String id) async {
    await _repo.deleteAppointment(id);
  }

  // -----------------------------
  // TOGGLE COMPLETION
  // -----------------------------
  Future<void> toggleCompletion(AppointmentModel appt) async {
    final updated = appt.copyWith(
      isCompleted: !appt.isCompleted,
      updatedAt: DateTime.now(),
    );
    await _repo.updateAppointment(updated);
  }

  // -----------------------------
  // GET ALL APPOINTMENTS
  // -----------------------------
  Future<List<AppointmentModel>> getAllAppointments() async {
    return await _repo.getAllAppointments();
  }

  // -----------------------------
  // GET APPOINTMENTS BY DATE
  // -----------------------------
  Future<List<AppointmentModel>> getAppointmentsByDate(DateTime date) async {
    return await _repo.getAppointmentsByDate(date);
  }

  // -----------------------------
  // UPCOMING APPOINTMENTS
  // -----------------------------
  Future<List<AppointmentModel>> getUpcomingAppointments() async {
    return await _repo.getUpcomingAppointments();
  }

  // -----------------------------
  // SEARCH
  // -----------------------------
  Future<List<AppointmentModel>> searchAppointments(String query) async {
    return await _repo.searchAppointments(query);
  }

  // -----------------------------
  // SORTING
  // -----------------------------
  Future<List<AppointmentModel>> sortByEmotionalLoad({bool ascending = true}) async {
    return await _repo.sortByEmotionalLoad(ascending: ascending);
  }

  Future<List<AppointmentModel>> sortByFatigueImpact({bool ascending = true}) async {
    return await _repo.sortByFatigueImpact(ascending: ascending);
  }

  // -----------------------------
  // SMART INSIGHT: PRIORITY SCORE
  // -----------------------------
  int calculatePriorityScore(AppointmentModel appt) {
    // Weighted scoring:
    // Emotional load: 40%
    // Fatigue impact: 40%
    // Duration: 20%

    final durationMinutes =
        appt.endTime.difference(appt.startTime).inMinutes.clamp(0, 300);

    final emotionalScore = appt.emotionalLoad * 4;
    final fatigueScore = appt.fatigueImpact * 4;
    final durationScore = (durationMinutes / 15).clamp(0, 20).toInt();

    final total = emotionalScore + fatigueScore + durationScore;
    return total.clamp(0, 100);
  }

  // -----------------------------
  // SMART INSIGHT: RECOVERY SUGGESTION
  // -----------------------------
  String recoverySuggestion(AppointmentModel appt) {
    final load = appt.emotionalLoad;
    final fatigue = appt.fatigueImpact;

    if (load >= 8 || fatigue >= 8) {
      return "This appointment may be draining. Plan a recovery window afterward.";
    }

    if (load >= 5 || fatigue >= 5) {
      return "Consider a short break or grounding routine after this appointment.";
    }

    return "This appointment should be manageable. No special recovery needed.";
  }

  // -----------------------------
  // SMART INSIGHT: MODE ENGINE HOOK
  // -----------------------------
  Map<String, dynamic> modeImpact(AppointmentModel appt) {
    return {
      "emotionalLoad": appt.emotionalLoad,
      "fatigueImpact": appt.fatigueImpact,
      "priorityScore": calculatePriorityScore(appt),
      "recoverySuggestion": recoverySuggestion(appt),
    };
  }
}
