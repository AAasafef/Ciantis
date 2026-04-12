import 'package:flutter/material.dart';

import '../tasks/ui/task_dashboard_screen.dart';
import 'ui/universal_dashboard_screen.dart';

class CiantisShell extends StatefulWidget {
  const CiantisShell({super.key});

  @override
  State<CiantisShell> createState() => _CiantisShellState();
}

class _CiantisShellState extends State<CiantisShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const UniversalDashboardScreen(),   // NEW
      const TaskDashboardScreen(),
      const _PlaceholderScreen(title: 'Calendar'),
      const _PlaceholderScreen(title: 'Settings'),
    ];

    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _index,
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.white38,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title coming soon',
          style: const TextStyle(color: Colors.white54),
        ),
      ),
    );
  }
}
