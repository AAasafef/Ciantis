import 'package:flutter/material.dart';
import '../universal/system_load_monitor.dart';
import '../universal/developer_logger.dart';

/// DeveloperSystemLoadPanel
/// -------------------------
/// Shows internal system load metrics:
/// - Tick latency
/// - Tick jitter
/// - FPS
/// - UI rebuild count
///
/// This gives developers a real-time view of Ciantis’ internal performance.
class DeveloperSystemLoadPanel extends StatefulWidget {
  const DeveloperSystemLoadPanel({super.key});

  @override
  State<DeveloperSystemLoadPanel> createState() =>
      _DeveloperSystemLoadPanelState();
}

class _DeveloperSystemLoadPanelState extends State<DeveloperSystemLoadPanel> {
  double _latency = 0.0;
  double _jitter = 0.0;
  double _fps = 0.0;
  int _rebuilds = 0;

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("DeveloperSystemLoadPanel initialized");

    SystemLoadMonitor.instance.addListener(_update);
    _update();
  }

  void _update() {
    final m = SystemLoadMonitor.instance;

    setState(() {
      _latency = m.tickLatencyMs;
      _jitter = m.tickJitterMs;
      _fps = m.fps;
      _rebuilds = m.rebuildCount;
    });
  }

  @override
  void dispose() {
    SystemLoadMonitor.instance.removeListener(_update);
    super.dispose();
  }

  String _fmt(double v) => v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.40),
        border: const Border(
          bottom: BorderSide(
            color: Colors.tealAccent,
            width: 0.35,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Latency: ${_fmt(_latency)}ms  Jitter: ${_fmt(_jitter)}ms",
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 10.5,
            ),
          ),
          Text(
            "FPS: ${_fmt(_fps)}  Rebuilds: $_rebuilds",
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }
}
