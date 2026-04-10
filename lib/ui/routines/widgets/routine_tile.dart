import 'package:flutter/material.dart';
import '../../../data/models/routine_model.dart';

class RoutineTile extends StatelessWidget {
  final RoutineModel routine;
  final VoidCallback onTap;

  const RoutineTile({
    super.key,
    required this.routine,
    required this.onTap,
  });

  Color _emotionalColor(int value) {
    if (value >= 8) return const Color(0xFFE573B5); // high emotional
    if (value >= 5) return const Color(0xFF8A4FFF); // medium
    return const Color(0xFFB6AFC8); // low
  }

  Color _fatigueColor(int value) {
    if (value >= 8) return const Color(0xFFFFC94A); // high fatigue
    if (value >= 5) return const Color(0xFF7A6F8F); // medium
    return const Color(0xFFD8D2E3); // low
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emotional + fatigue dots
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: _emotionalColor(routine.emotionalLoad),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _fatigueColor(routine.fatigueImpact),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 14),

            // Title + category + steps + streak
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    routine.title,
                    style: const TextStyle(
                      color: Color(0xFF5A4A6A),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Category
                  Text(
                    routine.category[0].toUpperCase() +
                        routine.category.substring(1),
                    style: const TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Steps + streak row
                  Row(
                    children: [
                      Icon(Icons.list_alt,
                          size: 16, color: const Color(0xFF8A4FFF)),
                      const SizedBox(width: 4),
                      Text(
                        "${routine.steps.length} steps",
                        style: const TextStyle(
                          color: Color(0xFF5A4A6A),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Icon(Icons.local_fire_department,
                          size: 16, color: const Color(0xFFFF8A3D)),
                      const SizedBox(width: 4),
                      Text(
                        "${routine.streak} day streak",
                        style: const TextStyle(
                          color: Color(0xFF5A4A6A),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Active indicator
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: routine.isActive
                    ? const Color(0xFF8A4FFF).withOpacity(0.12)
                    : const Color(0xFFB6AFC8).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                routine.isActive ? "Active" : "Paused",
                style: TextStyle(
                  color: routine.isActive
                      ? const Color(0xFF8A4FFF)
                      : const Color(0xFF7A6F8F),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
