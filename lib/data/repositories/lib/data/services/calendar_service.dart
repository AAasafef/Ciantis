import 'package:uuid/uuid.dart';
import '../models/calendar_day_model.dart';
import '../models/appointment_model.dart';
import '../models/task_model.dart';
import '../repositories/calendar_repository.dart';
import 'appointment_service.dart';
import 'task_service.dart';
import 'mode_engine_service.dart';

class CalendarService {
  final CalendarRepository _calendarRepo = CalendarRepository();
  final AppointmentService _appointmentService = AppointmentService();
  final TaskService _taskService = TaskService();
  final ModeEngineService _modeEngine = ModeEngineService();
  final Uuid _uuid = const Uuid();

  // -----------------------------
  // GET CALENDAR DAY MODEL
  // -----------------------------
  Future<CalendarDayModel> getDay(DateTime date) async {
    final normalized = DateTime(date.year, date.month, date.day);

    // Fetch appointments + tasks
    final appointments =
        await _appointmentService.getAppointmentsForDay(normalized);

    final tasks = await _taskService.getTasksForDate(normalized);

    // Compute scores
    final emotionalScore = _computeEmotionalLoad(appointments, tasks);
    final fatigueScore = _computeFatigueImpact(appointments, tasks);
    final busyScore = _computeBusyness(appointments, tasks);

    // AI insight
    final insight = _generateInsight(
      emotionalScore: emotionalScore,
      fatigueScore: fatigueScore,
      busyScore: busyScore,
      appointments: appointments,
      tasks: tasks,
    );

    return CalendarDayModel(
      date: normalized,
      appointments: appointments,
      tasks: tasks,
      emotionalLoadScore: emotionalScore,
      fatigueImpactScore: fatigueScore,
      busynessScore: busyScore,
      aiInsight: insight,
    );
  }

  // -----------------------------
  // EMOTIONAL LOAD
  // -----------------------------
  int _computeEmotionalLoad(
      List<AppointmentModel> appts, List<TaskModel> tasks) {
    int score = 0;

    for (var a in appts) {
      score += a.emotionalLoad;
    }
    for (var t in tasks) {
      score += t.emotionalLoad;
    }

    return score;
  }

  // -----------------------------
  // FATIGUE IMPACT
  // -----------------------------
  int _computeFatigueImpact(
      List<AppointmentModel> appts, List<TaskModel> tasks) {
    int score = 0;

    for (var a in appts) {
      score += a.fatigueImpact;
    }
    for (var t in tasks) {
      score += t.fatigueImpact;
    }

    return score;
  }

  // -----------------------------
  // BUSYNESS SCORE
  // -----------------------------
  int _computeBusyness(
      List<AppointmentModel> appts, List<TaskModel> tasks) {
    int score = 0;

    // Appointments: duration weighting
    for (var a in appts) {
      final duration = a.endTime.difference(a.startTime).inMinutes;
      score += (duration ~/ 15);
    }

    // Tasks: each task adds weight
    score += tasks.length * 3;

    return score;
  }

  // -----------------------------
  // AI INSIGHT GENERATION
  // -----------------------------
  String _generateInsight({
    required int emotionalScore,
    required int fatigueScore,
    required int busyScore,
    required List<AppointmentModel> appointments,
    required List<TaskModel> tasks,
  }) {
    // Mode Engine hook
    final mode = _modeEngine.currentMode;

    // Emotional-heavy day
    if (emotionalScore >= 25) {
      return "Today carries a high emotional load. Build in grounding moments and avoid unnecessary stressors.";
    }

    // Fatigue-heavy day
    if (fatigueScore >= 25) {
      return "Your day may feel physically draining. Prioritize rest between commitments.";
    }

    // Busy day
    if (busyScore >= 20) {
      return "Your schedule is packed. Keep transitions smooth and hydrate.";
    }

    // Light day
    if (appointments.isEmpty && tasks.isEmpty) {
      return "A calm day. Use this space to recharge or get ahead gently.";
    }

    // Mode-aware insight
    switch (mode) {
      case AppMode.recovery:
        return "Your system is in recovery mode. Move slowly and choose low-impact tasks.";
      case AppMode.focus:
        return "A good day for deep work. Protect your focus windows.";
      case AppMode.overloaded:
        return "You're carrying a lot. Simplify your commitments where possible.";
      default:
        return "A balanced day. Move with intention and stay hydrated.";
    }
  }

  // -----------------------------
  // SAVE META (OPTIONAL)
  // -----------------------------
  Future<void> saveMeta({
    required DateTime date,
    String? note,
    String? tag,
  }) async {
    final normalized = DateTime(date.year, date.month, date.day);

    final meta = {
      'id': _uuid.v4(),
      'date': normalized.toIso8601String(),
      'note': note,
      'tag': tag,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    await _calendarRepo.addMeta(meta);
  }

  // -----------------------------
  // UPDATE META
  // -----------------------------
  Future<void> updateMeta(Map<String, dynamic> meta) async {
    meta['updatedAt'] = DateTime.now().toIso8601String();
    await _calendarRepo.updateMeta(meta);
  }

  // -----------------------------
  // GET META FOR DATE
  // -----------------------------
  Future<Map<String, dynamic>?> getMetaForDate(DateTime date) async {
    return await _calendarRepo.getMetaForDate(date);
  }
}
