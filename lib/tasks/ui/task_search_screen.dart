import 'package:flutter/material.dart';

import '../search/task_search_engine.dart';
import '../models/task.dart';
import 'task_tile.dart';

/// TaskSearchScreen provides global search for Tasks OS.
/// Features:
/// - Live search
/// - Smart filters
/// - Mode-aware filtering
/// - Premium minimal UI
class TaskSearchScreen extends StatefulWidget {
  const TaskSearchScreen({super.key});

  @override
  State<TaskSearchScreen> createState() => _TaskSearchScreenState();
}

class _TaskSearchScreenState extends State<TaskSearchScreen> {
  final _search = TaskSearchEngine.instance;
  final _controller = TextEditingController();

  List<Task> _results = [];
  String? _modeFilter;
  TaskPriority? _priorityFilter;
  TaskEnergy? _energyFilter;
  TaskFlexibility? _flexFilter;

  @override
  void initState() {
    super.initState();
    _results = _search.search("");
  }

  void _updateResults() {
    setState(() {
      _results = _search.advanced(
        query: _controller.text,
        priority: _priorityFilter,
        energy: _energyFilter,
        flexibility: _flexFilter,
        mode: _modeFilter,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Search Tasks"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search tasks...",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white38),
              ),
              onChanged: (_) => _updateResults(),
            ),
          ),

          // FILTER CHIPS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _chip("Focus", _modeFilter == "focus", () {
                  setState(() {
                    _modeFilter = _modeFilter == "focus" ? null : "focus";
                    _updateResults();
                  });
                }),
                _chip("Fatigue", _modeFilter == "fatigue", () {
                  setState(() {
                    _modeFilter = _modeFilter == "fatigue" ? null : "fatigue";
                    _updateResults();
                  });
                }),
                _chip("Recovery", _modeFilter == "recovery", () {
                  setState(() {
                    _modeFilter = _modeFilter == "recovery" ? null : "recovery";
                    _updateResults();
                  });
                }),
                _chip("High Priority", _priorityFilter == TaskPriority.high, () {
                  setState(() {
                    _priorityFilter = _priorityFilter == TaskPriority.high
                        ? null
                        : TaskPriority.high;
                    _updateResults();
                  });
                }),
                _chip("Low Energy", _energyFilter == TaskEnergy.low, () {
                  setState(() {
                    _energyFilter = _energyFilter == TaskEnergy.low
                        ? null
                        : TaskEnergy.low;
                    _updateResults();
                  });
                }),
                _chip("Flexible", _flexFilter == TaskFlexibility.flexible, () {
                  setState(() {
                    _flexFilter = _flexFilter == TaskFlexibility.flexible
                        ? null
                        : TaskFlexibility.flexible;
                    _updateResults();
                  });
                }),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // RESULTS
          Expanded(
            child: _results.isEmpty
                ? const Center(
                    child: Text(
                      "No results",
                      style: TextStyle(color: Colors.white38),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      return TaskTile(task: _results[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // -----------------------------
  // FILTER CHIP
  // -----------------------------
  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: Colors.tealAccent.withOpacity(0.2),
        backgroundColor: Colors.white12,
        labelStyle: TextStyle(
          color: selected ? Colors.tealAccent : Colors.white70,
        ),
      ),
    );
  }
}
