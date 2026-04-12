import 'package:flutter/material.dart';
import 'developer_menu_screen.dart';
import '../universal/developer_logger.dart';

/// CiantisShell
/// -------------
/// Main navigation shell for the app.
/// Bottom navigation:
/// - Home
/// - Calendar
/// - Tasks
/// - Developer (dev-only)
class CiantisShell extends StatefulWidget {
  const CiantisShell({super.key});

  @override
  State<CiantisShell> createState() => _CiantisShellState();
}

class _CiantisShellState extends State<CiantisShell> {
  int _index = 0;

  final _screens = const [
    _PlaceholderScreen("Home"),
    _PlaceholderScreen("Calendar"),
    _PlaceholderScreen("Tasks"),
    DeveloperMenuScreen(),
  ];

  void _onTap(int newIndex) {
    final oldIndex = _index;
    setState(() => _index = newIndex);

    DeveloperLogger.log(
      "Navigation: index $oldIndex → $newIndex (${_labelForIndex(newIndex)})"
    );
  }

  static String _labelForIndex(int index) {
    switch (index) {
      case 0:
        return "Home";
      case 1:
        return "Calendar";
      case 2:
        return "Tasks";
      case 3:
        return "Developer Menu";
      default:
        return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.white38,
        currentIndex: _index,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.developer_mode),
            label: "Dev",
          ),
        ],
      ),
    );
  }
}

/// Placeholder screens until modules are built
class _PlaceholderScreen extends StatelessWidget {
  final String label;
  const _PlaceholderScreen(this.label);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}
