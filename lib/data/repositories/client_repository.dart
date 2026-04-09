import '../dao/client_dao.dart';
import '../models/client_model.dart';

class ClientRepository {
  final ClientDao _dao = ClientDao();

  // -----------------------------
  // ADD CLIENT
  // -----------------------------
  Future<void> addClient(ClientModel client) async {
    await _dao.insertClient(client);
  }

  // -----------------------------
  // UPDATE CLIENT
  // -----------------------------
  Future<void> updateClient(ClientModel client) async {
    await _dao.updateClient(client);
  }

  // -----------------------------
  // DELETE CLIENT
  // -----------------------------
  Future<void> deleteClient(String id) async {
    await _dao.deleteClient(id);
  }

  // -----------------------------
  // GET ALL CLIENTS
  // -----------------------------
  Future<List<ClientModel>> getAllClients() async {
    return await _dao.getAllClients();
  }

  // -----------------------------
  // GET CLIENT BY ID
  // -----------------------------
  Future<ClientModel?> getClientById(String id) async {
    return await _dao.getClientById(id);
  }

  // -----------------------------
  // SEARCH CLIENTS
  // -----------------------------
  Future<List<ClientModel>> searchClients(String query) async {
    return await _dao.searchClients(query);
  }

  // -----------------------------
  // GET TOP RANKED CLIENTS
  // -----------------------------
  Future<List<ClientModel>> getTopRankedClients() async {
    return await _dao.getTopRankedClients();
  }
}