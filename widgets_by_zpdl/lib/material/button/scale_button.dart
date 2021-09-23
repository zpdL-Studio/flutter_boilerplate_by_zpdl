import 'package:flutter/material.dart';

import '../../config.dart';
import '../../widget/animate/animated_scale_and_rotate.dart';
import '../touch_well.dart';

class ScaleButton extends StatefulWidget {

  final Widget child;
  final GestureTapCallback? onTap;

  final Color? color;
  final ShapeBorder? shape;

  final double? disabledOpacity;
  final double? pressScale;
  final Duration? duration;

  const ScaleButton({
    Key? key,
    required this.child,
    this.onTap,
    this.color,
    this.shape,
    this.disabledOpacity,
    this.pressScale,
    this.duration,
  }) : super(key: key);

  @override
  _ScaleButtonState createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<ScaleButton> {

  late bool _pressed;

  @override
  void initState() {
    super.initState();
    _pressed = false;
  }

  @override
  Widget build(BuildContext context) {
    final child = AnimatedOpacity(
      opacity: widget.onTap != null ? 1.0 : (widget.disabledOpacity ?? configDisabledOpacity),
      duration: widget.duration ?? configAnimateDuration,
      child: widget.child,
    );

    if(widget.shape != null) {
      return _buildAnimatedScale(_buildTouchWell(child));
    } else {
      return _buildTouchWell(_buildAnimatedScale(child));
    }
  }

  Widget _buildTouchWell(Widget child) {
    return TouchWell(
      onTap: widget.onTap != null ? () {
        setState(() {
          _pressed = false;
        });
        final tap = widget.onTap;
        if(tap != null) {
          tap();
        }
      } : null,
      shape: widget.shape,
      bgColor: widget.color ?? Colors.transparent,
      onTapDown: (_) {
        setState(() {
          _pressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          _pressed = false;
        });
      },
      child: child
    );
  }

  Widget _buildAnimatedScale(Widget child) {
    return ZAnimatedScale(
      scale: _pressed ? (widget.pressScale ?? configPressScale) : 1.0,
      duration: widget.duration,
      child: child
    );
  }
}
