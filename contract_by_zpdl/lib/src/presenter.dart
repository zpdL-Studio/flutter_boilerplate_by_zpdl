part of 'contract.dart';

class Presenter extends ChangeNotifier {

  static T of<T extends Presenter>(BuildContext context) {
    final presenter = Contract.instance._presentByContext<T>(context);
    if (presenter != null) {
      return presenter;
    }
    throw Exceptions.NOT_FOUND_PRESENTER.exception;
  }

  bool _attachInit = false;
  bool _attachDisposed = false;

  final ValueNotifier<int> _attachViewCount = ValueNotifier(0);

  bool get isAttachView => _attachViewCount.value > 0;

  final ValueNotifier<bool> _isAttachContract = ValueNotifier(false);

  bool get isAttachContract => _isAttachContract.value;

  Presenter() {
    _isAttachContract.addListener(didChangeAttach);
    _attachViewCount.addListener(didChangeAttach);
  }

  @protected
  @mustCallSuper
  void init() {}

  @override
  @protected
  @mustCallSuper
  void dispose() {
    _isAttachContract.removeListener(didChangeAttach);
    _attachViewCount.removeListener(didChangeAttach);
    super.dispose();
  }

  @mustCallSuper
  void didChangeAttach() {
    if(isAttachContract) {
      if(!_attachInit) {
        _attachInit = true;
        init();
      }
    } else if(!isAttachView && !_attachDisposed) {
      _attachDisposed = true;
      dispose();
    }
  }

  void _attachView() => _attachViewCount.value++;

  void _detachView() => _attachViewCount.value--;

  void _attachContract() {
    if(!isAttachContract) {
      _isAttachContract.value = true;
    }
  }

  void _detachContract() {
    if(isAttachContract) {
      _isAttachContract.value = false;
    }
  }
}

typedef PresenterBinderLazyPut<T extends Presenter> = T Function();

abstract class PresenterBinder {
  bool lazyPut<T extends Presenter>(PresenterBinderLazyPut<T> presenter);

  bool put<T extends Presenter>(T presenter);

  T? remove<T extends Presenter>();

  T? of<T extends Presenter>();
}

mixin PresenterContext on Presenter {
  BuildContext Function()? _context;

  BuildContext get context {
    final context = _context?.call();
    if (context != null) {
      return context;
    }
    throw Exceptions.PRESENTER_CONTEXT.exception;
  }

  void pop([Object? result]) {
    try {
      Navigator.pop(context, result);
    } catch (_) {}
  }
}

mixin PresenterLifeCycle on Presenter {

  void onLifeCycleResume();

  void onLifeCyclePause();

  bool _resumed = false;
  bool _resumePageState = false;
  bool _resumeAppLifecycleState = false;

  void _resumePage() {
    _resumePageState = true;
    _didChangeLifeCycle();
  }

  void _pausePage() {
    _resumePageState = false;
    _didChangeLifeCycle();
  }

  void _resumeAppLifecycle() {
    _resumeAppLifecycleState = true;
    _didChangeLifeCycle();
  }

  void _pauseAppLifecycle() {
    _resumeAppLifecycleState = false;
    _didChangeLifeCycle();
  }

  @override
  void didChangeAttach() {
    super.didChangeAttach();
    _didChangeLifeCycle();
  }

  void _didChangeLifeCycle() {
    final resumed = _resumePageState && _resumeAppLifecycleState && isAttachView;
    if(_resumed != resumed) {
      _resumed = resumed;
      if(_resumed) {
        onLifeCycleResume();
      } else {
        onLifeCyclePause();
      }
    }
  }
}