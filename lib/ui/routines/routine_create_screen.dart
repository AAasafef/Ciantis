import 'package:flutter/material.dart';
import '../../data/services/routine_service.dart';
import '../../data/models/routine_model.dart';

class RoutineCreateScreen extends StatefulWidget {
  const RoutineCreateScreen({super.key});

  @override
  State<RoutineCreateScreen> createState() => _RoutineCreateScreenState();
}

class _RoutineCreateScreenState extends State<RoutineCreateScreen> {
  final RoutineService _routineService = RoutineService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedCategory = 'personal';
  int _selectedPriority = 3;

  List<RoutineStepModel> _steps = [];

  final List<String> _categories = [
    'school',
    'kids',
    'salon',
    'health',
    'personal',
  ];

  // -----------------------------
  // ADD STEP
  // -----------------------------
  void _addStep() async {
    final step = await showDialog<RoutineStepModel>(
      context: context,
      builder: (_) => _StepEditorDialog(
        stepNumber: _steps.length + 1,
      ),
    );

    if (step != null) {
      setState(() {
        _steps.add(step);
      });
    }
  }

  // -----------------------------
  // EDIT STEP
  // -----------------------------
  void _editStep(int index) async {
    final updated = await showDialog<RoutineStepModel>(
      context: context,
      builder: (_) => _StepEditorDialog(
        stepNumber: index + 1,
        existing: _steps[index],
      ),
    );

    if (updated != null) {
      setState(() {
        _steps[index] = updated;
      });
    }
  }

  // -----------------------------
  // DELETE STEP
  // -----------------------------
  void _deleteStep(int index) {
    setState(() {
      _steps.removeAt(index);
    });
  }

  // -----------------------------
  // SAVE ROUTINE
  // -----------------------------
  Future<void> _saveRoutine() async {
    final title = _titleController.text.trim();
    if (title.isEmpty || _steps.isEmpty) return;

    await _routineService.createRoutine(
      title: title,
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      priority: _selectedPriority,
      steps: _steps,
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

  Widget _stepTile(int index, RoutineStepModel step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE8E2F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Step number
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF8A4FFF).withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Color(0xFF8A4FFF),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Step title
          Expanded(
            child: Text(
              step.title,
              style: const TextStyle(
                color: Color(0xFF5A4A6A),
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),

          // Edit
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF8A4FFF)),
            onPressed: () => _editStep(index),
          ),

          // Delete
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFF8A4FFF)),
            onPressed: () => _deleteStep(index),
          ),
        ],
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
          'New Routine',
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
                hintText: 'Enter routine name',
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

            const SizedBox(height: 30),

            // Steps
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Steps',
                  style: TextStyle(
                    color: Color(0xFF5A4A6A),
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                TextButton(
                  onPressed: _addStep,
                  child: const Text(
                    '+ Add Step',
                    style: TextStyle(
                      color: Color(0xFF8A4FFF),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            if (_steps.isEmpty)
              const Text(
                'No steps added yet',
                style: TextStyle(
                  color: Color(0xFF7A6F8F),
                  fontSize: 14,
                ),
              ),

            ...List.generate(_steps.length, (i) => _stepTile(i, _steps[i])),

            const SizedBox(height: 40),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveRoutine,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A4FFF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Save Routine',
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

// ------------------------------------------------------------
// STEP EDITOR DIALOG
// ------------------------------------------------------------
class _StepEditorDialog extends StatefulWidget {
  final int stepNumber;
  final RoutineStepModel? existing;

  const _StepEditorDialog({
    required this.stepNumber,
    this.existing,
  });

  @override
  State<_StepEditorDialog> createState() => _StepEditorDialogState();
}

class _StepEditorDialogState extends State<_StepEditorDialog> {
  final RoutineService _routineService = RoutineService();

  late TextEditingController _titleController;
  late TextEditingController _durationController;

  int _emotionalLoad = 5;
  int _fatigueImpact = 5;

  @override
  void initState() {
    super.initState();

    _titleController =
        TextEditingController(text: widget.existing?.title ?? '');
    _durationController = TextEditingController(
        text: widget.existing?.durationMinutes.toString() ?? '5');

    _emotionalLoad = widget.existing?.emotionalLoad ?? 5;
    _fatigueImpact = widget.existing?.fatigueImpact ?? 5;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF7F4F9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: Text(
        'Step ${widget.stepNumber}',
        style: const TextStyle(
          color: Color(0xFF5A4A6A),
          fontWeight: FontWeight.w700,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Step Title',
              ),
            ),

            const SizedBox(height: 16),

            // Duration
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Duration (minutes)',
              ),
            ),

            const SizedBox(height: 16),

            // Emotional load
            Row(
              children: [
                const Text(
                  'Emotional Load',
                  style: TextStyle(
                    color: Color(0xFF5A4A6A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                DropdownButton<int>(
                  value: _emotionalLoad,
                  items: List.generate(
                    10,
                    (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text('${i + 1}'),
                    ),
                  ),
                  onChanged: (v) {
                    setState(() {
                      _emotionalLoad = v!;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Fatigue impact
            Row(
              children: [
                const Text(
                  'Fatigue Impact',
                  style: TextStyle(
                    color: Color(0xFF5A4A6A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                DropdownButton<int>(
                  value: _fatigueImpact,
                  items: List.generate(
                    10,
                    (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text('${i + 1}'),
                    ),
                  ),
                  onChanged: (v) {
                    setState(() {
                      _fatigueImpact = v!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFF7A6F8F)),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8A4FFF),
          ),
          child: const Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            final title = _titleController.text.trim();
            final duration = int.tryParse(_durationController.text.trim()) ?? 5;

            if (title.isEmpty) return;

            final step = _routineService.createStep(
              title: title,
              order: widget.stepNumber,
              durationMinutes: duration,
              emotionalLoad: _emotionalLoad,
              fatigueImpact: _fatigueImpact,
            );

            Navigator.pop(context, step);
          },
        ),
      ],
    );
  }
}
