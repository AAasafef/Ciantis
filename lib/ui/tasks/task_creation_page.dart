import 'package:flutter/material.dart';
import '../../data/services/task_service.dart';

class TaskCreationPage extends StatefulWidget {
  final TaskService taskService;

  const TaskCreationPage({super.key, required this.taskService});

  @override
  State<TaskCreationPage> createState() => _TaskCreationPageState();
}

class _TaskCreationPageState extends State<TaskCreationPage> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();

  String _category = "personal";
  int _emotionalLoad = 3;
  int _fatigueImpact = 3;

  DateTime? _dueDate;

  bool _reminderEnabled = false;
  int _reminderMinutesBefore = 30;

  bool _isRecurring = false;
  String _recurrenceRule = "daily";

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) return;

    await widget.taskService.createTask(
      title: _title.text.trim(),
      description: _description.text.trim(),
      dueDate: _dueDate,
      emotionalLoad: _emotionalLoad,
      fatigueImpact: _fatigueImpact,
      category: _category,
      reminderEnabled: _reminderEnabled,
      reminderMinutesBefore: _reminderMinutesBefore,
      isRecurring: _isRecurring,
      recurrenceRule: _isRecurring ? _recurrenceRule : null,
    );

    Navigator.pop(context);
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF5A4A6A),
          fontWeight: FontWeight.w700,
          fontSize: 15,
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
          "New Task",
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Color(0xFF8A4FFF)),
            onPressed: _save,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Title
          TextField(
            controller: _title,
            decoration: const InputDecoration(
              labelText: "Title",
              labelStyle: TextStyle(color: Color(0xFF7A6F8F)),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF8A4FFF)),
              ),
            ),
          ),

          // Description
          TextField(
            controller: _description,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Description",
              labelStyle: TextStyle(color: Color(0xFF7A6F8F)),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF8A4FFF)),
              ),
            ),
          ),

          // Category
          _sectionTitle("Category"),
          DropdownButtonFormField<String>(
            value: _category,
            items: const [
              DropdownMenuItem(value: "school", child: Text("School")),
              DropdownMenuItem(value: "kids", child: Text("Kids")),
              DropdownMenuItem(value: "salon", child: Text("Salon")),
              DropdownMenuItem(value: "health", child: Text("Health")),
              DropdownMenuItem(value: "personal", child: Text("Personal")),
            ],
            onChanged: (v) => setState(() => _category = v!),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),

          // Emotional Load
          _sectionTitle("Emotional Load"),
          Slider(
            value: _emotionalLoad.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            activeColor: const Color(0xFFE573B5),
            inactiveColor: const Color(0xFFD8D2E3),
            label: "$_emotionalLoad",
            onChanged: (v) => setState(() => _emotionalLoad = v.toInt()),
          ),

          // Fatigue Impact
          _sectionTitle("Fatigue Impact"),
          Slider(
            value: _fatigueImpact.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            activeColor: const Color(0xFFFFC94A),
            inactiveColor: const Color(0xFFD8D2E3),
            label: "$_fatigueImpact",
            onChanged: (v) => setState(() => _fatigueImpact = v.toInt()),
          ),

          // Due Date
          _sectionTitle("Due Date"),
          GestureDetector(
            onTap: _pickDueDate,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE8E2F0)),
              ),
              child: Text(
                _dueDate == null
                    ? "Select a date"
                    : "${_dueDate!.month}/${_dueDate!.day}/${_dueDate!.year}",
                style: const TextStyle(
                  color: Color(0xFF5A4A6A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Reminder
          _sectionTitle("Reminder"),
          SwitchListTile(
            value: _reminderEnabled,
            onChanged: (v) => setState(() => _reminderEnabled = v),
            activeColor: const Color(0xFF8A4FFF),
            title: const Text(
              "Enable Reminder",
              style: TextStyle(color: Color(0xFF5A4A6A)),
            ),
          ),
          if (_reminderEnabled)
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Minutes Before",
                labelStyle: TextStyle(color: Color(0xFF7A6F8F)),
              ),
              onChanged: (v) {
                final parsed = int.tryParse(v);
                if (parsed != null) {
                  setState(() => _reminderMinutesBefore = parsed);
                }
              },
            ),

          // Recurrence
          _sectionTitle("Recurring Task"),
          SwitchListTile(
            value: _isRecurring,
            onChanged: (v) => setState(() => _isRecurring = v),
            activeColor: const Color(0xFF8A4FFF),
            title: const Text(
              "Repeat",
              style: TextStyle(color: Color(0xFF5A4A6A)),
            ),
          ),
          if (_isRecurring)
            DropdownButtonFormField<String>(
              value: _recurrenceRule,
              items: const [
                DropdownMenuItem(value: "daily", child: Text("Daily")),
                DropdownMenuItem(value: "weekly", child: Text("Weekly")),
                DropdownMenuItem(value: "monthly", child: Text("Monthly")),
              ],
              onChanged: (v) => setState(() => _recurrenceRule = v!),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
        ],
      ),
    );
  }
}
