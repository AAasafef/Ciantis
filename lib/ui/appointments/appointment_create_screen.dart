import 'package:flutter/material.dart';
import '../../data/services/appointment_service.dart';

class AppointmentCreateScreen extends StatefulWidget {
  const AppointmentCreateScreen({super.key});

  @override
  State<AppointmentCreateScreen> createState() =>
      _AppointmentCreateScreenState();
}

class _AppointmentCreateScreenState extends State<AppointmentCreateScreen> {
  final AppointmentService _appointmentService = AppointmentService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _selectedCategory = 'personal';
  int _emotionalLoad = 5;
  int _fatigueImpact = 5;
  bool _reminderEnabled = false;

  DateTime? _startTime;
  DateTime? _endTime;

  final List<String> _categories = [
    'school',
    'kids',
    'salon',
    'health',
    'personal',
  ];

  // -----------------------------
  // PICK DATE + TIME
  // -----------------------------
  Future<DateTime?> _pickDateTime(DateTime? initial) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );

    if (date == null) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: initial != null
          ? TimeOfDay(hour: initial.hour, minute: initial.minute)
          : TimeOfDay.now(),
    );

    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  // -----------------------------
  // SAVE APPOINTMENT
  // -----------------------------
  Future<void> _saveAppointment() async {
    final title = _titleController.text.trim();
    if (title.isEmpty || _startTime == null || _endTime == null) return;

    await _appointmentService.createAppointment(
      title: title,
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      category: _selectedCategory,
      startTime: _startTime!,
      endTime: _endTime!,
      emotionalLoad: _emotionalLoad,
      fatigueImpact: _fatigueImpact,
      reminderEnabled: _reminderEnabled,
    );

    if (mounted) Navigator.pop(context);
  }

  Widget _categoryChip(String category) {
    final selected = category == _selectedCategory;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        margin: const EdgeInsets.only(right: 10, bottom: 10),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF8A4FFF)
              : const Color(0xFFE8E2F0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          category[0].toUpperCase() + category.substring(1),
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF5A4A6A),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _loadSelector({
    required String label,
    required int value,
    required Function(int) onChanged,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF5A4A6A),
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        DropdownButton<int>(
