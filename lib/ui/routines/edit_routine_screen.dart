import 'package:flutter/material.dart';
import '../../data/services/routine_service.dart';
import '../../data/models/routine_model.dart';

class EditRoutineScreen extends StatefulWidget {
  final String routineId;

  const EditRoutineScreen({super.key, required this.routineId});

  @override
  State<EditRoutineScreen> createState() => _EditRoutineScreenState();
}

class _EditRoutineScreenState extends State<EditRoutineScreen> {
  final RoutineService _routineService = RoutineService();

  RoutineModel? _routine;
  bool _loading = true;
  bool _saving = false;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  String _selectedCategory = 'custom';
  List<RoutineStep> _steps = [];

  @override
  void initState() {
    super.initState();
    _loadRoutine();
  }

  Future<void> _loadRoutine() async {
    final routine = await _routineService.getRoutineById(widget.routineId);

    if (routine != null) {
      _titleController = TextEditingController(text: routine.title);
      _descriptionController =
          TextEditingController(text: routine.description ?? '');
      _selectedCategory = routine.category;
      _steps = List.from(routine.steps);
    }

    setState(() {
      _routine = routine;
      _loading = false;
    });
  }

  void _addStep() {
    setState(() {
      _steps.add(
        RoutineStep(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: '',
          durationMinutes: null,
          isCompleted: false,
          emotionalNote: null,
          order: _steps.length,
        ),
      );
    });
  }

  void _removeStep(int index) {
    setState(() {
      _steps.removeAt(index);
      for (int i = 0; i < _steps.length; i++) {
        _steps[i] = RoutineStep(
          id: _steps[i].id,
          title: _steps[i].title,
          durationMinutes: _steps[i].durationMinutes,
          isCompleted: _steps[i].isCompleted,
          emotionalNote: _steps[i].emotionalNote,
          order: i,
        );
      }
    });
  }

  Future<void> _saveRoutine() async {
    if (_routine == null) return;
    if (_titleController.text.trim().isEmpty) return;

    setState(() => _saving = true);

    final updated = RoutineModel(
      id: _routine!.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      steps: _steps,
      createdAt: _routine!.createdAt,
      updatedAt: DateTime.now(),
    );

    await _routineService.updateRoutine(updated);

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
          'Edit Routine',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8A4FFF),
        child: const Icon(Icons.add),
        onPressed: _addStep,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _routine == null
              ? const Center(
                  child: Text(
                    'Routine not found',
                    style: TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontSize: 16,
                    ),
                  ),
                )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Padding(
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
          Expanded(child: _stepsList()),
          _saveButton(),
        ],
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
            blur
