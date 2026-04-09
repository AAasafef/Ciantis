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

  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _locationCtrl = TextEditingController();

  String _category = "personal";

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now().replacing(minute: TimeOfDay.now().minute + 30);

  int _emotionalLoad = 5;
  int _fatigueImpact = 5;

  bool _reminderEnabled = false;
  int _reminderMinutesBefore = 10;

  bool _saving = false;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) setState(() => _startTime = picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null) setState(() => _endTime = picked);
  }

  Future<void> _save() async {
    if (_saving) return;

    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title is required")),
      );
      return;
    }

    setState(() => _saving = true);

    final start = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _startTime.hour,
      _startTime.minute,
    );

    final end = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    await _appointmentService.createAppointment(
      title: title,
      description: _descCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      category: _category,
      startTime: start,
      endTime: end,
      emotionalLoad: _emotionalLoad,
      fatigueImpact: _fatigueImpact,
      reminderEnabled: _reminderEnabled,
      reminderMinutesBefore: _reminderEnabled ? _reminderMinutesBefore : null,
    );

    if (mounted) Navigator.pop(context);
  }

  Widget _categoryChip(String value, String label) {
    final selected = _category == value;

    return GestureDetector(
      onTap: () => setState(() => _category = value),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF8A4FFF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF8A4FFF),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  InputDecoration _input(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE8E2F0)),
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
          "New Appointment",
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: _input("Title"),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: _input("Description (optional)"),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _locationCtrl,
              decoration: _input("Location (optional)"),
            ),
            const SizedBox(height: 20),

            // Category chips
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                children: [
                  _categoryChip("school", "School"),
                  _categoryChip("kids", "Kids"),
                  _categoryChip("salon", "Salon"),
                  _categoryChip("health", "Health"),
                  _categoryChip("personal", "Personal"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Date + time pickers
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE8E2F0)),
                      ),
                      child: Text(
                        "${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}",
                        style: const TextStyle(
                          color: Color(0xFF5A4A6A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickStartTime,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE8E2F0)),
                      ),
                      child: Text(
                        _startTime.format(context),
                        style: const TextStyle(
                          color: Color(0xFF5A4A6A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: _pickEndTime,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: BorderSide(color: const Color(0xFFE8E2F0)),
                      ),
                      child: Text(
                        _endTime.format(context),
                        style: const TextStyle(
                          color: Color(0xFF5A4A6A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Emotional load slider
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Emotional Load",
                  style: TextStyle(
                    color: Color(0xFF5A4A6A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Slider(
                  value: _emotionalLoad.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  activeColor: const Color(0xFF8A4FFF),
                  onChanged: (v) => setState(() => _emotionalLoad = v.toInt()),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Fatigue impact slider
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Fatigue Impact",
                  style: TextStyle(
                    color: Color(0xFF5A4A6A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Slider(
                  value: _fatigueImpact.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  activeColor: const Color(0xFF8A4FFF),
                  onChanged: (v) => setState(() => _fatigueImpact = v.toInt()),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Reminder toggle
            SwitchListTile(
              value: _reminderEnabled,
              activeColor: const Color(0xFF8A4FFF),
              title: const Text(
                "Enable Reminder",
                style: TextStyle(
                  color: Color(0xFF5A4A6A),
                  fontWeight: FontWeight.w600,
                ),
              ),
              onChanged: (v) => setState(() => _reminderEnabled = v),
            ),

            if (_reminderEnabled)
              DropdownButtonFormField<int>(
                value: _reminderMinutesBefore,
                decoration: _input("Remind me before"),
                items: const [
                  DropdownMenuItem(value: 5, child: Text("5 minutes")),
                  DropdownMenuItem(value: 10, child: Text("10 minutes")),
                  DropdownMenuItem(value: 30, child: Text("30 minutes")),
                  DropdownMenuItem(value: 60, child: Text("1 hour")),
                ],
                onChanged: (v) =>
                    setState(() => _reminderMinutesBefore = v ?? 10),
              ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A4FFF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  _saving ? "Saving..." : "Save Appointment",
                  style: const TextStyle(
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
