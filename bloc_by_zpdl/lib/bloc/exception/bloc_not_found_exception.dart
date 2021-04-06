
class BLoCNotFoundException implements Exception  {
  final String message;

  BLoCNotFoundException(this.message);

  @override
  String toString() {
    return 'BLoCNotFoundException{message: $message}';
  }
}