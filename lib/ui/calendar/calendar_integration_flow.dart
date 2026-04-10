import 'package:flutter/material.dart';
import 'calendar_month_view.dart';
import 'calendar_week_view.dart';
import 'calendar_day_view.dart';

class CalendarIntegrationFlow extends StatefulWidget {
  const CalendarIntegrationFlow({super.key});

  @override
  State<CalendarIntegrationFlow> createState() =>
      _CalendarIntegrationFlowState();
}

class _CalendarIntegrationFlowState extends State<CalendarIntegrationFlow> {
  int _index = 0;
  DateTime _selectedDate = DateTime.now();

  void _goToDay(DateTime date) {
    setState(() {
      _selectedDate = date;
      _index = 2; // Day View
    });
  }

  void _goToWeek(DateTime date) {
    setState(() {
      _selectedDate = date;
      _index = 1; // Week View
    });
  }

  void _goToMonth() {
    setState(() {
      _index = 0; // Month View
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      CalendarMonthView(),                 // index 0
      CalendarWeekView(),                  // index 1
      CalendarDayView(date: _selectedDate) // index 2
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      body: screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        selectedItemColor: const Color(0xFF8A4FFF),
        unselectedItemColor: const Color(0xFFB6AFC8),
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: (i) {
          if (i == 0) _goToMonth();
          if (i == 1) _goToWeek(_selectedDate);
          if (i == 2) _goToDay(_selectedDate);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Month",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_week),
            label: "Week",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: "Day",
          ),
        ],
      ),
    );
  }
}
