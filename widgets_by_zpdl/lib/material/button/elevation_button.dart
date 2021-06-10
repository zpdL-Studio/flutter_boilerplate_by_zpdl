import 'package:flutter/material.dart';

import '../../config.dart';
import '../touch_well.dart';

class ElevationButton extends StatefulWidget {

  final Widget child;
  final GestureTapCallback? onTap;

  final Color? color;
  final ShapeBorder? shape;

  final double? disabledOpacity;
  final double? elevation;
  final Duration? duration;

  const ElevationButton({
    Key? key,
    required this.child,
    this.onTap,
    this.color,
    this.shape,
    this.disabledOpacity,
    this.elevation,
    this.duration,
  }) : super(key: key);

  @override
  _ElevationButtonState createState() => _ElevationButtonState();
}

class _ElevationButtonState extends State<ElevationButton> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  Animation<double>? _animation;
  late double _elevation;

  @override
  void initState() {
    _elevation = widget.elevation ?? configElevationButton;
    _controller = AnimationController(vsync: this, duration: widget.duration);

    super.initState();
  }

  void _onElevationAnimate() {
    final animation = _animation;
    if(animation != null) {
      setState(() {
        _elevation = animation.value;
      });
    }
  }

  void _tryAnimation(double end) {
    if(_elevation == end) {
      return;
    }
    _animation?.removeListener(_onElevationAnimate);
    _controller.reset();
    _animation = Tween<double>(
      begin: _elevation,
      end: end,
    ).animate(_controller)..addListener(_onElevationAnimate);
    _controller.fling();
  }

  @override
  void dispose() {
    _animation?.removeListener(_onElevationAnimate);
    _animation = null;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.onTap != null ? 1.0 : (widget.disabledOpacity ?? configDisabledOpacity),
      duration: widget.duration ?? configAnimateDuration,
      child: TouchWell(
        onTap: widget.onTap != null ? () {
          _tryAnimation(widget.elevation ?? configElevationButton);
          final tap = widget.onTap;
          if(tap != null) {
            tap();
          }
        } : null,
        shape: widget.shape,
        bgColor: widget.color ?? Theme.of(context).backgroundColor,
        elevation: _elevation,
        onTapDown: (_) {
          _tryAnimation(0.0);
        },
        onTapCancel: () {
          _tryAnimation(widget.elevation ?? configElevationButton);
        },
        child: widget.child,
      ),
    );
  }
}
