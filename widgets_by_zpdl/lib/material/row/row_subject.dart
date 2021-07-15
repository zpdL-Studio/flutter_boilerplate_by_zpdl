import 'package:flutter/material.dart';

import '../button/elevation_button.dart';
import '../button/scale_button.dart';

class RowSubject extends StatelessWidget {

  final Widget? title;
  final String? titleText;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? padding;
  final List<Widget> actions;

  const RowSubject({
    Key? key,
    this.title,
    this.titleText,
    this.padding,
    this.titleStyle,
    this.actions = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = titleStyle ?? Theme.of(context).textTheme.headline5;
    final children = <Widget>[];
    children.add(Expanded(
        flex: 1,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _buildTitle(style))));
    children.addAll(actions);

    return Padding(
      padding: padding ?? const EdgeInsetsDirectional.only(start: 16, end: 8, top: 16, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }

  Widget _buildTitle(TextStyle? style) {
    final title = this.title;
    if(title != null) {
      return title;
    }

    return Text(
      titleText ?? '',
      style: style,
    );
  }

  static Widget createElevationButton(Widget child, Color backgroundColor, {
    EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
    ShapeBorder shape = const CircleBorder(),
    GestureTapCallback? onTap}) {
    return ElevationButton(
      color: backgroundColor,
      shape: shape,
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }

  static Widget createScaleButton(Widget child, {
    double pressScale = 0.9,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
    ShapeBorder shape = const CircleBorder(),
    GestureTapCallback? onTap}) {
    return ScaleButton(
      pressScale: pressScale,
      shape: shape,
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}


