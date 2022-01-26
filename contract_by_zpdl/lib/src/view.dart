import 'package:flutter/widgets.dart';

import 'contract.dart';
import 'exceptions.dart';
import 'service.dart';

abstract class View<T extends Presenter> extends StatelessWidget {
  View({Key? key, required BuildContext context, dynamic tag})
      : presenter = Presenter.of<T>(context),
        super(key: key);

  final T presenter;

  @override
  StatelessElement createElement() => _ViewElement(this);
}

class _ViewElement extends StatelessElement with ViewContract {
  _ViewElement(View widget) : super(widget);

  @override
  View get widget => super.widget as View;

  @override
  void mount(Element? parent, Object? newSlot) {
    initViewContract(widget.presenter, markNeedsBuild);
    super.mount(parent, newSlot);
  }

  @override
  void unmount() {
    disposeViewContract(widget.presenter, markNeedsBuild);
    super.unmount();
  }
}

class ViewBuilder<T extends Presenter> extends StatefulWidget {
  ViewBuilder({Key? key, required this.builder, this.notFoundPresenter})
      : super(key: key);

  final Widget Function(BuildContext context, T presenter) builder;
  final Widget Function(BuildContext context)? notFoundPresenter;

  @override
  State<ViewBuilder<T>> createState() => _ViewBuilderState<T>();
}

class _ViewBuilderState<T extends Presenter> extends State<ViewBuilder<T>>
    with ViewContract {
  T? _presenter;

  @override
  void initState() {
    super.initState();

    try {
      final presenter = Presenter.of<T>(context);
      initViewContract(presenter, _setState);
      _presenter = presenter;
    } catch (_) {}
  }

  @override
  void dispose() {
    final presenter = _presenter;
    if (presenter != null) {
      disposeViewContract(presenter, _setState);
    }
    _presenter = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final presenter = _presenter;
    if (presenter != null) {
      return widget.builder(context, presenter);
    } else if (widget.notFoundPresenter != null) {
      return widget.notFoundPresenter!(context);
    }
    throw Exceptions.VIEW_BUILDER_PRESENTER_NOT_FOUND.exception;
  }

  void _setState() {
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant ViewBuilder<T> oldWidget) {
    if (_presenter == null) {
      try {
        final presenter = Presenter.of<T>(context);
        initViewContract(presenter, _setState);
        setState(() {
          _presenter = presenter;
        });
      } catch (_) {}
    }

    super.didUpdateWidget(oldWidget);
  }
}

class ServiceBuilder<T extends Service> extends StatefulWidget {
  ServiceBuilder({Key? key, required this.builder}) : super(key: key);

  final Widget Function(BuildContext context, T service) builder;

  @override
  State<ServiceBuilder<T>> createState() => _ServiceBuilderState<T>();
}

class _ServiceBuilderState<T extends Service> extends State<ServiceBuilder<T>> {
  late final T _service;

  @override
  void initState() {
    super.initState();

    try {
      _service = Service.of<T>();
      _service.addListener(_setState);
    } catch (_) {}
  }

  @override
  void dispose() {
    _service.removeListener(_setState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _service);
  }

  void _setState() {
    setState(() {});
  }
}
