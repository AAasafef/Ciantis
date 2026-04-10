import 'package:flutter/material.dart';

import '../../data/services/task_service.dart';

class TaskCreationPage extends StatefulWidget {
  final TaskService taskService;

  const TaskCreationPage({
    super.key,
    required this.taskService,
  });

  @override
  State<TaskCreationPage> createState() => _TaskCreationPageState();
}

class _TaskCreationPageState extends State<TaskCreationPage> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();

  String _category = "personal";
  int _priority = 3;
  int _emotionalLoad = 3;
  int _fatigueImpact = 3;
  DateTime? _dueDate;

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
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
      category: _category,
      priority: _priority,
      emotionalLoad: _emotionalLoad,
      fatigueImpact: _fatigueImpact,
    );

    Navigator.pop(context, true); // return with refresh signal
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
            fontWeight: FontWeight.w700,
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
              DropdownMenuItem(value: "personal", child: Text("Personal")),
              DropdownMenuItem(value: "school", child: Text("School")),
              DropdownMenuItem(value: "kids", child: Text("Kids")),
              DropdownMenuItem(value: "salon", child: Text("Salon")),
              DropdownMenuItem(value: "health", child: Text("Health")),
              DropdownMenuItem(value: "work", child: Text("Work")),
              DropdownMenuItem(value: "custom", child: Text("Custom")),
            ],
            onChanged: (v) => setState(() => _category = v!),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),

          // Priority
          _sectionTitle("Priority"),
          Slider(
            value: _priority.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: "$_priority",
            activeColor: const Color(0xFF8A4FFF),
            onChanged: (v) => setState(() => _priority = v.toInt()),
          ),

          // Emotional Load
          _sectionTitle("Emotional Load"),
          Slider(
            value: _emotionalLoad.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            label: "$_emotionalLoad",
            activeColor: const Color(0xFFE573B5),
            onChanged: (v) => setState(() => _emotionalLoad = v.toInt()),
          ),

          // Fatigue Impact
          _sectionTitle("Fatigue Impact"),
          Slider(
            value: _fatigueImpact.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            label: "$_fatigueImpact",
            activeColor: const Color(0xFFFFC94A),
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
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      color: Color(0xFF8A4FFF), size: 20),
                  const SizedBox(width: 12),
                  Text(
                    _dueDate == null
                        ? "Select date"
                        : "${_dueDate!.month}/${_dueDate!.day}/${_dueDate!.year}",
                    style: const TextStyle(
                      color: Color(0xFF5A4A6A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
