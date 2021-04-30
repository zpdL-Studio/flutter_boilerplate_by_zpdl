import 'package:flutter/material.dart';

import 'bloc.dart';
import 'exception/bloc_not_found_exception.dart';

typedef BLoCBuilderCallback<T extends BLoC> = Widget Function(BuildContext context, T bLoC);

abstract class BLoCProvider<T extends BLoC> extends StatefulWidget {

  final BLoCBuilderCallback<T> builder;

  const BLoCProvider({Key? key, required this.builder}) : super(key: key);
}

abstract class BLoCConsumer<T extends BLoC> extends StatelessWidget {

  static T of<T extends BLoC>(BuildContext context) {
    throw BLoCNotFoundException('BLoCConsumer T : $T');
  }

  final BLoCBuilderCallback<T> builder;

  const BLoCConsumer({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return builder(context, BLoCConsumer.of<T>(context));
  }
}

abstract class BLoCBuilder<T extends BLoC> extends StatelessWidget {

  final T _bloC;

  const BLoCBuilder(T bLoC): _bloC = bLoC;

  @override
  Widget build(BuildContext context) {
    return builder(context, _bloC);
  }

  Widget builder(BuildContext context, T bLoC);
}