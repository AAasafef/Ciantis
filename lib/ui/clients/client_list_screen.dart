import 'package:flutter/material.dart';
import '../../data/services/client_service.dart';
import '../../data/models/client_model.dart';
import 'client_details_screen.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  final ClientService _clientService = ClientService();

  List<ClientModel> _clients = [];
  List<ClientModel> _filtered = [];
  bool _loading = true;

  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    final list = await _clientService.getAllClients();
    setState(() {
      _clients = list;
      _filtered = list;
      _loading = false;
    });
  }

  void _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _filtered = _clients);
      return;
    }

    final results = await _clientService.searchClients(query.trim());
    setState(() => _filtered = results);
  }

  Color _rankingColor(int score) {
    if (score >= 80) return const Color(0xFF8A4FFF);
    if (score >= 50) return const Color(0xFFB76EFF);
    if (score >= 20) return const Color(0xFFD8C7F5);
    return const Color(0xFFEDE7F8);
  }

  Widget _clientTile(ClientModel c) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ClientDetailsScreen(clientId: c.id),
          ),
        );
        _loadClients();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8E2F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left: Name + contact + last appointment
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5A4A6A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (c.phone != null)
                    Text(
                      c.phone!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7A6F8F),
                      ),
                    ),
                  if (c.email != null)
                    Text(
                      c.email!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7A6F8F),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    c.lastAppointment == null
                        ? "No visits yet"
                        : "Last visit: ${_formatDate(c.lastAppointment!)}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9A8FB0),
                    ),
                  ),
                ],
              ),
            ),

            // Right: Ranking badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _rankingColor(c.rankingScore).withOpacity(0.18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                c.rankingScore.toString(),
                style: TextStyle(
                  color: _rankingColor(c.rankingScore),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return "${dt.month}/${dt.day}/${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Clients",
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: _search,
                    decoration: InputDecoration(
                      hintText: "Search clients...",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search,
                          color: Color(0xFF8A4FFF)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                            const BorderSide(color: Color(0xFFE8E2F0)),
                      ),
                    ),
                  ),
                ),

                // Client list
                Expanded(
                  child: _filtered.isEmpty
                      ? const Center(
                          child: Text(
                            "No clients found",
                            style: TextStyle(
                              color: Color(0xFF7A6F8F),
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(20),
                          children: _filtered.map(_clientTile).toList(),
                        ),
                ),
              ],
            ),
    );
  }
}
