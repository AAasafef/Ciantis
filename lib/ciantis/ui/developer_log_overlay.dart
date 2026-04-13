import 'package:flutter/material.dart';
import '../universal/developer_logger.dart';
import 'developer_logs_screen.dart';

/// DeveloperLogOverlay
/// --------------------
/// A draggable, toggleable floating console that shows
/// the most recent developer logs in real time.
///
/// This is extremely useful during development to see
/// tick events, mode changes, context refreshes, etc.
class DeveloperLogOverlay extends StatefulWidget {
  const DeveloperLogOverlay({super.key});

  @override
  State<DeveloperLogOverlay> createState() => _DeveloperLogOverlayState();
}

class _DeveloperLogOverlayState extends State<DeveloperLogOverlay> {
  bool _visible = false;
  Offset _position = const Offset(20, 120);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Toggle button
        Positioned(
          left: 20,
          bottom: 40,
          child: FloatingActionButton(
            backgroundColor: Colors.tealAccent,
            child: Icon(
              _visible ? Icons.visibility_off : Icons.visibility,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() => _visible = !_visible);
              DeveloperLogger.log(
                "DeveloperLogOverlay: visibility toggled → $_visible"
              );
            },
          ),
        ),

        // Overlay console
        if (_visible)
          Positioned(
            left: _position.dx,
            top: _position.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _position += details.delta;
                });
              },
              child: Container(
                width: 320,
                height: 260,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.tealAccent.withOpacity(0.6),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Live Logs",
                          style: TextStyle(
                            color: Colors.tealAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.open_in_full,
                            color: Colors.white70,
                            size: 18,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DeveloperLogsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Log list
                    Expanded(
                      child: AnimatedBuilder(
                        animation: DeveloperLogStore.instance,
                        builder: (context, _) {
                          final logs = DeveloperLogStore.instance.logs;

                          return ListView.builder(
                            reverse: true,
                            itemCount: logs.length > 20 ? 20 : logs.length,
                            itemBuilder: (context, index) {
                              return Text(
                                logs[index],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  height: 1.25,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
