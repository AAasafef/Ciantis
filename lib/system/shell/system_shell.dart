import 'package:flutter/material.dart';
import '../engine/engine.dart';
import '../../ui/home/home_screen.dart';

class CiantisSystemShell extends StatefulWidget {
  const CiantisSystemShell({super.key});

  @override
  State<CiantisSystemShell> createState() => _CiantisSystemShellState();
}

class _CiantisSystemShellState extends State<CiantisSystemShell> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _bootSystem();
  }

  Future<void> _bootSystem() async {
    await CiantisEngine.instance.start();
    setState(() {
      _ready = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Starting Ciantis Engine…',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8A4FFF),
            ),
          ),
        ),
      );
    }

    return const CiantisHomeScreen();
  }
}
