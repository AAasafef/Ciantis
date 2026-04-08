import 'package:cloud_firestore/cloud_firestore.dart';
import '../dao/calendar_event_dao.dart';
import '../models/calendar_event_model.dart';

class CalendarEventRepository {
  final CalendarEventDao _dao = CalendarEventDao.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String _collection = 'calendar_events';

  // -----------------------------
  // ADD EVENT
  // -----------------------------
  Future<void> addEvent(CalendarEventModel event) async {
    // Local
    await _dao.insertEvent(event);

    // Cloud
    await _firestore.collection(_collection).doc(event.id).set(
      event.toFirestore(),
    );
  }

  // -----------------------------
  // UPDATE EVENT
  // -----------------------------
  Future<void> updateEvent(CalendarEventModel event) async {
    // Local
    await _dao.updateEvent(event);

    // Cloud
    await _firestore.collection(_collection).doc(event.id).update(
      event.toFirestore(),
    );
  }

  // -----------------------------
  // DELETE EVENT
  // -----------------------------
  Future<void> deleteEvent(String id) async {
    // Local
    await _dao.deleteEvent(id);

    // Cloud
    await _firestore.collection(_collection).doc(id).delete();
  }

  // -----------------------------
  // GET ALL EVENTS
  // -----------------------------
  Future<List<CalendarEventModel>> getAllEvents() async {
    // Load local first (fast)
    final local = await _dao.getAllEvents();

    // Sync cloud → local
    await _syncFromCloud();

    // Return updated local
    return await _dao.getAllEvents();
  }

  // -----------------------------
  // GET EVENT BY ID
  // -----------------------------
  Future<CalendarEventModel?> getEventById(String id) async {
    return await _dao.getEventById(id);
  }

  // -----------------------------
  // GET EVENTS IN DATE RANGE
  // -----------------------------
  Future<List<CalendarEventModel>> getEventsInRange(
      DateTime start, DateTime end) async {
    return await _dao.getEventsInRange(start, end);
  }

  // -----------------------------
  // SYNC CLOUD → LOCAL
  // -----------------------------
  Future<void> _syncFromCloud() async {
    final snapshot = await _firestore.collection(_collection).get();

    for (var doc in snapshot.docs) {
      final event = CalendarEventModel.fromFirestore(doc);
      await _dao.insertEvent(event);
    }
  }
}
