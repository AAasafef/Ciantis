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
          value: value,
          items: List.generate(
            10,
            (i) => DropdownMenuItem(
              value: i + 1,
              child: Text('${i + 1}'),
            ),
          ),
          onChanged: (v) => onChanged(v!),
        ),
      ],
    );
  }

  Widget _dateTimePicker({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE8E2F0),
            width: 1,
          ),
        ),
        child: Text(
          value == null
              ? label
              : "${value.month}/${value.day}/${value.year}  ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}",
          style: const TextStyle(
            color: Color(0xFF5A4A6A),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
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
          'New Appointment',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Title',
              style: TextStyle(
                color: Color(0xFF5A4A6A),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter appointment name',
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Description
            const Text(
              'Description',
              style: TextStyle(
                color: Color(0xFF5A4A6A),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Optional',
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Location
            const Text(
              'Location',
              style: TextStyle(
                color: Color(0xFF5A4A6A),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Optional',
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Category
            const Text(
              'Category',
              style: TextStyle(
                color: Color(0xFF5A4A6A),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              children: _categories.map(_categoryChip).toList(),
            ),

            const SizedBox(height: 20),

            // Start time
            const Text(
              'Start Time',
              style: TextStyle(
                color: Color(0xFF5A4A6A),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            _dateTimePicker(
              label: "Select start time",
              value: _startTime,
              onTap: () async {
                final dt = await _pickDateTime(_startTime);
                if (dt != null) setState(() => _startTime = dt);
              },
            ),

            const SizedBox(height: 20),

            // End time
            const Text(
              'End Time',
              style: TextStyle(
                color: Color(0xFF5A4A6A),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            _dateTimePicker(
              label: "Select end time",
              value: _endTime,
              onTap: () async {
                final dt = await _pickDateTime(_endTime);
                if (dt != null) setState(() => _endTime = dt);
              },
            ),

            const SizedBox(height: 20),

            // Emotional load
            _loadSelector(
              label: "Emotional Load",
              value: _emotionalLoad,
              onChanged: (v) => setState(() => _emotionalLoad = v),
            ),

            const SizedBox(height: 16),

            // Fatigue impact
            _loadSelector(
              label: "Fatigue Impact",
              value: _fatigueImpact,
              onChanged: (v) => setState(() => _fatigueImpact = v),
            ),

            const SizedBox(height: 20),

            // Reminder toggle
            Row(
              children: [
                const Text(
                  "Reminder",
                  style: TextStyle(
                    color: Color(0xFF5A4A6A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: _reminderEnabled,
                  activeColor: const Color(0xFF8A4FFF),
                  onChanged: (v) {
                    setState(() {
                      _reminderEnabled = v;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A4FFF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Save Appointment',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
