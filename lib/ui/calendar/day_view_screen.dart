import 'package:flutter/material.dart';
import '../../data/services/calendar_event_service.dart';
import '../../data/models/calendar_event_model.dart';
import 'create_event_screen.dart';
import 'event_details_screen.dart';

class DayViewScreen extends StatefulWidget {
  final DateTime date;

  const DayViewScreen({super.key, required this.date});

  @override
  State<DayViewScreen> createState() => _DayViewScreenState();
}

class _DayViewScreenState extends State<DayViewScreen> {
  final CalendarEventService _calendarService = CalendarEventService();

  List<CalendarEventModel> _events = [];
  List<DateTime> _idealWindows = [];
  bool _loading = true;
  bool _overloaded = false;

  @override
  void initState() {
    super.initState();
    _loadDayData();
  }

  Future<void> _loadDayData() async {
    final events = await _calendarService.getEventsInRange(
      DateTime(widget.date.year, widget.date.month, widget.date.day, 0, 0),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 23, 59),
    );

    final windows =
        await _calendarService.getIdealSchedulingWindows(widget.date);

    final overloaded =
        await _calendarService.isDayOverloaded(widget.date);

    setState(() {
      _events = events;
      _idealWindows = windows;
      _overloaded = overloaded;
      _loading = false;
    });
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final ampm = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        '${widget.date.month}/${widget.date.day}/${widget.date.year}';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          dateLabel,
          style: const TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8A4FFF),
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateEventScreen(
                defaultDate: widget.date,
              ),
            ),
          );
          _loadDayData();
        },
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_overloaded) _overloadBanner(),
          const SizedBox(height: 20),
          _sectionTitle('Events'),
          const SizedBox(height: 12),
          Expanded(
            child: _events.isEmpty
                ? const Center(
                    child: Text(
                      'No events today',
                      style: TextStyle(
                        color: Color(0xFF7A6F8F),
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _events.length,
                    itemBuilder: (context
