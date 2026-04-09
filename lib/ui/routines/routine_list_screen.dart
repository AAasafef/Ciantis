import 'package:flutter/material.dart';
import '../../data/services/routine_service.dart';
import '../../data/models/routine_model.dart';
import 'routine_details_screen.dart';

class RoutineListScreen extends StatefulWidget {
  const RoutineListScreen({super.key});

  @override
  State<RoutineListScreen> createState() => _RoutineListScreenState();
}

class _RoutineListScreenState extends State<RoutineListScreen> {
  final RoutineService _routineService = RoutineService();

  List<RoutineModel> _routines = [];
  bool _loading = true;

  String _selectedCategory = "all";

  final List<String> _categories = [
    "all",
    "morning",
    "night",
    "self-care",
    "kids",
    "school",
    "salon",
    "health",
    "personal",
  ];

  @override
  void initState() {
    super.initState();
    _loadRoutines();
  }

  Future<void> _loadRoutines() async {
    final list = await _routineService._repo.getAllRoutines();
    setState(() {
      _routines = list;
      _loading = false;
    });
  }

  List<RoutineModel> get _filteredRoutines {
    if (_selectedCategory == "all") return _routines;
    return _routines.where((r) => r.category == _selectedCategory).toList();
  }

  Color _badgeColor(int value) {
    if (value >= 20) return const Color(0xFF8A4FFF);
    if (value >= 10) return const Color(0xFFB76EFF);
    if (value >= 5) return const Color(0xFFD8C7F5);
    return const Color(0xFFEDE7F8);
  }

  Widget _routineTile(RoutineModel r) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RoutineDetailsScreen(routineId: r.id),
          ),
        );
        _loadRoutines();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8E2F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left side: title + category + streak
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5A4A6A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    r.category[0].toUpperCase() + r.category.substring(1),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7A6F8F),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department,
                          size: 18, color: const Color(0xFF8A4FFF)),
                      const SizedBox(width: 6),
                      Text(
                        "${r.streak} day streak",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8A4FFF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Right side: badges
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _miniBadge("E", r.emotionalLoad),
                const SizedBox(height: 6),
                _miniBadge("F", r.fatigueImpact),
                const SizedBox(height: 6),
                _miniBadge("${r.estimatedDuration}m", r.estimatedDuration),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniBadge(String label, int value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _badgeColor(value).withOpacity(0.18),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _badgeColor(value),
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _categoryChips() {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _categories.map((c) {
          final selected = c == _selectedCategory;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategory = c);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF8A4FFF)
                    : const Color(0xFFEDE7F8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                c[0].toUpperCase() + c.substring(1),
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF5A4A6A),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        }).toList(),
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
          "Routines",
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 16),
                _categoryChips(),
                const SizedBox(height: 16),
                Expanded(
                  child: _filteredRoutines.isEmpty
                      ? const Center(
                          child: Text(
                            "No routines yet",
                            style: TextStyle(
                              color: Color(0xFF7A6F8F),
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(20),
                          children:
                              _filteredRoutines.map(_routineTile).toList(),
                        ),
                ),
              ],
            ),
    );
  }
}
