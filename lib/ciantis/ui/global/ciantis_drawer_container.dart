import 'package:flutter/material.dart';
import 'ciantis_drawer.dart';

/// CiantisDrawerContainer
/// -----------------------
/// Provides:
/// - Luxury drawer motion
/// - Parallax slide
/// - Fade overlay
/// - Smooth easing
/// - Global accessor
/// - Swipe-to-open
/// - Swipe-to-close
class CiantisDrawerContainer extends StatefulWidget {
  final Widget child;

  const CiantisDrawerContainer({super.key, required this.child});

  /// Global accessor
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

  /// Gesture handling
  void _onDragStart(DragStartDetails details) {}

  void _onDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta ?? 0;

    // Convert drag movement into controller progress
    _controller.value += delta / 260;
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    // Velocity-based settle
    if (velocity > 300) {
      open();
    } else if (velocity < -300) {
      close();
    } else {
      // Settle based on position
      if (_controller.value > 0.5) {
        open();
      } else {
        close();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Swipe-to-open (left edge)
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,

            onHorizontalDragStart: (details) {
              if (!isOpen && details.globalPosition.dx > 24) return;
              _onDragStart(details);
            },
            onHorizontalDragUpdate: (details) {
              if (!isOpen && details.globalPosition.dx > 24) return;
              _onDragUpdate(details);
            },
            onHorizontalDragEnd: _onDragEnd,
          ),
        ),

        /// Main content (swipe-to-close)
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final slide = 260 * _controller.value * 0.90;
            return GestureDetector(
              behavior: HitTestBehavior.translucent,

              /// Allow swipe-to-close anywhere on screen
              onHorizontalDragUpdate: isOpen ? _onDragUpdate : null,
              onHorizontalDragEnd: isOpen ? _onDragEnd : null,

              child: Transform.translate(
                offset: Offset(slide, 0),
                child: child,
              ),
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

        /// Fade overlay
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return IgnorePointer(
              ignoring: !isOpen,
              child: Opacity(
                opacity: _controller.value * 0.45,
                child: GestureDetector(
                  onTap: close,
                  onHorizontalDragUpdate: _onDragUpdate,
                  onHorizontalDragEnd: _onDragEnd,
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
