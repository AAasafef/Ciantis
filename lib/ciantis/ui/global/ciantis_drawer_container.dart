import 'package:flutter/material.dart';
import 'ciantis_drawer.dart';
import '../../universal/ambient_motion_engine.dart';
import '../../universal/ambient_sound_engine.dart';

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
/// - Depth shadow + ambient occlusion
/// - Drawer state callbacks (AI-aware)
/// - Ambient Motion Engine integration
/// - Ambient Sound hooks for open/close
class CiantisDrawerContainer extends StatefulWidget {
  final Widget child;

  final VoidCallback? onOpen;
  final VoidCallback? onClose;
  final ValueChanged<double>? onProgress;

  const CiantisDrawerContainer({
    super.key,
    required this.child,
    this.onOpen,
    this.onClose,
    this.onProgress,
  });

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
      duration: AmbientMotionEngine.instance.adaptiveDuration,
    );

    _controller.addListener(_handleProgress);
    _controller.addStatusListener(_handleStatus);
  }

  void _handleProgress() {
    widget.onProgress?.call(_controller.value);
  }

  void _handleStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onOpen?.call();
    } else if (status == AnimationStatus.dismissed) {
      widget.onClose?.call();
    }
  }

  void open() {
    _controller.duration = AmbientMotionEngine.instance.adaptiveDuration;

    // 🔊 Play drawer open sound
    AmbientSoundEngine.instance.drawerOpen();

    _controller.forward();
  }

  void close() {
    _controller.duration = AmbientMotionEngine.instance.adaptiveDuration;

    // 🔊 Play drawer close sound
    AmbientSoundEngine.instance.drawerClose();

    _controller.reverse();
  }

  void _onDragStart(DragStartDetails details) {}

  void _onDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta ?? 0;
    _controller.value += delta / 260;
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    if (velocity > 300) {
      open();
    } else if (velocity < -300) {
      close();
    } else {
      if (_controller.value > 0.5) {
        open();
      } else {
        close();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final curve = AmbientMotionEngine.instance.adaptiveCurve;

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
            final progress = curve.transform(_controller.value);
            final slide = 260 * progress * 0.90;

            return GestureDetector(
              behavior: HitTestBehavior.translucent,
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

        /// Drawer panel + depth shadow
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final progress = curve.transform(_controller.value);
            final slide = -260 + (260 * progress);

            return Positioned(
              left: slide,
              top: 0,
              bottom: 0,
              width: 260,
              child: Stack(
                children: [
                  Positioned(
                    right: -1,
                    top: 0,
                    bottom: 0,
                    width: 18,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.black.withOpacity(0.28),
                              Colors.black.withOpacity(0.12),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  child!,
                ],
              ),
            );
          },
          child: const CiantisDrawer(),
        ),

        /// Fade overlay
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final progress = curve.transform(_controller.value);

            return IgnorePointer(
              ignoring: !isOpen,
              child: Opacity(
                opacity: progress * 0.45,
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
