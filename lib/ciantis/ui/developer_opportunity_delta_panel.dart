import 'package:flutter/material.dart';
import '../universal/opportunity_delta_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperOpportunityDeltaPanel
/// -------------------------------
/// Shows internal opportunity delta metrics:
/// - ΔOpportunity
/// - ΔConfidence
/// - Label stability
/// - Volatility index
///
/// This gives developers a real-time view of Ciantis’ opportunity-shift dynamics.
class DeveloperOpportunityDeltaPanel extends StatefulWidget {
  const DeveloperOpportunityDeltaPanel({super.key});

  @override
  State<DeveloperOpportunityDeltaPanel> createState() =>
      _DeveloperOpportunityDeltaPanelState();
}

class _DeveloperOpportunityDeltaPanelState
    extends State<DeveloperOpportunityDeltaPanel> {
  double _delta = 0.0;
  double _confDelta = 0.0;
  double _stability = 0.0;
  double _volatility = 0.0;

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("DeveloperOpportunityDeltaPanel initialized");

    OpportunityDeltaEngine.instance.addListener(_update);
    _update();
  }

  void _update() {
    final o = OpportunityDeltaEngine.instance;

    setState(() {
      _delta = o.deltaOpportunity;
      _confDelta = o.deltaConfidence;
      _stability = o.labelStability;
      _volatility = o.volatilityIndex;
    });
  }

  @override
  void dispose() {
    OpportunityDeltaEngine.instance.removeListener(_update);
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
            "ΔOpp: ${_fmt(_delta)}  ΔConf: ${_fmt(_confDelta)}",
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 10.5,
            ),
          ),
          Text(
            "Stability: ${_fmt(_stability)}  Vol: ${_fmt(_volatility)}",
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
