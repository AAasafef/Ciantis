import 'package:flutter/material.dart';
import '../../data/services/calendar_event_service.dart';
import '../../data/models/calendar_event_model.dart';
import 'create_event_screen.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;

  const EventDetailsScreen({super.key, required this.eventId});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final CalendarEventService _calendarService = CalendarEventService();

  CalendarEventModel? _event;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    final event = await _calendarService.getEventById(widget.eventId);
    setState(() {
      _event = event;
      _loading = false;
    });
  }

  Future<void> _deleteEvent() async {
    await _calendarService.deleteEvent(widget.eventId);
    if (mounted) Navigator.pop(context);
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final ampm = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
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
          'Event Details',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: Color(0xFF8A4FFF)),
            onPressed: _deleteEvent,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _event == null
              ? const Center(
                  child: Text(
                    'Event not found',
                    style: TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontSize: 16,
                    ),
                  ),
                )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final event = _event!;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            event.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF5A4A6A),
            ),
          ),
          const SizedBox(height: 8),

          // Description
          if (event.description != null &&
              event.description!.trim().isNotEmpty)
            Text(
              event.description!,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF7A6F8F),
              ),
            ),

          const SizedBox(height: 24),

          // Date + Time
          _sectionTitle('Date & Time'),
          const SizedBox(height: 6),
          Text(
            event.isAllDay
                ? '${_formatDate(event.startTime)} (All Day)'
                : '${_formatDate(event.startTime)} • ${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}',
            style: const TextStyle(
              color: Color(0xFF5A4A6A),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          // Category
          _sectionTitle('Category'),
          const SizedBox(height: 6),
          Text(
            event.category[0].toUpperCase() + event.category.substring(1),
            style: const TextStyle(
              color: Color(0xFF5A4A6A),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          // Location
          if (event.location != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Location'),
                const SizedBox(height: 6),
                Text(
                  event.location!,
                  style: const TextStyle(
                    color: Color(0xFF5A4A6A),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),

          // Emotional Load
          _sectionTitle('Emotional Load'),
          const SizedBox(height: 6),
          _scoreBar(event.emotionalLoad, Colors.pinkAccent),
          const SizedBox(height: 20),

          // Fatigue Impact
          _sectionTitle('Fatigue Impact'),
          const SizedBox(height: 6),
          _scoreBar(event.fatigueImpact, Colors.deepPurpleAccent),
          const SizedBox(height: 40),

          // Edit Button
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateEventScreen(
                      defaultDate: event.startTime,
                    ),
                  ),
                );
                _loadEvent();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8A4FFF),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Edit Event',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreBar(int value, Color color) {
    return Container(
      height: 12,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: value / 10,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF8A4FFF),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
