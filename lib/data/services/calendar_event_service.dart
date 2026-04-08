import 'package:uuid/uuid.dart';
import '../models/calendar_event_model.dart';
import '../repositories/calendar_event_repository.dart';

class CalendarEventService {
  final CalendarEventRepository _repository = CalendarEventRepository();
  final Uuid _uuid = const Uuid();

  // -----------------------------
  // CREATE EVENT
  // -----------------------------
  Future<void> createEvent({
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    required String category,
    bool isAllDay = false,
    String? location,
  }) async {
    final now = DateTime.now();

    // Emotional intelligence scoring
    final emotionalLoad = _calculateEmotionalLoad(category);
    final fatigueImpact = _calculateFatigueImpact(category, startTime, endTime);

    final event = CalendarEventModel(
      id: _uuid.v4(),
      title: title.trim(),
      description: description?.trim(),
      startTime: startTime,
      endTime: endTime,
      category: category,
      isAllDay: isAllDay,
      location: location,
      emotionalLoad: emotionalLoad,
      fatigueImpact: fatigueImpact,
      createdAt: now,
      updatedAt: now,
    );

    await _repository.addEvent(event);
  }

  // -----------------------------
  // UPDATE EVENT
  // -----------------------------
  Future<void> updateEvent(CalendarEventModel event) async {
    final updated = CalendarEventModel(
      id: event.id,
      title: event.title,
      description: event.description,
      startTime: event.startTime,
      endTime: event.endTime,
      category: event.category,
      isAllDay: event.isAllDay,
      location: event.location,
      emotionalLoad: _calculateEmotionalLoad(event.category),
      fatigueImpact:
          _calculateFatigueImpact(event.category, event.startTime, event.endTime),
      createdAt: event.createdAt,
      updatedAt: DateTime.now(),
    );

    await _repository.updateEvent(updated);
  }

  // -----------------------------
  // DELETE EVENT
  // -----------------------------
  Future<void> deleteEvent(String id) async {
    await _repository.deleteEvent(id);
  }

  // -----------------------------
  // GET ALL EVENTS
  // -----------------------------
  Future<List<CalendarEventModel>> getAllEvents() async {
    return await _repository.getAllEvents();
  }

  // -----------------------------
  // GET EVENT BY ID
  // -----------------------------
  Future<CalendarEventModel?> getEventById(String id) async {
    return await _repository.getEventById(id);
  }

  // -----------------------------
  // GET EVENTS IN DATE RANGE
  // -----------------------------
  Future<List<CalendarEventModel>> getEventsInRange(
      DateTime start, DateTime end) async {
    return await _repository.getEventsInRange(start, end);
  }

  // -----------------------------
  // EMOTIONAL LOAD ENGINE
  // -----------------------------
  int _calculateEmotionalLoad(String category) {
    switch (category) {
      case 'school':
        return 7;
      case 'kids':
        return 6;
      case 'salon':
        return 5;
      case 'health':
        return 8;
      case 'personal':
        return 3;
      default:
        return 4;
    }
  }

  // -----------------------------
  // FATIGUE IMPACT ENGINE
  // -----------------------------
  int _calculateFatigueImpact(
      String category, DateTime start, DateTime end) {
    final duration = end.difference(start).inMinutes;

    int base = 0;

    switch (category) {
      case 'school':
        base = 6;
        break;
      case 'kids':
        base = 7;
        break;
      case 'salon':
        base = 5;
        break;
      case 'health':
        base = 4;
        break;
      case 'personal':
        base = 2;
        break;
      default:
        base = 3;
    }

    if (duration > 120) base += 2;
    if (duration > 240) base += 
