import 'package:flutter/widgets.dart';

import 'bloc.dart';
import 'bloc_exception.dart';

typedef BLoCProviderBinding = void Function(BLoCProvider provider);

class _BLoCProviderKey {
  final dynamic tag;
  final Type type;

  _BLoCProviderKey(this.tag, this.type);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is _BLoCProviderKey &&
              runtimeType == other.runtimeType &&
              tag == other.tag &&
              type == other.type;

  @override
  int get hashCode => tag.hashCode ^ type.hashCode;
}

class BLoCProviders {

  static final BLoCProviders _instance = BLoCProviders._();

  static final BLoCProviders instance = _instance;

  BLoCProviders._();

  final List<BLoCProvider> providers = [];
  final Map<_BLoCProviderKey, BLoC> _bLoCs = {};

  T find<T extends BLoC>({dynamic tag}) {
    final bLoC = _bLoCs[_BLoCProviderKey(tag, T)];
    if(bLoC != null) {
      return bLoC as T;
    }

    throw BLoCNotFoundException();
  }

  BLoC? _findByKey(_BLoCProviderKey key) => _bLoCs[key];

  void add(BuildContext context, BLoC bLoC, {dynamic tag}) {
    context.visitAncestorElements((element) {
      if (element is StatefulElement && element.state is BLoCProviderState) {
        print('KKH addBLoC ${element.state}');
        return true;
      }
      print('KKH addBLoC Not Found $element');
      return false;
    });
  }

  bool _addByKey(_BLoCProviderKey key, BLoC bLoC) {
    if(_bLoCs.containsKey(key)) {
      return false;
    }
    _bLoCs[key] = bLoC;
    return true;
  }

  BLoC? _removeByKey(_BLoCProviderKey key) => _bLoCs.remove(key);

  void _addBLoCProviderState(BLoCProvider provider) {
    for (final provider in providers) {
      provider.pauseProvider();
    }

    providers.add(provider..resumeProvider());
  }

  void _removeBLoCProviderState(BLoCProvider provider) {
    providers.remove(provider..pauseProvider());
    if (providers.isNotEmpty) providers.last.resumeProvider();
  }
}

class BLoCProviderWidget extends StatefulWidget {
  final BLoCProviderBinding? binding;
  final WidgetBuilder builder;

  const BLoCProviderWidget({Key? key, this.binding, required this.builder}) : super(key: key);

  @override
  BLoCProviderState createState() => BLoCProviderState();
}

class BLoCProviderState extends State<BLoCProviderWidget> with BLoCProvider {

  @override
  void initState() {
    super.initState();

    initProvider();
    widget.binding?.call(this);
  }

  @override
  void dispose() {
    super.dispose();

    disposeProvider();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}

mixin BLoCProvider<T extends StatefulWidget> on State<T> {
  final List<_BLoCProviderKey> _bLoCKeys = [];
  bool _resumeProvider = false;

  void initProvider() {
    BLoCProviders.instance._addBLoCProviderState(this);
  }

  void disposeProvider() {
    BLoCProviders.instance._removeBLoCProviderState(this);

    for(final key in _bLoCKeys) {
      final bLoC = BLoCProviders.instance._removeByKey(key);
      if(bLoC != null) {
        bLoC.onBLoCDisposed = null;
        bLoC.dispose();
      }
    }
    _bLoCKeys.clear();
  }

  void resumeProvider() {
    if(!_resumeProvider) {
      _resumeProvider = true;
      for (final key in _bLoCKeys) {
        final bLoC = BLoCProviders.instance._removeByKey(key);
        if (bLoC is BLoCLifeCycle) {
          bLoC.resumeProvider();
        }
      }
    }
  }

  void pauseProvider() {
    if(_resumeProvider) {
      _resumeProvider = false;
      for (final key in _bLoCKeys) {
        final bLoC = BLoCProviders.instance._findByKey(key);
        if (bLoC is BLoCLifeCycle) {
          (bLoC).pauseProvider();
        }
      }
    }
  }

  BLoC _initBLoC(_BLoCProviderKey key, BLoC bLoC) {
    bLoC.onBLoCDisposed = (_) {
      if(_bLoCKeys.remove(key)) {
        BLoCProviders.instance._removeByKey(key);
        if(_ is BLoCContext) {
          _.onContext = null;
        }
      }
    };

    if(bLoC is BLoCContext) {
      bLoC.onContext = () => context;
    }
    bLoC.init();
    return bLoC;
  }

  void addBLoC(BLoC bLoC, {dynamic tag}) {
    final key = _BLoCProviderKey(tag, bLoC.runtimeType);
    if(BLoCProviders.instance._addByKey(key, bLoC)) {
      _bLoCKeys.add(key);
      _initBLoC(key, bLoC);
      if (_resumeProvider && bLoC is BLoCLifeCycle) {
        bLoC.resumeProvider();
      }
    }
  }
}