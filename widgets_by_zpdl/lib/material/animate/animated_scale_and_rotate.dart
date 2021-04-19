import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../config.dart';

class AnimatedScale extends StatelessWidget {

  final Widget child;
  final double scale;
  final Duration? duration;

  const AnimatedScale({Key? key, required this.child, required this.scale, this.duration,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedScaleAndRotate(
      child: child,
      scale: scale,
      duration: duration,
    );
  }
}

class AnimatedRotate extends StatelessWidget {

  final Widget child;
  final double degree;
  final Duration? duration;

  const AnimatedRotate({Key? key, required this.child, required this.degree, this.duration,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedScaleAndRotate(
      child: child,
      degree: degree,
      duration: duration,
    );
  }
}

class AnimatedScaleAndRotate extends StatefulWidget {

  final Widget child;
  final double scale;
  final double degree;
  final Duration? duration;

  const AnimatedScaleAndRotate({Key? key, required this.child, this.scale = 1.0, this.degree = 0.0, this.duration}) : super(key: key);

  @override
  _AnimatedScaleAndRotateState createState() => _AnimatedScaleAndRotateState();
}

class _AnimatedScaleAndRotateState extends State<AnimatedScaleAndRotate> with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  Animation<double>? _animation;

  late double _srcScale;
  late double _srcDegree;

  late double _scale;
  late double _degree;

  @override
  void initState() {
    super.initState();

    _srcScale = widget.scale;
    _srcDegree = widget.degree;
    _scale = widget.scale;
    _degree = widget.degree;

    _controller = AnimationController(vsync: this, duration: widget.duration ?? configAnimateDuration);
  }

  @override
  void dispose() {
    super.dispose();
    _animation?.removeListener(_animate);
    _animation = null;
    _controller.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedScaleAndRotate oldWidget) {
    super.didUpdateWidget(oldWidget);

    if(widget.scale != oldWidget.scale || widget.degree != oldWidget.degree) {
      _tryAnimate();
    }
  }

  void _tryAnimate() {
    _srcScale = _scale;
    _srcDegree = _degree;

    _animation?.removeListener(_animate);
    _animation = null;
    _controller.reset();
    if(_srcScale != widget.scale || _srcDegree != widget.degree) {
      _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
      _animation?.addListener(_animate);
      _controller.forward();
    }
  }

  void _animate() {
    final animation = _animation;
    if(animation != null) {
      setState(() {
        _scale = _srcScale + (widget.scale - _srcScale) * animation.value;
        _degree = (_srcDegree + (widget.degree - _srcDegree) * animation.value);

        if(!_controller.isAnimating) {
          _animation?.removeListener(_animate);
          _animation = null;
          _controller.reset();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()..scale(_scale)..rotateZ(_degree / 360 * math.pi * 2.0),
      alignment: AlignmentDirectional.center,
      child: widget.child,
    );
  }
}
