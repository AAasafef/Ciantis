import 'package:flutter/material.dart';

class AiScreen extends StatelessWidget {
  const AiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Ciantis Intelligence',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: ListView(
          children: [
            _sectionTitle('Insights'),
            const SizedBox(height: 12),
            _insightCard(
              icon: Icons.auto_awesome_rounded,
              title: 'Your energy is stabilizing',
              subtitle: 'Ciantis predicts a productive afternoon window.',
            ),
            const SizedBox(height: 20),

            _sectionTitle('Recommendations'),
            const SizedBox(height: 12),
            _insightCard(
              icon: Icons.favorite_rounded,
              title: 'Take a 5‑minute reset',
              subtitle: 'Your stress indicators suggest a short break.',
            ),
            const SizedBox(height: 20),

            _sectionTitle('Next Best Action'),
            const SizedBox(height: 12),
            _insightCard(
              icon: Icons.bolt_rounded,
              title: 'Review your study plan',
              subtitle: 'You have upcoming assignments that need attention.',
            ),
            const SizedBox(height: 20),

            _sectionTitle('Systems'),
            const SizedBox(height: 12),
            _systemRow(
              icon: Icons.school_rounded,
              title: 'Academic Intelligence',
              subtitle: 'Grades • Exams • Study load • Predictions',
            ),
            const SizedBox(height: 16),
            _systemRow(
              icon: Icons.favorite_rounded,
              title: 'Health Intelligence',
              subtitle: 'Sleep • Stress • Recovery • Patterns',
            ),
            const SizedBox(height: 16),
            _systemRow(
              icon: Icons.cut_rounded,
              title: 'Salon Intelligence',
              subtitle: 'Clients • Appointments • Trends',
            ),
          ],
        ),
      ),
    );
  }

  // Section Title
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF8A4FFF),
      ),
    );
  }

  // Insight Card
  Widget _insightCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: const Color(0xFF8A4FFF)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5A4A6A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7A6F8F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // System Row
  Widget _systemRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
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
      child: Row(
        children: [
          Icon(icon, size: 36, color: const Color(0xFF8A4FFF)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5A4A6A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7A6F8F),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            size: 28,
            color: Color(0xFF8A4FFF),
          ),
        ],
      ),
    );
  }
}
