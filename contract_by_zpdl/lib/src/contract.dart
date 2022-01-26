import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'exceptions.dart';
import 'page.dart';

part 'presenter.dart';
part 'router.dart';

class Contract {

  static final Contract _instance = Contract._();

  static Contract get instance => _instance;

  Contract._();

  final RouteInformationParser<Object> parser = _RouteInformationParser();

  _RouterDelegate? _routerDelegate;

  RouterDelegate<Object> initRouterDelegate(
      HomePageBinder home, List<PageBinder> pages,
      [PageBinder page404 = const Page404()]) {
    _routerDelegate ??= _RouterDelegate(
        contract: this, home: home, pages: pages, page404: page404);
    return _routerDelegate!;
  }

  BuildContext? get context => _routerDelegate?._navigatorKey.currentContext;

  static Future<dynamic> push(String routeName,
      {Map<String, String> queryParameter = const {}, Object? arguments}) {
    final page = Contract.instance._routerDelegate?._getPage(routeName);
    if (page != null) {
      final completer = Completer();
      final binder = _PresenterBinder(
        configure: _Configure(
            Uri(
                path: routeName,
                queryParameters:
                    queryParameter.isNotEmpty ? queryParameter : null),
            arguments: arguments),
        page: page,
        popCompleter: completer,
      );
      Contract.instance._pushBinder(binder);
      Contract.instance._routerDelegate?._notifyListeners();
      return completer.future;
    }

    return Future.value(null);
  }

  final List<_PresenterBinder> _binders = [];

  _PresenterBinder? _pagePresenterByContext(BuildContext context) {
    _PresenterBinder? pagePresenter;
    if(context is StatefulElement && context.state is _ContractState) {
      pagePresenter = (context.state as _ContractState)._bucket;
    } else {
      context.visitAncestorElements((element) {
        if (element is StatefulElement && element.state is _ContractState) {
          pagePresenter = (element.state as _ContractState)._bucket;
          return false;
        }
        return true;
      });
    }
    return pagePresenter;
  }

  T? _presentByContext<T extends Presenter>(BuildContext context) => _pagePresenterByContext(context)?.of<T>();

  _PresenterBinder? get lastBinder => _binders.isNotEmpty ? _binders.last : null;

  void _pushBinder(_PresenterBinder binder) {
    for (final binder in _binders) {
      binder._pausePage();
    }
    _binders.add(binder.._resumePage());
    print('_pushBinder ${binder.configure.uri.toString()}');
    // SystemNavigator.routeInformationUpdated(location: binder.configure.uri.toString(), replace: true);
  }

  void _popBinder(_PresenterBinder binder, dynamic result) {
    _binders.remove(binder
      .._pausePage()
      .._didPop(result));
    final lastBinder = this.lastBinder;
    if(lastBinder != null) {
      lastBinder._resumePage();
      print('_popBinder ${lastBinder.configure.uri.toString()}');
      // SystemNavigator.routeInformationUpdated(location: lastBinder.configure.uri.toString(), replace: true);
    }
  }

  void _setNewContract(_RouterDelegate delegate, _Configure configure) {
    int? index;

    if (_binders.isEmpty) {
      if (configure.path == '/') {
        _pushBinder(
            _PresenterBinder(configure: configure, page: delegate.home));
      } else {
        _pushBinder(
            _PresenterBinder(configure: configure, page: delegate.home));
        _pushBinder(_PresenterBinder(
            configure: configure, page: delegate._getPage(configure.path)));
      }
    } else {
      for (int i = _binders.length - 1; i >= 0; i--) {
        if (_binders[i].configure.uri == configure.uri) {
          index = i;
          break;
        }
      }

      if (index != null) {
        for (int i = index + 1; i < _binders.length; i++) {
          _binders[i]._pausePage();
          _binders[i]._didPop(null);
        }
        _binders.removeRange(index + 1, _binders.length);
        final lastBinder = this.lastBinder;
        if(lastBinder != null) {
          lastBinder._resumePage();
          print('_setNewContract ${lastBinder.configure.uri.toString()}');
          // SystemNavigator.routeInformationUpdated(location: lastBinder.configure.uri.toString(), replace: true);
        }
      } else {
        _pushBinder(_PresenterBinder(
            configure: configure, page: delegate._getPage(configure.path)));
      }
    }
  }
}

class _PresenterBinder implements PresenterBinder {

  final _Configure configure;
  final PageBinder page;
  final Completer<dynamic>? popCompleter;

  _PresenterBinder({required this.configure, required this.page, this.popCompleter});
  
  void _didPop(dynamic result) {
    popCompleter?.complete(result);
  }

  final Map<Type, _Presenter> _presenters = {};
  bool _resume = false;
  bool _appLifecycle = false;

  BuildContext Function()? _context;

  BuildContext get context {
    final context = _context?.call();
    if(context != null) {
      return context;
    }
    throw Exceptions.CONTRACT_CONTEXT.exception;
  }

  bool _initPage(BuildContext Function() context) {
    _context = context;
    return page.binding(context(), this, configure.uri.queryParameters, configure.arguments);
  }

  void _disposePage() {
    for(final value in _presenters.values) {
      value.dispose();
    }
    _presenters.clear();

    _context = null;
  }

  void _resumePage() {
    if(!_resume) {
      _resume = true;
      for(final value in _presenters.values) {
        final presenter = value.presenterOrNull;
        if (presenter is PresenterLifeCycle) {
          presenter._resumePage();
        }
      }
    }
  }

