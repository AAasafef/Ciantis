import 'package:flutter/material.dart';
import '../../data/services/routine_service.dart';
import '../../data/models/routine_model.dart';

class RoutineInsightsScreen extends StatefulWidget {
  const RoutineInsightsScreen({super.key});

  @override
  State<RoutineInsightsScreen> createState() => _RoutineInsightsScreenState();
}

class _RoutineInsightsScreenState extends State<RoutineInsightsScreen> {
  final RoutineService _routineService = RoutineService();

  List<RoutineModel> _routines = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    final list = await _routineService._repo.getAllRoutines();
    setState(() {
      _routines = list;
      _loading = false;
    });
  }

  int get _avgEmotional {
    if (_routines.isEmpty) return 0;
    return _routines.map((r) => r.emotionalLoad).reduce((a, b) => a + b) ~/
        _routines.length;
  }

  int get _avgFatigue {
    if (_routines.isEmpty) return 0;
    return _routines.map((r) => r.fatigueImpact).reduce((a, b) => a + b) ~/
        _routines.length;
  }

  int get _avgDuration {
    if (_routines.isEmpty) return 0;
    return _routines.map((r) => r.estimatedDuration).reduce((a, b) => a + b) ~/
        _routines.length;
  }

  int get _bestStreak {
    if (_routines.isEmpty) return 0;
    return _routines.map((r) => r.streak).reduce((a, b) => a > b ? a : b);
  }

  String _modeInsight() {
    if (_avgEmotional >= 20) {
      return "Your routines carry emotional weight. Consider adding grounding steps.";
    }
    if (_avgFatigue >= 20) {
      return "Your routines may be physically demanding. Balance them with recovery.";
    }
    if (_avgDuration >= 45) {
      return "Your routines are long. Protect your time and avoid rushing.";
    }
    if (_bestStreak >= 7) {
      return "You’re building strong consistency. Keep honoring your rhythm.";
    }
    return "Your routines are balanced. Move with intention and ease.";
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
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
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF5A4A6A),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _insightBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF8A4FFF).withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        _modeInsight(),
        style: const TextStyle(
          color: Color(0xFF5A4A6A),
          fontWeight: FontWeight.w600,
          fontSize: 14,
          height: 1.4,
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
          "Routine Insights",
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _routines.isEmpty
              ? const Center(
                  child: Text(
                    "No routines yet",
                    style: TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontSize: 16,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _insightBanner(),
                      const SizedBox(height: 30),

                      // Stats row 1
                      Row(
                        children: [
                          _statCard(
                            "Avg Emotional Load",
                            _avgEmotional.toString(),
                            const Color(0xFF8A4FFF),
                          ),
                          const SizedBox(width: 14),
                          _statCard(
                            "Avg Fatigue Impact",
                            _avgFatigue.toString(),
                            const Color(0xFFB76EFF),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Stats row 2
                      Row(
                        children: [
                          _statCard(
                            "Avg Duration",
                            "${_avgDuration}m",
                            const Color(0xFF5A4A6A),
                          ),
                          const SizedBox(width: 14),
                          _statCard(
                            "Best Streak",
                            _bestStreak.toString(),
                            const Color(0xFF8A4FFF),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      const Text(
                        "Your Patterns",
                        style: TextStyle(
                          color: Color(0xFF5A4A6A),
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 12),

                      const Text(
                        "Your routines show how you move through your days — where you carry emotional weight, where you expend energy, and where you shine with consistency. These insights help you build a life that feels aligned, intentional, and grounded.",
                        style: TextStyle(
                          color: Color(0xFF7A6F8F),
                          height: 1.4,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
