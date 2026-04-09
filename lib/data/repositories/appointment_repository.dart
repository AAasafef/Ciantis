import '../dao/appointment_dao.dart';
import '../models/appointment_model.dart';

class AppointmentRepository {
  final AppointmentDao _dao = AppointmentDao();

  // -----------------------------
  // ADD
  // -----------------------------
  Future<void> addAppointment(AppointmentModel appt) async {
    await _dao.insertAppointment(appt);
  }

  // -----------------------------
  // UPDATE
  // -----------------------------
  Future<void> updateAppointment(AppointmentModel appt) async {
    await _dao.updateAppointment(appt);
  }

  // -----------------------------
  // DELETE
  // -----------------------------
  Future<void> deleteAppointment(String id) async {
    await _dao.deleteAppointment(id);
  }

  // -----------------------------
  // GET ALL
  // -----------------------------
  Future<List<AppointmentModel>> getAllAppointments() async {
    return await _dao.getAllAppointments();
  }

  // -----------------------------
  // GET BY DATE
  // -----------------------------
  Future<List<AppointmentModel>> getAppointmentsByDate(DateTime date) async {
    return await _dao.getAppointmentsByDate(date);
  }

  // -----------------------------
  // UPCOMING
  // -----------------------------
  Future<List<AppointmentModel>> getUpcomingAppointments() async {
    return await _dao.getUpcomingAppointments();
  }

  // -----------------------------
  // SEARCH
  // -----------------------------
  Future<List<AppointmentModel>> searchAppointments(String query) async {
    return await _dao.searchAppointments(query);
  }

  // -----------------------------
  // SORTING
  // -----------------------------
  Future<List<AppointmentModel>> sortByEmotionalLoad({bool ascending = true}) async {
    return await _dao.sortByEmotionalLoad(ascending: ascending);
  }

  Future<List<AppointmentModel>> sortByFatigueImpact({bool ascending = true}) async {
    return await _dao.sortByFatigueImpact(ascending: ascending);
  }
}