  void _pausePage() {
    if(_resume) {
      _resume = false;
      for(final value in _presenters.values) {
        final presenter = value.presenterOrNull;
        if (presenter is PresenterLifeCycle) {
          presenter._pausePage();
        }
      }
    }
  }

  void _resumeAppLifecycle() {
    if(!_appLifecycle) {
      _appLifecycle = true;
      for (final value in _presenters.values) {
        final presenter = value.presenterOrNull;
        if (presenter is PresenterLifeCycle) {
          presenter._resumeAppLifecycle();
        }
      }
    }
  }

  void _pauseAppLifecycle() {
    if(_appLifecycle) {
      _appLifecycle = false;
      for(final value in _presenters.values) {
        final presenter = value.presenterOrNull;
        if (presenter is PresenterLifeCycle) {
          presenter._pauseAppLifecycle();
        }
      }
    }
  }

  void _initPresenter(Presenter presenter) {
    presenter._attachContract();
    if(presenter is PresenterContext) {
      presenter._context = () => context;
    }
    if (presenter is PresenterLifeCycle) {
      if(_resume) {
        presenter._resumePage();
      }
      if(_appLifecycle) {
        presenter._resumeAppLifecycle();
      }
    }
  }

  void _disposePresenter(Presenter presenter) {
    if(presenter is PresenterContext) {
      presenter._context = null;
    }
    if (presenter is PresenterLifeCycle) {
      presenter._pausePage();
    }
    presenter._detachContract();
  }

  @override
  bool lazyPut<T extends Presenter>(PresenterBinderLazyPut<T> presenter) {
    if(!_presenters.containsKey(T)) {
      _presenters[T] = _PresenterLazyPut(presenter, _initPresenter, _disposePresenter);
      return true;
    }
    return false;
  }

  @override
  bool put<T extends Presenter>(T presenter) {
    if(!_presenters.containsKey(T)) {
      _presenters[T] = _PresenterInstance(presenter, _initPresenter, _disposePresenter);
      return true;
    }
    return false;
  }

  @override
  T? remove<T extends Presenter>() {
    final presenter = _presenters.remove(T)?.presenterOrNull;
    presenter?.dispose();

    if(presenter is T) {
      return presenter;
    }
    return null;
  }

  @override
  T? of<T extends Presenter>() {
    final presenter = _presenters[T]?.presenter;
    if (presenter is T) {
      return presenter;
    }
    return null;
  }
}

class _ContractWidget extends StatefulWidget {
  final _PresenterBinder bucket;

  const _ContractWidget({Key? key, required this.bucket}) : super(key: key);

  @override
  _ContractState createState() => _ContractState();
}

class _ContractState extends State<_ContractWidget> with WidgetsBindingObserver { // ignore: prefer_mixin

  bool _init = false;
  late final _PresenterBinder _bucket;

  @override
  void initState() {
    super.initState();

    _bucket = widget.bucket;
    try {
      final result = _bucket._initPage(() => context);
      if (result == false) {
        Navigator.pop(context);
        return;
      }
    } catch (_) {
      Navigator.pop(context);
      return;
    }

    final lifecycleState = WidgetsBinding.instance?.lifecycleState;
    if(lifecycleState == AppLifecycleState.resumed) {
      _bucket._resumeAppLifecycle();
    }
    WidgetsBinding.instance?.addObserver(this);

    _init = true;
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _bucket._disposePage();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed) {
      _bucket._resumeAppLifecycle();
    } else {
      _bucket._pauseAppLifecycle();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _init ? _bucket.page.builder(context) : Container();
  }
}

mixin ViewContract {
  void initViewContract(Presenter presenter, VoidCallback markNeedsBuild) {
    presenter.addListener(markNeedsBuild);
    presenter._attachView();
  }

  void disposeViewContract(Presenter presenter, VoidCallback markNeedsBuild) {
    presenter.removeListener(markNeedsBuild);
    presenter._detachView();
  }
}

abstract class _Presenter<T extends Presenter> {
  final void Function(Presenter presenter) _initPresenter;
  final void Function(Presenter presenter) _disposePresenter;

  _Presenter(this._initPresenter, this._disposePresenter);

  T get presenter;

  T? get presenterOrNull;

  void dispose();
}

class _PresenterInstance<T extends Presenter> extends _Presenter<T> {
  @override
  final T presenter;

  @override
  T? get presenterOrNull => presenter;

  _PresenterInstance(
      this.presenter,
      void Function(Presenter presenter) initPresenter,
      void Function(Presenter presenter) disposePresenter)
      : super(initPresenter, disposePresenter) {
    _initPresenter(presenter);
  }

  @override
  void dispose() {
    _disposePresenter(presenter);
  }
}

class _PresenterLazyPut<T extends Presenter> extends _Presenter<T> {
  final PresenterBinderLazyPut<T> _presenterLazyPut;

  T? _presenter;

  @override
  T? get presenterOrNull => _presenter;

  _PresenterLazyPut(
      this._presenterLazyPut,
      void Function(Presenter presenter) initPresenter,
      void Function(Presenter presenter) disposePresenter)
      : super(initPresenter, disposePresenter);

  @override
  T get presenter {
    if(_presenter == null) {
      final lazy = _presenterLazyPut();
      _initPresenter(lazy);
      _presenter = lazy;
    }
    return _presenter!;
  }

  @override
  void dispose() {
    final presenter = _presenter;
    if (presenter != null) {
      _disposePresenter(presenter);
    }
  }
}