import 'package:flutter/material.dart';
import '../universal/cognitive_engine_orchestrator.dart';
import '../universal/developer_logger.dart';

/// DeveloperOrchestratorPanel
/// ---------------------------
/// Shows orchestrator heartbeat metrics:
/// - Running state
/// - Tick count
/// - Tick rate
/// - Last pulse timestamp
///
/// This gives developers visibility into the cognitive engine orchestrator.
class DeveloperOrchestratorPanel extends StatefulWidget {
  const DeveloperOrchestratorPanel({super.key});

  @override
  State<DeveloperOrchestratorPanel> createState() =>
      _DeveloperOrchestratorPanelState();
}

class _DeveloperOrchestratorPanelState
    extends State<DeveloperOrchestratorPanel> {
  bool _running = false;
  int _tickCount = 0;
  int _tickRate = CognitiveEngineOrchestrator.tickMs;
  String _lastPulse = "-";

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("DeveloperOrchestratorPanel initialized");

    /// Listen to orchestrator logs
    DeveloperLogger.addListener(_onLog);
  }

  @override
  void dispose() {
    DeveloperLogger.removeListener(_onLog);
    super.dispose();
  }

  void _onLog(String message) {
    if (message.contains("CognitiveEngineOrchestrator → START")) {
      setState(() => _running = true);
    }

    if (message.contains("CognitiveEngineOrchestrator → STOP")) {
      setState(() => _running = false);
    }

    if (message.contains("CognitiveEngineOrchestrator → TICK")) {
      setState(() {
        _tickCount++;
        _lastPulse = DateTime.now().toIso8601String();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateText = _running ? "ON" : "OFF";
    final stateColor = _running ? Colors.tealAccent : Colors.redAccent;

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
          /// Left side: state + tick count
          Row(
            children: [
              Text(
                "Orchestrator: ",
                style: const TextStyle(color: Colors.white60, fontSize: 10.5),
              ),
              Text(
                stateText,
                style: TextStyle(color: stateColor, fontSize: 10.5),
              ),
              const SizedBox(width: 12),
              Text(
                "Ticks: $_tickCount",
                style: const TextStyle(color: Colors.white60, fontSize: 10.5),
              ),
            ],
          ),

          /// Right side: tick rate + last pulse
          Row(
            children: [
              Text(
                "Rate: ${_tickRate}ms",
                style: const TextStyle(color: Colors.white60, fontSize: 10.5),
              ),
              const SizedBox(width: 12),
              Text(
                "Last: $_lastPulse",
                style: const TextStyle(color: Colors.white60, fontSize: 10.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
