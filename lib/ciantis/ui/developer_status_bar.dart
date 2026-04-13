import 'package:flutter/material.dart';
import '../universal/ciantis_context.dart';
import '../universal/developer_logger.dart';

/// DeveloperStatusBar
/// -------------------
/// A thin, always-visible HUD showing real-time system state:
/// - Mode
/// - Energy
/// - Stress
/// - Task Load
/// - Calendar Load
/// - Last Tick
///
/// Automatically rebuilds when context updates.
class DeveloperStatusBar extends StatefulWidget {
  const DeveloperStatusBar({super.key});

  @override
  State<DeveloperStatusBar> createState() => _DeveloperStatusBarState();
}

class _DeveloperStatusBarState extends State<DeveloperStatusBar> {
  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("DeveloperStatusBar initialized");
  }

  @override
  Widget build(BuildContext context) {
    final ctx = CiantisContext.instance;

    return AnimatedBuilder(
      animation: ctx,
      builder: (context, _) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.55),
            border: const Border(
              bottom: BorderSide(
                color: Colors.tealAccent,
                width: 0.4,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side: Mode
              Text(
                "Mode: ${ctx.mode}",
                style: const TextStyle(
                  color: Colors.tealAccent,
                  fontSize: 11,
                ),
              ),

              // Right side: Metrics
              Text(
                "E:${ctx.energy}  S:${ctx.stress}  T:${ctx.taskLoad}  C:${ctx.calendarLoad}",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
