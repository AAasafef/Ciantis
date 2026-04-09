import 'package:flutter/material.dart';
import '../../data/services/client_service.dart';
import '../../data/models/client_model.dart';
import 'client_timeline_screen.dart';

class ClientDetailsScreen extends StatefulWidget {
  final String clientId;

  const ClientDetailsScreen({super.key, required this.clientId});

  @override
  State<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  final ClientService _clientService = ClientService();

  ClientModel? _client;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadClient();
  }

  Future<void> _loadClient() async {
    final c = await _clientService.getClient(widget.clientId);
    setState(() {
      _client = c;
      _loading = false;
    });
  }

  Color _rankingColor(int score) {
    if (score >= 80) return const Color(0xFF8A4FFF);
    if (score >= 50) return const Color(0xFFB76EFF);
    if (score >= 20) return const Color(0xFFD8C7F5);
    return const Color(0xFFEDE7F8);
  }

  String _formatDate(DateTime dt) {
    return "${dt.month}/${dt.day}/${dt.year}";
  }

  Widget _infoRow(String label, String? value) {
    if (value == null || value.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              color: Color(0xFF5A4A6A),
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF7A6F8F),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF8A4FFF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7F4F9),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final c = _client!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          c.name,
          style: const TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Ranking badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: _rankingColor(c.rankingScore).withOpacity(0.18),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                "Ranking: ${c.rankingScore}",
                style: TextStyle(
                  color: _rankingColor(c.rankingScore),
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Contact actions
            Row(
              children: [
                _actionButton(Icons.call, "Call", () {}),
                const SizedBox(width: 12),
                _actionButton(Icons.message, "Text", () {}),
                const SizedBox(width: 12),
                _actionButton(Icons.email, "Email", () {}),
              ],
            ),

            const SizedBox(height: 30),

            // Info card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE8E2F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow("Phone", c.phone),
                  _infoRow("Email", c.email),
                  _infoRow("Preferred", c.preferredServices),
                  _infoRow("Notes", c.notes),
                  _infoRow(
                    "Last Visit",
                    c.lastAppointment == null
                        ? "No visits yet"
                        : _formatDate(c.lastAppointment!),
                  ),
                  _infoRow("Total Visits", c.totalVisits.toString()),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // AI Follow-up suggestion
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF8A4FFF).withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                _clientService.generateFollowUpSuggestion(c),
                style: const TextStyle(
                  color: Color(0xFF5A4A6A),
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Timeline button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A4FFF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ClientTimelineScreen(clientId: c.id),
                    ),
                  );
                },
                child: const Text(
                  "View Timeline",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}