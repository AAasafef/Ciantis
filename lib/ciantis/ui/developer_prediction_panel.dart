import 'package:flutter/material.dart';
import '../universal/prediction_engine.dart';
import '../universal/developer_logger.dart';

/// DeveloperPredictionPanel
/// -------------------------
/// Shows internal prediction engine metrics:
/// - Prediction label
/// - Confidence
/// - Horizon
/// - Stability
///
/// This gives developers a real-time view of Ciantis’ predictive intelligence.
class DeveloperPredictionPanel extends StatefulWidget {
  const DeveloperPredictionPanel({super.key});

  @override
  State<DeveloperPredictionPanel> createState() =>
      _DeveloperPredictionPanelState();
}

class _DeveloperPredictionPanelState extends State<DeveloperPredictionPanel> {
  String _label = "(none)";
  double _confidence = 0.0;
  double _horizon = 0.0;
  double _stability = 0.0;

  @override
  void initState() {
    super.initState();
    DeveloperLogger.log("DeveloperPredictionPanel initialized");

    PredictionEngine.instance.addListener(_update);
    _update();
  }

  void _update() {
    final p = PredictionEngine.instance;

    setState(() {
      _label = p.predictionLabel;
      _confidence = p.predictionConfidence;
      _horizon = p.predictionHorizon;
      _stability = p.predictionStability;
    });
  }

  @override
  void dispose() {
    PredictionEngine.instance.removeListener(_update);
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
            "Predict: $_label  Conf: ${_fmt(_confidence)}",
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 10.5,
            ),
          ),
          Text(
            "Horizon: ${_fmt(_horizon)}  Stability: ${_fmt(_stability)}",
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
