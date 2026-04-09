import 'package:flutter/material.dart';
import '../../data/services/client_service.dart';
import '../../data/models/client_model.dart';

class ClientTimelineScreen extends StatefulWidget {
  final String clientId;

  const ClientTimelineScreen({super.key, required this.clientId});

  @override
  State<ClientTimelineScreen> createState() => _ClientTimelineScreenState();
}

class _ClientTimelineScreenState extends State<ClientTimelineScreen> {
  final ClientService _clientService = ClientService();

  ClientModel? _client;
  List<Map<String, dynamic>> _events = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTimeline();
  }

  Future<void> _loadTimeline() async {
    final c = await _clientService.getClient(widget.clientId);
    if (c == null) return;

    final timeline = _clientService.buildTimeline(c);

    setState(() {
      _client = c;
      _events = timeline;
      _loading = false;
    });
  }

  IconData _iconFor(String icon) {
    switch (icon) {
      case "calendar":
        return Icons.calendar_month;
      case "check":
        return Icons.check_circle;
      case "star":
        return Icons.star;
      case "heart":
        return Icons.favorite;
      default:
        return Icons.circle;
    }
  }

  Color _iconColor(String icon) {
    switch (icon) {
      case "calendar":
        return const Color(0xFF8A4FFF);
      case "check":
        return const Color(0xFFB76EFF);
      case "star":
        return const Color(0xFFFFC94A);
      case "heart":
        return const Color(0xFFE573B5);
      default:
        return const Color(0xFF8A4FFF);
    }
  }

  String _formatDate(DateTime dt) {
    return "${dt.month}/${dt.day}/${dt.year}";
  }

  Widget _timelineItem(Map<String, dynamic> event) {
    final icon = event["icon"] as String;
    final title = event["title"] as String;
    final value = event["value"];
    final date = event["date"];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _iconColor(icon).withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _iconFor(icon),
            color: _iconColor(icon),
            size: 20,
          ),
        ),

        const SizedBox(width: 16),

        // Content
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(bottom: 24),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Color(0xFFE8E2F0),
                  width: 2,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF5A4A6A),
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (value != null)
                    Text(
                      value.toString(),
                      style: const TextStyle(
                        color: Color(0xFF7A6F8F),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  if (date != null)
                    Text(
                      _formatDate(date),
                      style: const TextStyle(
                        color: Color(0xFF9A8FB0),
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
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

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "${_client!.name}'s Timeline",
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
            // Header card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE8E2F0)),
              ),
              child: Column(
                children: [
                  Text(
                    _client!.name,
                    style: const TextStyle(
                      color: Color(0xFF5A4A6A),
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Client Timeline",
                    style: const TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Timeline items
            Column(
              children: _events.map(_timelineItem).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
