import 'package:flutter/material.dart';

int _touchWellProtectedMultiTapTimeMs = 0;

class TouchWell extends StatelessWidget {
  final Widget child;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final GestureTapCancelCallback? onTapCancel;
  final ValueChanged<bool>? onHighlightChanged;
  final ValueChanged<bool>? onHover;
  final Color? bgColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final Color? splashColor;
  final double elevation;
  final ShapeBorder? shape;
  final bool protectMultiTap;
  final bool touchWellIsTop;

  TouchWell({
    Key? key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapCancel,
    this.onHighlightChanged,
    this.onHover,
    this.bgColor,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.elevation = 0.0,
    this.shape,
    this.protectMultiTap = true,
    this.touchWellIsTop = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: bgColor,
        shape: shape,
        elevation: elevation,
        clipBehavior: shape != null ? Clip.hardEdge : Clip.none,
        child: touchWellIsTop == true
            ? Stack(
          children: [child, Positioned.fill(child: Material(color: Colors.transparent ,child: _buildInkWell(null)))],
        )
            : _buildInkWell(child));
  }

  Widget _buildInkWell(Widget? child) {
    return InkWell(
      onTap: protectMultiTap ? onTap != null ? () {
        final now = DateTime.now().millisecondsSinceEpoch;
        if(now - _touchWellProtectedMultiTapTimeMs > 300) {
          _touchWellProtectedMultiTapTimeMs = now;
          final tap = onTap;
          if(tap != null) {
            tap();
          }
        }
      } : null : onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onTapDown: onTapDown,
      onTapCancel: onTapCancel,
      onHighlightChanged: onHighlightChanged,
      onHover: onHover,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      child: child,
    );
  }
}
