import 'package:uuid/uuid.dart';
import '../models/client_model.dart';
import '../repositories/client_repository.dart';

class ClientService {
  final ClientRepository _repo = ClientRepository();
  final Uuid _uuid = const Uuid();

  // -----------------------------
  // CREATE CLIENT
  // -----------------------------
  Future<String> createClient({
    required String name,
    String? phone,
    String? email,
    String? notes,
    String? preferredServices,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();

    final client = ClientModel(
      id: id,
      name: name,
      phone: phone,
      email: email,
      notes: notes,
      preferredServices: preferredServices,
      lastAppointment: null,
      totalVisits: 0,
      rankingScore: 0,
      createdAt: now,
      updatedAt: now,
    );

    await _repo.addClient(client);
    return id;
  }

  // -----------------------------
  // UPDATE CLIENT
  // -----------------------------
  Future<void> updateClient(ClientModel client) async {
    final updated = client.copyWith(
      updatedAt: DateTime.now(),
    );
    await _repo.updateClient(updated);
  }

  // -----------------------------
  // DELETE CLIENT
  // -----------------------------
  Future<void> deleteClient(String id) async {
    await _repo.deleteClient(id);
  }

  // -----------------------------
  // GET CLIENT
  // -----------------------------
  Future<ClientModel?> getClient(String id) async {
    return await _repo.getClientById(id);
  }

  // -----------------------------
  // GET ALL CLIENTS
  // -----------------------------
  Future<List<ClientModel>> getAllClients() async {
    return await _repo.getAllClients();
  }

  // -----------------------------
  // SEARCH CLIENTS
  // -----------------------------
  Future<List<ClientModel>> searchClients(String query) async {
    return await _repo.searchClients(query);
  }

  // -----------------------------
  // RECORD APPOINTMENT VISIT
  // -----------------------------
  Future<void> recordVisit(String clientId) async {
    final client = await _repo.getClientById(clientId);
    if (client == null) return;

    final now = DateTime.now();

    final updated = client.copyWith(
      lastAppointment: now,
      totalVisits: client.totalVisits + 1,
      rankingScore: _calculateRanking(
        totalVisits: client.totalVisits + 1,
        lastAppointment: now,
      ),
      updatedAt: now,
    );

    await _repo.updateClient(updated);
  }

  // -----------------------------
  // CALCULATE RANKING SCORE
  // -----------------------------
  int _calculateRanking({
    required int totalVisits,
    required DateTime lastAppointment,
  }) {
    int score = 0;

    // Loyalty
    if (totalVisits >= 10) score += 40;
    else if (totalVisits >= 5) score += 25;
    else if (totalVisits >= 2) score += 10;

    // Recency
    final days = DateTime.now().difference(lastAppointment).inDays;
    if (days <= 7) score += 40;
    else if (days <= 30) score += 25;
    else if (days <= 90) score += 10;

    // Frequency bonus
    if (totalVisits >= 15) score += 20;

    return score.clamp(0, 100);
  }

  // -----------------------------
  // AI FOLLOW-UP SUGGESTION
  // -----------------------------
  String generateFollowUpSuggestion(ClientModel client) {
    if (client.lastAppointment == null) {
      return "This client hasn’t visited yet. A warm welcome message could build connection.";
    }

    final days = DateTime.now().difference(client.lastAppointment!).inDays;

    if (days > 90) {
      return "It’s been a while. A gentle check‑in could bring them back.";
    }

    if (days > 45) {
      return "A friendly reminder about seasonal maintenance could be helpful.";
    }

    if (days > 21) {
      return "This is a great time to suggest a refresh or touch‑up.";
    }

    if (client.totalVisits >= 5) {
      return "A loyalty appreciation message could deepen the relationship.";
    }

    return "A simple thank‑you message keeps the connection warm.";
  }

  // -----------------------------
  // CLIENT TIMELINE EVENTS
  // -----------------------------
  List<Map<String, dynamic>> buildTimeline(ClientModel client) {
    final List<Map<String, dynamic>> events = [];

    if (client.lastAppointment != null) {
      events.add({
        "title": "Last Appointment",
        "date": client.lastAppointment,
        "icon": "calendar",
      });
    }

    events.add({
      "title": "Total Visits",
      "value": client.totalVisits,
      "icon": "check",
    });

    events.add({
      "title": "Ranking Score",
      "value": client.rankingScore,
      "icon": "star",
    });

    if (client.preferredServices != null &&
        client.preferredServices!.trim().isNotEmpty) {
      events.add({
        "title": "Preferred Services",
        "value": client.preferredServices,
        "icon": "heart",
      });
    }

    return events;
  }
}