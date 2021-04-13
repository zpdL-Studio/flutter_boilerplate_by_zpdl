import 'package:flutter/material.dart';

typedef ThemeWidgetBuilder = Widget Function(BuildContext context, ThemeData theme);

class ThemeBuilder extends StatelessWidget {

  final ThemeWidgetBuilder builder;

  const ThemeBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return builder(context, Theme.of(context));
  }
}

typedef ThemeLayoutWidgetBuilder = Widget Function(BuildContext context, ThemeData theme, double width, double height);

class ThemeLayoutBuilder extends StatelessWidget {

  final ThemeLayoutWidgetBuilder builder;

  const ThemeLayoutBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return builder(context, Theme.of(context), constraints.maxWidth, constraints.maxHeight);
    });
  }
}