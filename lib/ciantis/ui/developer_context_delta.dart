import 'package:flutter/material.dart';
import '../universal/ciantis_context.dart';
import '../universal/developer_logger.dart';

/// DeveloperContextDelta
/// ----------------------
/// Shows how the context changed on the last tick:
/// - Energy Δ
/// - Stress Δ
/// - Task Load Δ
/// - Calendar Load Δ
///
/// This gives developers a real-time view of how the system evolves.
class DeveloperContextDelta extends StatefulWidget {
  const DeveloperContextDelta({super.key});

  @override
  State<DeveloperContextDelta> createState() => _DeveloperContextDeltaState();
}

class _DeveloperContextDeltaState extends State<DeveloperContextDelta> {
  int _lastEnergy = CiantisContext.instance.energy;
  int _lastStress = CiantisContext.instance.stress;
  int _lastTask = CiantisContext.instance.taskLoad;
  int _lastCalendar = CiantisContext.instance.calendarLoad;

  int _dEnergy = 0;
  int _dStress = 0;
  int _dTask = 0;
  int _dCalendar = 0;

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("DeveloperContextDelta initialized");

    CiantisContext.instance.addListener(_update);
  }

  void _update() {
    final ctx = CiantisContext.instance;

    setState(() {
      _dEnergy = ctx.energy - _lastEnergy;
      _dStress = ctx.stress - _lastStress;
      _dTask = ctx.taskLoad - _lastTask;
      _dCalendar = ctx.calendarLoad - _lastCalendar;

      _lastEnergy = ctx.energy;
      _lastStress = ctx.stress;
      _lastTask = ctx.taskLoad;
      _lastCalendar = ctx.calendarLoad;
    });
  }

  @override
  void dispose() {
    CiantisContext.instance.removeListener(_update);
    super.dispose();
  }

  String _fmt(int v) {
    if (v > 0) return "+$v";
    if (v < 0) return "$v";
    return "0";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
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
            "ΔE:${_fmt(_dEnergy)}  ΔS:${_fmt(_dStress)}",
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 10.5,
            ),
          ),
          Text(
            "ΔT:${_fmt(_dTask)}  ΔC:${_fmt(_dCalendar)}",
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
