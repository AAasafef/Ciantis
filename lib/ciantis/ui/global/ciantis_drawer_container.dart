import 'package:flutter/material.dart';
import 'ciantis_drawer.dart';

/// CiantisDrawerContainer
/// -----------------------
/// Wraps the entire app and provides:
/// - Custom luxury drawer motion
/// - Parallax slide
/// - Fade overlay
/// - Smooth easing
/// - Global accessor (of(context))
class CiantisDrawerContainer extends StatefulWidget {
  final Widget child;

  const CiantisDrawerContainer({super.key, required this.child});

  /// NEW: Global accessor
  static _CiantisDrawerContainerState of(BuildContext context) {
    final state = context.findAncestorStateOfType<_CiantisDrawerContainerState>();
    if (state == null) {
      throw FlutterError(
        "CiantisDrawerContainer.of(context) called with no ancestor.\n"
        "Ensure your widget tree is wrapped in CiantisDrawerContainer.",
      );
    }
    return state;
  }

  @override
  State<CiantisDrawerContainer> createState() => _CiantisDrawerContainerState();
}

class _CiantisDrawerContainerState extends State<CiantisDrawerContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool get isOpen => _controller.value > 0.5;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
      curve: const Cubic(0.22, 0.61, 0.36, 1),
    );
  }

  void open() => _controller.forward();
  void close() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Main content (parallax)
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final slide = 260 * _controller.value * 0.90; // 90% parallax
            return Transform.translate(
              offset: Offset(slide, 0),
              child: child,
            );
          },
          child: widget.child,
        ),

        /// Drawer panel
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final slide = -260 + (260 * _controller.value);
            return Positioned(
              left: slide,
              top: 0,
              bottom: 0,
              width: 260,
              child: child!,
            );
          },
          child: const CiantisDrawer(),
        ),

        /// Fade overlay when drawer is open
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return IgnorePointer(
              ignoring: !isOpen,
              child: Opacity(
                opacity: _controller.value * 0.45,
                child: GestureDetector(
                  onTap: close,
                  child: Container(color: Colors.black),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
