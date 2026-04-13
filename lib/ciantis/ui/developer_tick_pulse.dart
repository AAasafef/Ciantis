import 'package:flutter/material.dart';
import '../universal/developer_logger.dart';
import '../universal/universal_tick_scheduler.dart';

/// DeveloperTickPulse
/// -------------------
/// A tiny dot that flashes every time the Universal Tick runs.
/// This gives developers a real-time heartbeat indicator.
class DeveloperTickPulse extends StatefulWidget {
  const DeveloperTickPulse({super.key});

  @override
  State<DeveloperTickPulse> createState() => _DeveloperTickPulseState();
}

class _DeveloperTickPulseState extends State<DeveloperTickPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    DeveloperLogger.log("DeveloperTickPulse initialized");

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _opacity = Tween<double>(begin: 0.15, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Listen for tick events
    UniversalTickScheduler.instance.addListener(_onTick);
  }

  void _onTick() {
    DeveloperLogger.log("DeveloperTickPulse: tick pulse triggered");

    _controller.forward(from: 0).then((_) {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    UniversalTickScheduler.instance.removeListener(_onTick);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, _) {
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.tealAccent.withOpacity(_opacity.value),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.tealAccent.withOpacity(_opacity.value * 0.6),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      },
    );
  }
}
