import 'package:flutter/material.dart';

// UI modules
import '../ui/home/home_screen.dart';
import '../ui/calendar/calendar_screen.dart';
import '../ui/tasks/tasks_screen.dart';
import '../ui/routines/routines_screen.dart';
import '../ui/habits/habits_screen.dart';
import '../ui/clients/client_list_screen.dart';
import '../ui/services/service_list_screen.dart';
import '../ui/settings/settings_screen.dart';
import 'ui/developer_shell_screen.dart' as dev_shell;

class CiantisRouter {
  static const String homeRoute = '/';
  static const String calendarRoute = '/calendar';
  static const String tasksRoute = '/tasks';
  static const String routinesRoute = '/routines';
  static const String habitsRoute = '/habits';
  static const String clientsRoute = '/clients';
  static const String servicesRoute = '/services';
  static const String settingsRoute = '/settings';
  static const String developerShellRoute = '/developer';

  static Route<dynamic> buildRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return _material(const HomeScreen());
      case calendarRoute:
        return _material(const CalendarScreen());
      case tasksRoute:
        return _material(const TasksScreen());
      case routinesRoute:
        return _material(const RoutinesScreen());
      case habitsRoute:
        return _material(const HabitsScreen());
      case clientsRoute:
        return _material(const ClientListScreen());
      case servicesRoute:
        return _material(const ServiceListScreen());
      case settingsRoute:
        return _material(const SettingsScreen());
      case developerShellRoute:
        return _material(const dev_shell.DeveloperShellScreen());
      default:
        return _material(const HomeScreen());
    }
  }

  static MaterialPageRoute _material(Widget child) {
    return MaterialPageRoute(builder: (_) => child);
  }
}
