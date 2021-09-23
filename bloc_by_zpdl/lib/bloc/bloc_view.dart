import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'bloc.dart';
import 'bloc_provider.dart';

class BLoCState<B extends BLoC> {

  late B bLoc;

  void bLoCStateInit(dynamic tag, VoidCallback callback) {
    bLoc = BLoCProviders.instance.find<B>(tag: tag);
    bLoc.addListener(callback);
    if(bLoc is BLoCLifeCycle) {
      (bLoc as BLoCLifeCycle).attachView();
    }
  }

  void bLoCStateDispose(VoidCallback callback) {
    bLoc.removeListener(callback);
    if(bLoc is BLoCLifeCycle) {
      (bLoc as BLoCLifeCycle).detachView();
    }
  }
}

abstract class BLoCView<T extends BLoC> extends StatelessWidget implements Widget {
  BLoCView({Key? key, dynamic tag})
      : bLoC = BLoCProviders.instance.find(tag: tag),
        super(key: key);

  final T bLoC;

  @override
  StatelessElement createElement() => _BLoCViewElement(this);
}

class _BLoCViewElement extends StatelessElement {

  _BLoCViewElement(BLoCView widget) : super(widget);

  @override
  BLoCView get widget => super.widget as BLoCView;

  @override
  void mount(Element? parent, Object? newSlot) {
    final bLoC = widget.bLoC;
    bLoC.addListener(markNeedsBuild);
    if(bLoC is BLoCLifeCycle) {
      bLoC.attachView();
    }
    super.mount(parent, newSlot);
  }

  @override
  void unmount() {
    final bLoC = widget.bLoC;
    bLoC.removeListener(markNeedsBuild);
    if(bLoC is BLoCLifeCycle) {
      bLoC.detachView();
    }
    super.unmount();
  }
}
// abstract class BLoCView<T extends BLoC> extends StatefulWidget {
//
//   const BLoCView({Key? key,}) : super(key: key);
//
//   final dynamic tag = null;
//   T get bLoC => BLoCProviders.instance.find(tag: tag);
//
//   @override
//   _BLoCViewState<T> createState() => _BLoCViewState<T>();
//
//   Widget build(BuildContext context);
// }
//
// class _BLoCViewState<T extends BLoC> extends State<BLoCView<T>> {
//
//   final b = BLoCState<T>();
//
//   @override
//   void initState() {
//     super.initState();
//     b.bLoCStateInit(widget.tag, _handleBLoCChanged);
//   }
//
//   @override
//   void dispose() {
//     b.bLoCStateDispose(_handleBLoCChanged);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.build(context);
//   }
//
//   void _handleBLoCChanged() {
//     setState(() {
//     });
//   }
// }

class BLoCBuilder<T extends BLoC> extends StatefulWidget {

  const BLoCBuilder({Key? key, this.tag, required this.builder}) : super(key: key);

  final dynamic tag;

  final Widget Function(BuildContext context, T bLoC) builder;

  @override
  _BLoCBuilderState<T> createState() => _BLoCBuilderState<T>();
}

class _BLoCBuilderState<T extends BLoC> extends State<BLoCBuilder<T>> {

  final b = BLoCState<T>();

  @override
  void initState() {
    super.initState();
    b.bLoCStateInit(widget.tag, _handleBLoCChanged);
  }

  @override
  void dispose() {
    b.bLoCStateDispose(_handleBLoCChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, b.bLoc);
  }

  void _handleBLoCChanged() {
    setState(() {
    });
  }
}

class BLoCBuilder2<T1 extends BLoC, T2 extends BLoC> extends StatefulWidget {

  const BLoCBuilder2({Key? key, this.tag1, this.tag2, required this.builder}) : super(key: key);

  final dynamic tag1;
  final dynamic tag2;
  final Widget Function<T1, T2>(BuildContext context, T1 b1, T2 b2) builder;

  @override
  _BLoCBuilderState2<T1, T2> createState() => _BLoCBuilderState2<T1, T2>();
}

class _BLoCBuilderState2<T1 extends BLoC, T2 extends BLoC> extends State<BLoCBuilder2<T1, T2>> {

  final BLoCState<T1> _b1 = BLoCState();
  final BLoCState<T2> _b2 = BLoCState();

  @override
  void initState() {
    super.initState();
    _b1.bLoCStateInit(null, _handleBLoCChanged);
    _b2.bLoCStateInit(null, _handleBLoCChanged);
  }

  @override
  void dispose() {
    _b1.bLoCStateDispose(_handleBLoCChanged);
    _b2.bLoCStateDispose(_handleBLoCChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _b1.bLoc, _b2.bLoc);
  }

  void _handleBLoCChanged() {
    setState(() {
    });
  }
}


