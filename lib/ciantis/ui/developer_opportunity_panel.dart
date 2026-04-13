import 'package:flutter/material.dart';
import '../universal/ciantis_context.dart';
import '../universal/developer_logger.dart';

/// DeveloperOpportunityPanel
/// --------------------------
/// Shows the current opportunity signal:
/// - Label
/// - Score
/// - Confidence
///
/// This gives developers a real-time view of what Ciantis believes
/// is the best opportunity for the user at this moment.
class DeveloperOpportunityPanel extends StatefulWidget {
  const DeveloperOpportunityPanel({super.key});

  @override
  State<DeveloperOpportunityPanel> createState() =>
      _DeveloperOpportunityPanelState();
}

class _DeveloperOpportunityPanelState extends State<DeveloperOpportunityPanel> {
  String _label = "None";
  double _score = 0.0;
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("DeveloperOpportunityPanel initialized");

    CiantisContext.instance.addListener(_update);
    _update();
  }

  void _update() {
    final ctx = CiantisContext.instance;

    setState(() {
      _label = ctx.opportunityLabel;
      _score = ctx.opportunityScore;
      _confidence = ctx.opportunityConfidence;
    });
  }

  @override
  void dispose() {
    CiantisContext.instance.removeListener(_update);
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
            "Opportunity: $_label",
            style: const TextStyle(
              color: Colors.tealAccent,
              fontSize: 10.5,
            ),
          ),
          Text(
            "Score: ${_fmt(_score)}  Conf: ${_fmt(_confidence)}",
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
