import 'package:flutter/material.dart';
import 'developer_menu_screen.dart';

/// DeveloperShellScreen
/// ---------------------
/// A simple wrapper screen that hosts the Developer Menu.
/// This allows the developer tools to live as a standalone tab.
class DeveloperShellScreen extends StatelessWidget {
  const DeveloperShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DeveloperMenuScreen();
  }
}
