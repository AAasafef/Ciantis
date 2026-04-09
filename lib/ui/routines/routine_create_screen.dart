import 'package:flutter/material.dart';
import '../../data/services/routine_service.dart';
import '../../data/models/routine_step_model.dart';

class RoutineCreateScreen extends StatefulWidget {
  const RoutineCreateScreen({super.key});

  @override
  State<RoutineCreateScreen> createState() => _RoutineCreateScreenState();
}

class _RoutineCreateScreenState extends State<RoutineCreateScreen> {
  final RoutineService _routineService = RoutineService();

  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();

  String _category = "morning";

  List<RoutineStepModel> _steps = [];

  bool _saving = false;

  final List<String> _categories = [
    "morning",
    "night",
    "self-care",
    "kids",
    "school",
    "salon",
    "health",
    "personal",
  ];

  // -----------------------------
  // ADD STEP DIALOG
  // -----------------------------
  Future<void> _addStepDialog() async {
    final titleCtrl = TextEditingController();
    final durationCtrl = TextEditingController();
    int emotional = 0;
    int fatigue = 0;

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "Add Step",
            style: TextStyle(
              color: Color(0xFF8A4FFF),
              fontWeight: FontWeight.w700,
            ),
          ),
          content: SizedBox(
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: "Step title"),
                ),
                TextField(
                  controller: durationCtrl,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: "Duration (minutes)"),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Emotional Load"),
                    const Spacer(),
                    DropdownButton<int>(
                      value: emotional,
                      items: [0, 1, 2, 3, 4, 5]
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.toString()),
                              ))
                          .toList(),
                      onChanged: (v) {
                        setState(() => emotional = v ?? 0);
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Fatigue Impact"),
                    const Spacer(),
                    DropdownButton<int>(
                      value: fatigue,
                      items: [0, 1, 2, 3, 4, 5]
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.toString()),
                              ))
                          .toList(),
                      onChanged: (v) {
                        setState(() => fatigue = v ?? 0);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8A4FFF),
              ),
              child: const Text("Add"),
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty ||
                    durationCtrl.text.trim().isEmpty) return;

                final step = RoutineStepModel(
                  id: UniqueKey().toString(),
                  routineId: "",
                  title: titleCtrl.text.trim(),
                  duration: int.tryParse(durationCtrl.text.trim()) ?? 0,
                  emotionalLoad: emotional,
                  fatigueImpact: fatigue,
                  orderIndex: _steps.length,
                  completed: false,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );

                setState(() => _steps.add(step));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // -----------------------------
  // SAVE ROUTINE
  // -----------------------------
  Future<void> _saveRoutine() async {
    if (_titleCtrl.text.trim().isEmpty) return;

    setState(() => _saving = true);

    final routineId = await _routineService.createRoutine(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty
          ? null
          : _descCtrl.text.trim(),
      category: _category,
    );

    for (int i = 0; i < _steps.length; i++) {
      final s = _steps[i];
      await _routineService.addStep(
        routineId: routineId,
        title: s.title,
        duration: s.duration,
        emotionalLoad: s.emotionalLoad,
        fatigueImpact: s.fatigueImpact,
        orderIndex: i,
      );
    }

    setState(() => _saving = false);
    Navigator.pop(context);
  }

  // -----------------------------
  // REORDER STEPS
  // -----------------------------
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _steps.removeAt(oldIndex);
      _steps.insert(newIndex, item);

      for (int i = 0; i < _steps.length; i++) {
        _steps[i] = _steps[i].copyWith(orderIndex: i);
      }
    });
  }

  // -----------------------------
  // UI
  // -----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Create Routine",
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _saving
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(
                      labelText: "Routine Title",
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(
                      labelText: "Description (optional)",
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),

                  // Category
                  Row(
                    children: [
                      const Text(
                        "Category",
                        style: TextStyle(
                          color: Color(0xFF5A4A6A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      DropdownButton<String>(
                        value: _category,
                        items: _categories
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(
                                    c[0].toUpperCase() + c.substring(1),
                                  ),
                                ))
                            .toList(),
                        onChanged: (v) {
                          setState(() => _category = v ?? "morning");
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Steps header
                  Row(
                    children: [
                      const Text(
                        "Steps",
                        style: TextStyle(
                          color: Color(0xFF5A4A6A),
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add_circle,
                            color: Color(0xFF8A4FFF)),
                        onPressed: _addStepDialog,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Steps list
                  if (_steps.isEmpty)
                    const Text(
                      "No steps yet",
                      style: TextStyle(
                        color: Color(0xFF7A6F8F),
                        fontSize: 14,
                      ),
                    )
                  else
                    ReorderableListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      onReorder: _onReorder,
                      children: _steps.map((s) {
                        return Container(
                          key: ValueKey(s.id),
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border:
                                Border.all(color: const Color(0xFFE8E2F0)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  s.title,
                                  style: const TextStyle(
                                    color: Color(0xFF5A4A6A),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                "${s.duration}m",
                                style: const TextStyle(
                                  color: Color(0xFF7A6F8F),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.drag_handle,
                                  color: Color(0xFF8A4FFF)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 40),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A4FFF),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _saveRoutine,
                      child: const Text(
                        "Save Routine",
                        style: TextStyle(
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
