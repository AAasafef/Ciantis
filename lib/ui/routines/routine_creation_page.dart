import 'package:flutter/material.dart';
import '../../data/services/routine_service.dart';
import '../../data/models/routine_model.dart';

class RoutineCreationPage extends StatefulWidget {
  final RoutineService routineService;

  const RoutineCreationPage({super.key, required this.routineService});

  @override
  State<RoutineCreationPage> createState() => _RoutineCreationPageState();
}

class _RoutineCreationPageState extends State<RoutineCreationPage> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();

  String _category = "morning";
  List<RoutineStepModel> _steps = [];

  int _emotionalLoad = 3;
  int _fatigueImpact = 3;

  // Add Step Modal
  Future<void> _addStepDialog() async {
    final TextEditingController stepTitle = TextEditingController();
    int duration = 1;
    int emotional = 3;
    int fatigue = 3;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: const Text(
                "Add Step",
                style: TextStyle(
                  color: Color(0xFF8A4FFF),
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: stepTitle,
                      decoration: const InputDecoration(
                        labelText: "Step Title",
                        labelStyle: TextStyle(color: Color(0xFF7A6F8F)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text("Duration: "),
                        Expanded(
                          child: Slider(
                            value: duration.toDouble(),
                            min: 1,
                            max: 30,
                            divisions: 29,
                            label: "$duration min",
                            activeColor: Color(0xFF8A4FFF),
                            onChanged: (v) {
                              setModalState(() {
                                duration = v.toInt();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text("Emotional: "),
                        Expanded(
                          child: Slider(
                            value: emotional.toDouble(),
                            min: 1,
                            max: 10,
                            divisions: 9,
                            label: "$emotional",
                            activeColor: Color(0xFFE573B5),
                            onChanged: (v) {
                              setModalState(() {
                                emotional = v.toInt();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text("Fatigue: "),
                        Expanded(
                          child: Slider(
                            value: fatigue.toDouble(),
                            min: 1,
                            max: 10,
                            divisions: 9,
                            label: "$fatigue",
                            activeColor: Color(0xFFFFC94A),
                            onChanged: (v) {
                              setModalState(() {
                                fatigue = v.toInt();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text("Cancel",
                      style: TextStyle(color: Color(0xFF7A6F8F))),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8A4FFF),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Add"),
                  onPressed: () {
                    if (stepTitle.text.trim().isNotEmpty) {
                      setState(() {
                        _steps.add(
                          RoutineStepModel(
                            title: stepTitle.text.trim(),
                            order: _steps.length,
                            durationMinutes: duration,
                            emotionalLoad: emotional,
                            fatigueImpact: fatigue,
                          ),
                        );
                      });
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) return;

    await widget.routineService.createRoutine(
      title: _title.text.trim(),
      description: _description.text.trim(),
      category: _category,
      steps: _steps,
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
          "New Routine",
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
              DropdownMenuItem(value: "morning", child: Text("Morning")),
              DropdownMenuItem(value: "night", child: Text("Night")),
              DropdownMenuItem(value: "kids", child: Text("Kids")),
              DropdownMenuItem(value: "salon", child: Text("Salon")),
              DropdownMenuItem(value: "health", child: Text("Health")),
              DropdownMenuItem(value: "study", child: Text("Study")),
              DropdownMenuItem(value: "custom", child: Text("Custom")),
            ],
            onChanged: (v) => setState(() => _category = v!),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),

          // Steps
          _sectionTitle("Steps"),
          if (_steps.isEmpty)
            const Text(
              "No steps yet",
              style: TextStyle(
                color: Color(0xFF7A6F8F),
                fontSize: 14,
              ),
            ),
          if (_steps.isNotEmpty)
            Column(
              children: _steps.map((s) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Color(0xFFE8E2F0)),
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
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Color(0xFFE57373)),
                        onPressed: () {
                          setState(() {
                            _steps.remove(s);
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addStepDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8A4FFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Add Step",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),

          const SizedBox(height: 20),

          // Emotional Load
          _sectionTitle("Emotional Load (auto‑computed later)"),
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
          _sectionTitle("Fatigue Impact (auto‑computed later)"),
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
        ],
      ),
    );
  }
}
