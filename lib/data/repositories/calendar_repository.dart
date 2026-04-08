import '../dao/calendar_dao.dart';

class CalendarRepository {
  final CalendarDao _dao = CalendarDao();

  // -----------------------------
  // ADD META
  // -----------------------------
  Future<void> addMeta(Map<String, dynamic> meta) async {
    await _dao.insertMeta(meta);
  }

  // -----------------------------
  // UPDATE META
  // -----------------------------
  Future<void> updateMeta(Map<String, dynamic> meta) async {
    await _dao.updateMeta(meta);
  }

  // -----------------------------
  // DELETE META
  // -----------------------------
  Future<void> deleteMeta(String id) async {
    await _dao.deleteMeta(id);
  }

  // -----------------------------
  // GET META FOR DATE
  // -----------------------------
  Future<Map<String, dynamic>?> getMetaForDate(DateTime date) async {
    return await _dao.getMetaForDate(date);
  }

  // -----------------------------
  // GET ALL META
  // -----------------------------
  Future<List<Map<String, dynamic>>> getAllMeta() async {
    return await _dao.getAllMeta();
  }
}
