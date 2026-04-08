import 'package:flutter/material.dart';
import '../../data/services/task_service.dart';
import '../../data/models/task_model.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskModel task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final TaskService _taskService = TaskService();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  DateTime? _selectedDate;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description ?? '');
    _selectedDate = widget.task.dueDate;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) return;

    setState(() => _saving = true);

    final updated = widget.task.copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _selectedDate,
      updatedAt: DateTime.now(),
    );

    await _taskService.updateTask(updated);

    if (mounted) Navigator.pop(context);
  }

  Future<void> _toggleCompletion() async {
    await _taskService.toggleTaskCompletion(widget.task);
    if (mounted) Navigator.pop(context);
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
          'Edit Task',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.task.isCompleted
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined,
              color: const Color(0xFF8A4FFF),
            ),
            onPressed: _toggleCompletion,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _inputField(
              controller: _titleController,
              label: 'Title',
              hint: 'Enter task title',
            ),
            const SizedBox(height: 20),
            _inputField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Optional description',
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            _datePicker(),
            const Spacer(),
            _saveButton(),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF5A4A6A),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _datePicker() {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded,
                color: Color(0xFF8A4FFF)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedDate == null
                    ? 'No due date'
                    : '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}',
                style: const TextStyle(
                  color: Color(0xFF5A4A6A),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saving ? null : _save,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8A4FFF),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _saving
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Save Changes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
