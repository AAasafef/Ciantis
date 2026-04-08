import '../dao/appointment_dao.dart';
import '../models/appointment_model.dart';

class AppointmentRepository {
  final AppointmentDao _dao = AppointmentDao();

  // -----------------------------
  // ADD APPOINTMENT
  // -----------------------------
  Future<void> addAppointment(AppointmentModel appointment) async {
    await _dao.insertAppointment(appointment);
  }

  // -----------------------------
  // UPDATE APPOINTMENT
  // -----------------------------
  Future<void> updateAppointment(AppointmentModel appointment) async {
    await _dao.updateAppointment(appointment);
  }

  // -----------------------------
  // DELETE APPOINTMENT
  // -----------------------------
  Future<void> deleteAppointment(String id) async {
    await _dao.deleteAppointment(id);
  }

  // -----------------------------
  // GET ALL APPOINTMENTS
  // -----------------------------
  Future<List<AppointmentModel>> getAllAppointments() async {
    return await _dao.getAllAppointments();
  }

  // -----------------------------
  // GET APPOINTMENT BY ID
  // -----------------------------
  Future<AppointmentModel?> getAppointmentById(String id) async {
    return await _dao.getAppointmentById(id);
  }

  // -----------------------------
  // GET APPOINTMENTS BY DATE
  // -----------------------------
  Future<List<AppointmentModel>> getAppointmentsByDate(DateTime date) async {
    return await _dao.getAppointmentsByDate(date);
  }

  // -----------------------------
  // GET APPOINTMENTS BY CATEGORY
  // -----------------------------
  Future<List<AppointmentModel>> getAppointmentsByCategory(String category) async {
    return await _dao.getAppointmentsByCategory(category);
  }
}
