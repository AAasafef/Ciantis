import 'package:flutter/material.dart';
import '../../data/services/task_service.dart';

class TaskCreateScreen extends StatefulWidget {
  const TaskCreateScreen({super.key});

  @override
  State<TaskCreateScreen> createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  final TaskService _taskService = TaskService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _selectedDueDate;
  String _selectedCategory = 'personal';
  int _selectedPriority = 3;

  final List<String> _categories = [
    'school',
    'kids',
    'salon',
    'health',
    'personal',
  ];

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 0)),
      lastDate: now.add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    await _taskService.createTask(
      title: title,
      description: _descriptionController.text.trim(),
      dueDate: _selectedDueDate,
      category: _selectedCategory,
      priority: _selectedPriority,
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

  Widget _prioritySelector() {
    return Row(
      children: List.generate(5, (i) {
        final level = i + 1;
        final selected = level == _selectedPriority;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedPriority = level;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFF8A4FFF)
                  : const Color(0xFFE8E2F0),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$level',
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF5A4A6A),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );
      }),
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
          'New Task',
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
                hintText: 'Enter task title',
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

            // Due Date
            const Text(
              'Due Date',
              style: TextStyle(
                color: Color(0xFF5A4A6A),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDueDate,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: const Color
