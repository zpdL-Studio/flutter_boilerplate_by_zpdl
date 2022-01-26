enum Exceptions {
  NOT_FOUND_ROUTE_APP,
  NOT_FOUND_PRESENTER,
  NOT_FOUND_SERVICE,
  CONTRACT_CONTEXT,
  PRESENTER_CONTEXT,
  VIEW_BUILDER_PRESENTER_NOT_FOUND,
}

extension ExceptionsExtension on Exceptions {
  CBStateException get exception => CBStateException(this);
}

class CBStateException implements Exception  {
  final Exceptions exception;

  CBStateException(this.exception);

  @override
  String toString() {
    return 'CBStateException{state: $exception}';
  }
}

