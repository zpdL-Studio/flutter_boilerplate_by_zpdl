import 'package:flutter/widgets.dart';

import 'exceptions.dart';

class Service extends ChangeNotifier {

  static T of<T extends Service>() {
    final service = _Services.instance.of<T>();
    if (service != null) {
      return service;
    }
    throw Exceptions.NOT_FOUND_SERVICE.exception;
  }

  static bool put<T extends Service>(T service) =>
      _Services.instance.put<T>(service);

  static bool lazyPut<T extends Service>(ServiceLazyPut<T> service) =>
      _Services.instance.lazyPut<T>(service);

  static void remove<T extends Service>() => _Services.instance.remove<T>();

  static void disposeService() => _Services.instance.dispose();

  @protected
  @mustCallSuper
  void init() {}

  @override
  @protected
  @mustCallSuper
  void dispose() {
    super.dispose();
  }
}

abstract class _Service<T extends Service> {
  T get service;

  void dispose();
}

class _ServiceInstance<T extends Service> extends _Service<T>{
  @override
  final T service;

  _ServiceInstance(this.service);

  @override
  void dispose() {
    service.dispose();
  }
}

typedef ServiceLazyPut<T extends Service> = T Function();

class _ServiceLazy<T extends Service> extends _Service<T> {
  final ServiceLazyPut<T> _serviceLazyPut;
  T? _service;

  _ServiceLazy(this._serviceLazyPut);

  @override
  T get service {
    _service ??= _serviceLazyPut()..init();
    return _service!;
  }

  @override
  void dispose() {
    _service?.dispose();
  }
}

class _Services {

  static final _Services _instance = _Services._();

  static _Services get instance => _instance;

  _Services._();

  final Map<Type, _Service> _services = {};

  bool put<T extends Service>(T service) {
    if (!_services.containsKey(T)) {
      _services[T] = _ServiceInstance(service..init());
      return true;
    }
    return false;
  }

  bool lazyPut<T extends Service>(ServiceLazyPut<T> service) {
    if (!_services.containsKey(T)) {
      _services[T] = _ServiceLazy(service);
      return true;
    }
    return false;
  }

  void remove<T extends Service>() {
    _services.remove(T)?.dispose();
  }

  T? of<T extends Service>() {
    final service = _services[T]?.service;
    if (service is T) {
      return service;
    }
    return null;
  }

  void dispose() {
    for(final service in _services.values) {
      service.dispose();
    }
    _services.clear();
  }
}