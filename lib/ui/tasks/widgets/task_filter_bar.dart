import 'package:flutter/material.dart';

class TaskFilterBar extends StatefulWidget {
  final Function(String query) onSearch;
  final Function(String category) onCategoryChange;
  final Function(int priority) onPriorityChange;

  const TaskFilterBar({
    super.key,
    required this.onSearch,
    required this.onCategoryChange,
    required this.onPriorityChange,
  });

  @override
  State<TaskFilterBar> createState() => _TaskFilterBarState();
}

class _TaskFilterBarState extends State<TaskFilterBar> {
  final TextEditingController _search = TextEditingController();
  String _category = "all";
  int _priority = 0; // 0 = all

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ---------------------------
        // SEARCH BAR
        // ---------------------------
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8E2F0)),
          ),
          child: TextField(
            controller: _search,
            onChanged: widget.onSearch,
            decoration: const InputDecoration(
              icon: Icon(Icons.search, color: Color(0xFF8A4FFF)),
              hintText: "Search tasks",
              border: InputBorder.none,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ---------------------------
        // CATEGORY DROPDOWN
        // ---------------------------
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _category,
                items: const [
                  DropdownMenuItem(value: "all", child: Text("All")),
                  DropdownMenuItem(value: "personal", child: Text("Personal")),
                  DropdownMenuItem(value: "school", child: Text("School")),
                  DropdownMenuItem(value: "kids", child: Text("Kids")),
                  DropdownMenuItem(value: "salon", child: Text("Salon")),
                  DropdownMenuItem(value: "health", child: Text("Health")),
                  DropdownMenuItem(value: "work", child: Text("Work")),
                ],
                onChanged: (v) {
                  setState(() => _category = v!);
                  widget.onCategoryChange(v!);
                },
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // ---------------------------
            // PRIORITY DROPDOWN
            // ---------------------------
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _priority,
                items: const [
                  DropdownMenuItem(value: 0, child: Text("All Priorities")),
                  DropdownMenuItem(value: 5, child: Text("Priority 5")),
                  DropdownMenuItem(value: 4, child: Text("Priority 4")),
                  DropdownMenuItem(value: 3, child: Text("Priority 3")),
                  DropdownMenuItem(value: 2, child: Text("Priority 2")),
                  DropdownMenuItem(value: 1, child: Text("Priority 1")),
                ],
                onChanged: (v) {
                  setState(() => _priority = v!);
                  widget.onPriorityChange(v!);
                },
                decoration: const InputDecoration(
                  labelText: "Priority",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
