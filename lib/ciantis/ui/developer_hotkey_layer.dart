import 'package:flutter/material.dart';
import 'developer_log_overlay.dart';
import '../universal/developer_logger.dart';

/// DeveloperHotkeyLayer
/// ---------------------
/// Wraps the entire app and listens for a triple‑tap gesture.
/// When detected, it toggles the Developer Log Overlay.
///
/// This gives developers a universal shortcut to open/close
/// the live console without needing to tap the floating button.
class DeveloperHotkeyLayer extends StatefulWidget {
  final Widget child;

  const DeveloperHotkeyLayer({super.key, required this.child});

  @override
  State<DeveloperHotkeyLayer> createState() => _DeveloperHotkeyLayerState();
}

class _DeveloperHotkeyLayerState extends State<DeveloperHotkeyLayer> {
  bool _overlayVisible = false;
  int _tapCount = 0;
  DateTime _lastTap = DateTime.now();

  void _handleTap() {
    final now = DateTime.now();
    final diff = now.difference(_lastTap).inMilliseconds;
    _lastTap = now;

    if (diff < 350) {
      _tapCount++;
    } else {
      _tapCount = 1;
    }

    if (_tapCount == 3) {
      setState(() => _overlayVisible = !_overlayVisible);
      DeveloperLogger.log(
        "DeveloperHotkeyLayer: triple‑tap detected → overlay=$_overlayVisible"
      );
      _tapCount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _handleTap,
      child: Stack(
        children: [
          widget.child,
          if (_overlayVisible) const DeveloperLogOverlay(),
        ],
      ),
    );
  }
}
