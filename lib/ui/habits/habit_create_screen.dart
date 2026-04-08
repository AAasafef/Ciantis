import 'package:flutter/material.dart';
import '../../data/services/habit_service.dart';

class HabitCreateScreen extends StatefulWidget {
  const HabitCreateScreen({super.key});

  @override
  State<HabitCreateScreen> createState() => _HabitCreateScreenState();
}

class _HabitCreateScreenState extends State<HabitCreateScreen> {
  final HabitService _habitService = HabitService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedCategory = 'personal';
  int _selectedPriority = 3;

  final List<int> _selectedDays = [];

  final List<String> _categories = [
    'school',
    'kids',
    'salon',
    'health',
    'personal',
  ];

  final List<String> _weekdayLabels = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];

  Future<void> _saveHabit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty || _selectedDays.isEmpty) return;

    await _habitService.createHabit(
      title: title,
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      priority: _selectedPriority,
      days: _selectedDays,
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

  Widget _weekdaySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final dayNumber = i + 1; // 1–7
        final selected = _selectedDays.contains(dayNumber);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (selected) {
                _selectedDays.remove(dayNumber);
              } else {
                _selectedDays.add(dayNumber);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFF8A4FFF)
                  : const Color(0xFFE8E2F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _weekdayLabels[i],
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF5A4A6A),
                fontWeight: FontWeight.w600,
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
          'New Habit',
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
                hintText: 'Enter habit name',
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

            // Priority
            const Text(
              'Priority',
              style: TextStyle(
                color: Color(0xFF5A4A6A),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            _prioritySelector(),

            const SizedBox(height: 20),

            // Weekdays
            const Text(
              'Repeat On',
              style: TextStyle(
                color: Color(0xFF5A4A6A),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            _weekdaySelector(),

            const SizedBox(height: 40),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveHabit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A4FFF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Save Habit',
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
