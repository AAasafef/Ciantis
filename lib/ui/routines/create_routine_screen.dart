import 'package:flutter/material.dart';
import '../../data/services/routine_service.dart';

class CreateRoutineScreen extends StatefulWidget {
  const CreateRoutineScreen({super.key});

  @override
  State<CreateRoutineScreen> createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends State<CreateRoutineScreen> {
  final RoutineService _routineService = RoutineService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedCategory = 'custom';

  List<Map<String, dynamic>> _steps = [];
  bool _saving = false;

  void _addStep() {
    setState(() {
      _steps.add({
        'title': '',
        'durationMinutes': null,
      });
    });
  }

  void _removeStep(int index) {
    setState(() {
      _steps.removeAt(index);
    });
  }

  Future<void> _saveRoutine() async {
    if (_titleController.text.trim().isEmpty || _steps.isEmpty) return;

    setState(() => _saving = true);

    await _routineService.createRoutine(
      title: _titleController.text,
      description: _descriptionController.text,
      category: _selectedCategory,
      stepsData: _steps,
    );

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
          'Create Routine',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _inputField(
              controller: _titleController,
              label: 'Title',
              hint: 'Enter routine title',
            ),
            const SizedBox(height: 20),
            _inputField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Optional description',
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            _categoryPicker(),
            const SizedBox(height: 20),
            _stepsList(),
            const Spacer(),
            _saveButton(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8A4FFF),
        child: const Icon(Icons.add),
        onPressed: _addStep,
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

  Widget _categoryPicker() {
    return Container(
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          items: const [
            DropdownMenuItem(value: 'morning', child: Text('Morning')),
            DropdownMenuItem(value: 'night', child: Text('Night')),
            DropdownMenuItem(value: 'kids', child: Text('Kids')),
            DropdownMenuItem(value: 'salon', child: Text('Salon')),
            DropdownMenuItem(value: 'health', child: Text('Health')),
            DropdownMenuItem(value: 'custom', child: Text('Custom')),
          ],
          onChanged: (value) {
            setState(() => _selectedCategory = value!);
          },
        ),
      ),
    );
  }

  Widget _stepsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _steps.length,
        itemBuilder: (context, index) {
          return _stepTile(index);
        },
      ),
    );
  }

  Widget _stepTile(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step ${index + 1}',
            style: const TextStyle(
              color: Color(0xFF8A4FFF),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Step title',
              filled: true,
              fillColor: Color(0xFFF7F4F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              _steps[index]['title'] = value;
            },
          ),
          const SizedBox(height: 12),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Duration (minutes)',
              filled: true,
              fillColor: Color(0xFFF7F4F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              _steps[index]['durationMinutes'] =
                  value.isEmpty ? null : int.tryParse(value);
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  color: Color(0xFF8A4FFF)),
              onPressed: () => _removeStep(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saving ? null : _saveRoutine,
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
                'Save Routine',
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
