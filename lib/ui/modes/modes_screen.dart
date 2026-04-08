import 'package:flutter/material.dart';

class ModesScreen extends StatelessWidget {
  const ModesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Modes',
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _modeCard(
              icon: Icons.nightlight_round,
              title: 'Night Goddess Mode',
              color: const Color(0xFF8A4FFF),
            ),
            _modeCard(
              icon: Icons.cut_rounded,
              title: 'Salon Mode',
              color: const Color(0xFFE91E63),
            ),
            _modeCard(
              icon: Icons.family_restroom_rounded,
              title: 'Mom Mode',
              color: const Color(0xFF6A4C93),
            ),
            _modeCard(
              icon: Icons.school_rounded,
              title: 'Study Mode',
              color: const Color(0xFF3F51B5),
            ),
            _modeCard(
              icon: Icons.favorite_rounded,
              title: 'Health Mode',
              color: const Color(0xFFEC407A),
            ),
            _modeCard(
              icon: Icons.self_improvement_rounded,
              title: 'Calm Mode',
              color: const Color(0xFF26A69A),
            ),
            _modeCard(
              icon: Icons.bolt_rounded,
              title: 'Productivity Mode',
              color: const Color(0xFFFFA726),
            ),
            _modeCard(
              icon: Icons.healing_rounded,
              title: 'Recovery Mode',
              color: const Color(0xFFAB47BC),
            ),
            _modeCard(
              icon: Icons.auto_awesome_rounded,
              title: 'Goddess Mode',
              color: const Color(0xFFD81B60),
            ),
            _modeCard(
              icon: Icons.local_hospital_rounded,
              title: 'Clinical Mode',
              color: const Color(0xFF5C6BC0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
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
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5A4A6A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
