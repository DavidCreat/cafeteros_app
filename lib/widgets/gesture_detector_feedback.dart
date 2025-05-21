import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget que proporciona feedback táctil y visual para gestos
class GestureDetectorFeedback extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final GestureDragUpdateCallback? onHorizontalDragUpdate;
  final GestureDragEndCallback? onHorizontalDragEnd;
  final bool enableFeedback;
  final bool enableHapticFeedback;
  final HapticFeedbackType hapticFeedbackType;
  final Duration animationDuration;
  final double scaleOnTap;

  const GestureDetectorFeedback({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.enableFeedback = true,
    this.enableHapticFeedback = true,
    this.hapticFeedbackType = HapticFeedbackType.lightImpact,
    this.animationDuration = const Duration(milliseconds: 100),
    this.scaleOnTap = 0.98,
  });

  @override
  Widget build(BuildContext context) {
    return _GestureDetectorWithFeedback(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onHorizontalDragUpdate: onHorizontalDragUpdate,
      onHorizontalDragEnd: onHorizontalDragEnd,
      enableFeedback: enableFeedback,
      enableHapticFeedback: enableHapticFeedback,
      hapticFeedbackType: hapticFeedbackType,
      animationDuration: animationDuration,
      scaleOnTap: scaleOnTap,
      child: child,
    );
  }
}

/// Tipos de feedback háptico disponibles
enum HapticFeedbackType {
  lightImpact,
  mediumImpact,
  heavyImpact,
  selectionClick,
  vibrate
}

class _GestureDetectorWithFeedback extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final GestureDragUpdateCallback? onHorizontalDragUpdate;
  final GestureDragEndCallback? onHorizontalDragEnd;
  final bool enableFeedback;
  final bool enableHapticFeedback;
  final HapticFeedbackType hapticFeedbackType;
  final Duration animationDuration;
  final double scaleOnTap;

  const _GestureDetectorWithFeedback({
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.enableFeedback = true,
    this.enableHapticFeedback = true,
    this.hapticFeedbackType = HapticFeedbackType.lightImpact,
    this.animationDuration = const Duration(milliseconds: 100),
    this.scaleOnTap = 0.98,
  });

  @override
  State<_GestureDetectorWithFeedback> createState() => _GestureDetectorWithFeedbackState();
}

class _GestureDetectorWithFeedbackState extends State<_GestureDetectorWithFeedback> {
  bool _isTapped = false;

  void _triggerHapticFeedback() {
    if (!widget.enableHapticFeedback) return;

    switch (widget.hapticFeedbackType) {
      case HapticFeedbackType.lightImpact:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.mediumImpact:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavyImpact:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.selectionClick:
        HapticFeedback.selectionClick();
        break;
      case HapticFeedbackType.vibrate:
        HapticFeedback.vibrate();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.enableFeedback) {
          setState(() => _isTapped = true);
          _triggerHapticFeedback();
        }
      },
      onTapUp: (_) {
        if (widget.enableFeedback) {
          setState(() => _isTapped = false);
        }
      },
      onTapCancel: () {
        if (widget.enableFeedback) {
          setState(() => _isTapped = false);
        }
      },
      onTap: widget.onTap,
      onDoubleTap: widget.onDoubleTap,
      onLongPress: widget.onLongPress != null
          ? () {
              _triggerHapticFeedback();
              widget.onLongPress!();
            }
          : null,
      onHorizontalDragUpdate: widget.onHorizontalDragUpdate,
      onHorizontalDragEnd: widget.onHorizontalDragEnd,
      child: AnimatedScale(
        scale: _isTapped ? widget.scaleOnTap : 1.0,
        duration: widget.animationDuration,
        child: widget.child,
      ),
    );
  }
}

/// Widget para implementar deslizamiento horizontal con feedback
class SwipeableFeedback extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final double threshold;
  final bool enableHapticFeedback;

  const SwipeableFeedback({
    super.key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.threshold = 0.2,
    this.enableHapticFeedback = true,
  });

  @override
  State<SwipeableFeedback> createState() => SwipeableFeedbackState();
}

class SwipeableFeedbackState extends State<SwipeableFeedback> {
  double _dragDistance = 0;
  double _dragThreshold = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _dragThreshold = constraints.maxWidth * widget.threshold;
        
        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              _dragDistance += details.delta.dx;
              // Limitar el arrastre para que no sea excesivo
              _dragDistance = _dragDistance.clamp(-_dragThreshold * 1.5, _dragThreshold * 1.5);
            });
          },
          onHorizontalDragEnd: (details) {
            if (_dragDistance.abs() > _dragThreshold) {
              if (widget.enableHapticFeedback) {
                HapticFeedback.mediumImpact();
              }
              
              if (_dragDistance > 0 && widget.onSwipeRight != null) {
                widget.onSwipeRight!();
              } else if (_dragDistance < 0 && widget.onSwipeLeft != null) {
                widget.onSwipeLeft!();
              }
            }
            
            setState(() {
              _dragDistance = 0;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            transform: Matrix4.translationValues(_dragDistance, 0, 0),
            child: widget.child,
          ),
        );
      },
    );
  }
}