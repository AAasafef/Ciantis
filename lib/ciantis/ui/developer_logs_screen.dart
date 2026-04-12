import 'package:flutter/material.dart';

/// DeveloperLogStore
/// ------------------
/// Simple in-memory log store for developer debugging.
/// This is not persistent and resets when the app restarts.
class DeveloperLogStore {
  static final DeveloperLogStore instance = DeveloperLogStore._internal();
  DeveloperLogStore._internal();

  final List<String> _logs = [];

  void add(String message) {
    final timestamp = DateTime.now().toIso8601String();
    _logs.insert(0, "[$timestamp] $message");
  }

  List<String> get logs => List.unmodifiable(_logs);

  void clear() {
    _logs.clear();
  }
}

/// DeveloperLogsScreen
/// --------------------
/// Displays all developer logs in a scrollable list.
class DeveloperLogsScreen extends StatefulWidget {
  const DeveloperLogsScreen({super.key});

  @override
  State<DeveloperLogsScreen> createState() => _DeveloperLogsScreenState();
}

class _DeveloperLogsScreenState extends State<DeveloperLogsScreen> {
  final _store = DeveloperLogStore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Developer Logs"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              _store.clear();
              setState(() {});
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _store.logs.length,
        itemBuilder: (context, index) {
          final log = _store.logs[index];
          return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              log,
              style: const TextStyle(
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          );
        },
      ),
    );
  }
}
