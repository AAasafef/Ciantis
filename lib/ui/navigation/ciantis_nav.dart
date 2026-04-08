import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class CiantisNav extends StatefulWidget {
  const CiantisNav({super.key});

  @override
  State<CiantisNav> createState() => _CiantisNavState();
}

class _CiantisNavState extends State<CiantisNav> {
  int _index = 0;

  final List<Widget> _screens = const [
    CiantisHomeScreen(),
    Placeholder(), // Future: Modes
    Placeholder(), // Future: Intelligence
    Placeholder(), // Future: Settings
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) {
          setState(() {
            _index = i;
          });
        },
        selectedItemColor: const Color(0xFF8A4FFF),
        unselectedItemColor: const Color(0xFFB8AFCF),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bubble_chart_rounded),
            label: 'Modes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_rounded),
            label: 'AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
