import 'package:flutter/widgets.dart';

import 'bloc_exception.dart';

typedef OnBLoCDisposed = void Function(BLoC bLoC);
typedef OnBLoCContext = BuildContext Function();


/// Business Logic Component
abstract class BLoC extends ChangeNotifier {

  OnBLoCDisposed? onBLoCDisposed;

  void init();

  @override
  void dispose() {
    super.dispose();

    onBLoCDisposed?.call(this);
    onBLoCDisposed = null;
  }
}

mixin BLoCContext on BLoC {
  OnBLoCContext? onContext;

  BuildContext get context {
    final onContext = this.onContext;
    if(onContext != null) {
      onContext();
    }
    throw BLoCContextException();
  }
}

mixin BLoCLifeCycle {

  void onResume();

  void onPause();

  bool _resumed = false;
  bool _resumeProvider = false;
  int _attachViewCount = 0;

  void attachView() {
    _attachViewCount++;
    _onLifeCycle();
  }

  void detachView() {
    _attachViewCount--;
    _onLifeCycle();
  }

  void resumeProvider() {
    _resumeProvider = true;
    _onLifeCycle();
  }

  void pauseProvider() {
    _resumeProvider = false;
    _onLifeCycle();
  }

  void _onLifeCycle() {
    final resumed = _attachViewCount > 0 && _resumeProvider;
    if(_resumed != resumed) {
      _resumed = resumed;
      if(_resumed) {
        onResume();
      } else {
        onPause();
      }
    }
  }
}

// mixin BLoCProvider {
//   late BLoCContextCallback bLoCContextCallback;
//
//   final List<BLoC> _bLoCs = [];
//
//   void addBLoC(BLoC bLoC) {
//     bLoC._contextCallback = bLoCContextCallback;
//   }
//
// }

// class _BLoCProvider {
//   static final _BLoCProvider _instance = _BLoCProvider._();
//
//   static final _BLoCProvider instance = _instance;
//
//   _BLoCProvider._();
//
//   final List<_BLoCProviderState> states = [];
//
//   void _pushState(_BLoCProviderState state) {
//     states.add(state);
//   }
//
//   void _popState(_BLoCProviderState state) {
//     states.remove(state);
//   }
// }
//
// abstract class BLoCRoute extends StatefulWidget {
//
//   final Widget child;
//
//   const BLoCProvider({Key? key, required this.child, }) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _BLoCProviderState();
//
//   List<BLoC> onCreateBLoCs(BuildContext context);
// }
//
// class _BLoCRouteState extends State<BLoCRoute> {
//
//   late List<BLoC> bLoCs;
//
//   @override
//   void initState() {
//     super.initState();
//
//     bLoCs = widget.onCreateBLoCs(context);
//     for(final bLoC in bLoCs) {
//       bLoC._contextCallback = () => context;
//     }
//
//     _BLoCProvider.instance._pushState(this);
//   }
//
//   @override
//   void dispose() {
//     _BLoCProvider.instance._popState(this);
//
//     for(final bLoC in bLoCs) {
//       bLoC.dispose();
//     }
//     bLoCs.clear();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }