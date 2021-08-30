import 'package:flutter/widgets.dart';

import 'bloc_provider.dart';

class BLoCRouter {
  static final BLoCRouter _instance = BLoCRouter._();

  static final BLoCRouter instance = _instance;

  BLoCRouter._();

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {

  }
}

class BLoCRoutePage {
  final String name;
  final BLoCProviderBinding? binding;
  final WidgetBuilder builder;

  BLoCRoutePage({required this.name, this.binding, required this.builder, });
}