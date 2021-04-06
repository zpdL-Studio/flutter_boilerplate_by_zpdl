import 'package:flutter/material.dart';

import '../bloc.dart';
import '../bloc_provider.dart';

export '../bloc_provider.dart';

abstract class BLoCState<T extends BLoCProvider> extends State<T> implements BLoC {

  static T of<T extends BLoCState>(BuildContext context) {
    final T state = context.findAncestorStateOfType<T>()!;
    return state;
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) => widget.builder(context, this);

  @override
  void dispose() {
    super.dispose();
    disposeBLoC();
  }
}

// abstract class BLoCStateProvider<T extends BLoCState> extends BLoCProvider<T> {
//
//   const BLoCStateProvider({Key? key}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => createStateBLoC();
//
//   T createStateBLoC();
// }

// abstract class BLoCStateTest {
//   String get name;
// }