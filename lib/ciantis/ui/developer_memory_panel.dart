import 'package:flutter/material.dart';
import '../universal/memory_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperMemoryPanel
/// ---------------------
/// Shows internal memory engine metrics:
/// - Short-term memory load
/// - Long-term memory load
/// - Memory churn rate
/// - Memory confidence
///
/// This gives developers a real-time view of Ciantis’ memory stability.
class DeveloperMemoryPanel extends StatefulWidget {
  const DeveloperMemoryPanel({super.key});

  @override
  State<DeveloperMemoryPanel> createState() => _DeveloperMemoryPanelState();
}

class _DeveloperMemoryPanelState extends State<DeveloperMemoryPanel> {
  double _short = 0.0;
  double _long = 0.0;
  double _churn = 0.0;
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("DeveloperMemoryPanel initialized");

    MemoryEngine.instance.addListener(_update);
    _update();
  }

  void _update() {
    final m = MemoryEngine.instance;

    setState(() {
      _short = m.shortTermLoad;
      _long = m.longTermLoad;
      _churn = m.churnRate;
      _confidence = m.memoryConfidence;
    });
  }

  @override
  void dispose() {
    MemoryEngine.instance.removeListener(_update);
    super.dispose();
  }

  String _fmt(double v) => v.toStringAsFixed(2);

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
            "Short: ${_fmt(_short)}  Long: ${_fmt(_long)}",
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 10.5,
            ),
          ),
          Text(
            "Churn: ${_fmt(_churn)}  Conf: ${_fmt(_confidence)}",
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
